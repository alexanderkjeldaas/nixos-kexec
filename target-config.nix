{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./generated.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  users.users.root.openssh.authorizedKeys.keys = [
  ];

  boot.kernelParams = [
    "panic=30" "boot.panic_on_fail" # reboot the machine upon fatal boot issues
  ];
}
