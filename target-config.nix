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
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQDuNResYJNUNlReRIxPMMnI3hAaW5dNs3E2qoeqHsU/nwnL+czVKOkHnG8gQaKSN7q0wVP3o3ozSsGHdYBJ0YrAYMccOPGkPJ6Aua/7LBkxTc1bVbGrPAEVDYfvNKTU0KjbOfUt6bAbtx1KzbzttBHRR14AxHSUH3ELja6a1foATQWyArLmykmo8aFp75n9+b8XVkmtVtSB0VFibMGwLekNgTD1zOZfzqjxD2EQop279Y8s9kfadpxznONLBNgNUZEzkk++MTh2a6OXW4WA2+dH8WaG2hwjghYbqSDlYe9yjyxhRS0ZtUuVlxlMlTsn0MIt/fYlYNSJts4I11ehBQFkzWUv/i/BgKFKX2M1A5fZTI9emlKJ/Iz3EyXNg1VNc/8iCVaWMpKUbT8Hao8qvwihoZegyVZRmCbUDyxVpjy2Qyl3/dl8mjsYbzYK6CyLo198rCeSrYlF7c81KikPmNuibzSL0UHvA94HK7hVWfu+iZKPZOYVdIle25+hZcL+s7GROy5iGWA9qwgaqXShbqhyyg/lXCY8MdyDBdomWrdk9SvQ0hbNLwSrNlcHAoO3H8/HRcoW4/faiFsm8SFF4RnsIYfVNKCUYlf4kspbHUxUWuEMtOxpo/uu3Zs7hI+TQL9FKwrLRgnu72sx0Y1o4PIGHUldSgzoYAxL+EaF3qgYhoOyiVFa5IRioaG9FRFJ1hboq+0XxQXYzJ8z9CrRa/Gxrp/Etqdevm8IjuOWelDAR4UPgeQsvjHvZVxLOGay8wBtA0/My9meouPDn7jzPjfFUcmdB99PM/PfrqJBC+WdldEfURrAeax6b2LidFl3bN4BLGwK0BlPybjgj7jm1THMnnM4F7BmhzA8MN1tmcEIiZSbW3lRjMxTikGkhvq1NbMp/k6ZmMkwJcwORSJRVdji3wYOuQxl2/u+Ey2NtBXyA5TomPvkWR/h9us+2/8WOxVlpjs6PtYEguehLbuqPWANM1FG9ngAMc1yGMp9YXPKQn+xVvOssOK6VoAu57q9zHJ5GQe8Pm6+2Qpq7hWRDkxIfnDGAeLDIlHa4JunX+okSCH14fx2PpwRfQ1UUhp5wnDtcAfkWGmq82HQknAigNWih5LqPthfjMuhUUcgYsciWYFKZbum4/yecfXUUx9SlcAwVrEZ+kwvNw1UsjrRtITsCBaBlSDpioyXYmJ6ldxUOKZiqAvAKeB0zRF3xpALWZuADh22BzWaNeLL8Gw5uR9TV7PGQ9wpd07SRsdabqLtYqg2P0/t+zPlKHNkL80vZjmuYJeHZ6Zmv3K4PsKEsHG3nXcA8PUI09IfvBbUnzlUb46V5K2O6E3iiSeQBRv7jWEkwGZy9/lBMUM7Qxw3a9Hv till@hoeppner.ws"
  ];

  boot.kernelParams = [
    "panic=30" "boot.panic_on_fail" # reboot the machine upon fatal boot issues
  ];
}
