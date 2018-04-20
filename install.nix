{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.kexec.justdoit;
in {
  options = {
    kexec.justdoit = {
      rootDevice = mkOption {
        type = types.str;
        default = "/dev/sda";
        description = "the root block device that justdoit will nuke from orbit and force nixos onto";
      };
      bootSize = mkOption {
        type = types.int;
        default = 256;
        description = "size of /boot in mb";
      };
      swapSize = mkOption {
        type = types.int;
        default = 1024;
        description = "size of swap in mb";
      };
    };
  };

  config = lib.mkIf true {
    system.build.justdoit = pkgs.writeScriptBin "justdoit" ''
      #!${pkgs.stdenv.shell}

      set -e

      vgchange -a n

      dd if=/dev/zero of=${cfg.rootDevice} bs=512 count=10000

      sfdisk ${cfg.rootDevice} <<EOF
      label: dos
      device: ${cfg.rootDevice}
      unit: sectors
      ${cfg.rootDevice}1 : size=${toString (2048 * cfg.bootSize)}, type=83
      ${cfg.rootDevice}2 : size=${toString (2048 * cfg.swapSize)}, type=82
      ${cfg.rootDevice}3 : type=83
      EOF
      export ROOT_DEVICE=${cfg.rootDevice}3
      export SWAP_DEVICE=${cfg.rootDevice}2

      mkdir -p /mnt

      mkfs.ext4 ${cfg.rootDevice}1 -L NIXOS_BOOT
      mkswap $SWAP_DEVICE -L NIXOS_SWAP
      mkfs.ext4 $ROOT_DEVICE -L NIXOS_ROOT

      swapon $SWAP_DEVICE
      mount $ROOT_DEVICE /mnt/
      mkdir -p /mnt/boot/
      mount -t ext4 ${cfg.rootDevice}1 /mnt/boot/

      nixos-generate-config --root /mnt/

      hostId=$(echo $(head -c4 /dev/urandom | od -A none -t x4))
      cp ${./target-config.nix} /mnt/etc/nixos/configuration.nix

      cat > /mnt/etc/nixos/generated.nix <<EOF
      { ... }: {
        boot.loader.grub.device = "${cfg.rootDevice}";
        networking.hostId = "$hostId"; # required for zfs use
      }
      EOF

      nixos-install --no-root-passwd
      reboot
    '';
    environment.systemPackages = [ config.system.build.justdoit ];

    systemd.services.performInstall = {
      requiredBy = [ "multi-user.target" ];

      path = with pkgs; [
        nixStable lvm2 utillinux e2fsprogs
      ] ++ (with config.system.build; [
        nixos-install nixos-generate-config
      ]);
      
      environment.NIX_PATH = lib.concatStringsSep ":" config.nix.nixPath;

      script = "${config.system.build.justdoit}/bin/justdoit";
    };
  };
}
