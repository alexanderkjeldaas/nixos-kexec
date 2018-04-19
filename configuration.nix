# new cmd: nix-build '<nixpkgs/nixos>' -A config.system.build.kexec_tarball -I nixos-config=./configuration.nix -Q -j 4

{ lib, pkgs, config, ... }:

with lib;

{
  imports = [
    <nixpkgs/nixos/modules/installer/netboot/netboot-minimal.nix>
    ./kexec.nix
    ./install.nix
  ];

  # nixos-install doesn't work with nixUnstable
  nix.package = mkForce pkgs.nixStable;

  boot.loader.grub.enable = false;
  boot.kernelParams = [
    "console=ttyS0,115200"          # allows certain forms of remote access, if the hardware is setup right
    "panic=30" "boot.panic_on_fail" # reboot the machine upon fatal boot issues
  ];

  networking.hostName = "kexec";
  hardware = {
    enableRedistributableFirmware = mkForce false;
    opengl.driSupport = mkForce false;
  };
}
