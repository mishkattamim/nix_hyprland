
{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./vm.nix
    ];

  virtualisation.waydroid.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.extraEntries = {
  "fydeos.conf" = ''
    title   FydeOS
    # This path is relative to the root of the EFI System Partition (/boot)
    efi     /EFI/fydeos/bootx64.efi
  '';
};

  boot.supportedFilesystems.exfat = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
  # Set your time zone.
  time.timeZone = "Asia/Dhaka";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ryuuma = {
    isNormalUser = true;
    description = "Mishkat TaMim";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [ ];
  };
  
  programs.fish = {
  enable = true; 
  # Use shellInit to define a Fish function for the tmc Flatpak command
  shellInit = ''
    function tmc
      flatpak run fi.mooc.tmc.tmc-cli-rust $argv
    end
  '';
};
  
  # --- Enable Hyprland ---
  programs.hyprland = {
  	enable = true;
  	xwayland.enable = true;
  	withUWSM = true;

  };
  
  hardware.graphics = {
  enable = true;
};

# For Intel HD Graphics (Skylake/Gen9 or older)
hardware.graphics.extraPackages = with pkgs; [
  # Include vulkan drivers if not already
  mesa
  libva # For video acceleration 
  libvdpau # For video acceleration
];

  programs.gamemode.enable = true;
  # Install firefox
  programs.firefox.enable = true;
  #steam
  programs.steam.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #flatpak
  services.flatpak.enable = true;
  #warp
  services.cloudflare-warp.enable = true;
  

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
  ];

  # Enable font configuration
  fonts.fontconfig.enable = true;

  environment.systemPackages = with pkgs; [
  # SILLLYYYY
  btop
  ani-cli
  fastfetch
  sl
  cava
  # Toools
  vim
  git
  steam-run
  appimage-run
  ntfs3g
  wget
  google-chrome
  brave
  cloudflare-warp
  
  python3
  meson
  ninja
  unzip
  lzip
  curl
  wlroots
  udev
  libinput
  gcc
  #  hyprland
  hyprlock
  hypridle
  hyprshot

  wlogout
  swaynotificationcenter

  waybar
  rofi-wayland

  kitty
  foot

  pavucontrol
  blueman
  brightnessctl
  pamixer
  nwg-look
  networkmanagerapplet

  swww
  pywal
  ranger
  vscodium

  #Themes
  bibata-cursors
  
  #Games
  lutris
  wineWowPackages.stable
  winetricks
  mangohud
  ];

  system.stateVersion = "25.05";

}
