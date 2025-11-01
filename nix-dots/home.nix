# /etc/nixos/home.nix
{ config, pkgs, ... }:

{
  home.username = "ryuuma";
  home.homeDirectory = "/home/ryuuma";
  home.stateVersion = "25.05"; 
  programs.bash = {
  	enable = true;
  	shellAliases = {
  		btw = "echo what the hell am i doin";
  	};
  	profileExtra = ''
  		if [ -z "$WAYLAND-DISPLAY" ] && [ "$XDG-VTNR" = 1 ]; then
  		   exec uwsm start -S hyprland-uwsm.desktop
  		fi
  	'';
  };
  #home.file.".config/hypr".source= ./config/hypr;
  #home.file.".config/foot".source= ./config/foot;
  #home.file.".config/waybar".source= ./config/waybar;
  
  home.sessionVariables = {
    XCURSOR_THEME = "Capitaine";
    XCURSOR_SIZE  = "24";
  };


  # Optional: Add a simple package to confirm it works
  home.packages = [
    pkgs.qbittorrent
    pkgs.gparted
    
  ];
  
  
}
