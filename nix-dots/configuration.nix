
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./vm.nix
    ];
  
  virtualisation.waydroid.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
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
  
  services.getty.autologinUser = "ryuuma";
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
  
  # --- Enable Hyprland ---
  programs.hyprland = {
  	enable = true;
  	xwayland.enable = true;
  	withUWSM = true;
  
  };
  # Install firefox
  programs.firefox.enable = true;
  #steam
  programs.steam.enable = true;
  #fish
  programs.fish.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #flatpak
  services.flatpak.enable = true;
  
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
  # UTIlities
  vim
  git
  steam-run
  ntfs3g
  wget
  google-chrome
  #dependencies
  meson
  ninja
  unzip
  wlroots
  udev
  libinput
  gcc
  #  hyprland
  hyprlock 
  hypridle
  hyprshot
  hyprpaper
  
  wlogout
  swaylock-effects
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
  
  #Themes
  bibata-cursors
  ];

  system.stateVersion = "25.05";

}
