{ config, lib, pkgs, ... }: {

  imports = [
    ../../modules/profiles/desktop.nix
    ./hardware-configuration.nix
    ../../modules/hardware/surface-pro-9-intel
    ../../modules/profiles/secure-boot.nix
  ];

  networking.hostName = "peter-pc";

  users.users.petms = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "scanner" "lp" ];
  };

  services.restic.backups.remote = {
    repository = "sftp://petms@opcc.opcc.tk:2272/backups/peter-pc";
    passwordFile = "/etc/nixos/restic-password";
    paths = [
      "/home"
    ];
    exclude = [
      "/home/*/.cache"
      "/home/*/Downloads"
    ];
    timerConfig = {
      OnCalendar = "00:05";
      RandomizedDelaySec = "5h";
    };
  };

  time.timeZone = "America/Toronto";

  console.keyMap = "us";

  networking.wireless.iwd.settings = {
    General = {
      Country = "CA";
      # Prevent tracking across networks
      AddressRandomization = "network";
    };
    Rank = {
      # Prefer faster bands
      BandModifier2_4GHz = 1.0;
      BandModifier5GHz = 3.0;
      BandModifier6GHz = 10.0;
    };
  };

  zramSwap.enable = true;

  security.tpm2.enable = true;

  boot.initrd.services.lvm.enable = true;

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.plymouth.enable = true;

  system.stateVersion = "24.05";

}
