# /etc/nixos/home.nix
{ config, pkgs, inputs, ... }:

{
  home.username = "ryuuma";
  home.homeDirectory = "/home/ryuuma";
  home.stateVersion = "25.05"; 
  programs.bash = {
  	enable = true;
  	shellAliases = {
  		tmc = "flatpak run fi.mooc.tmc.tmc-cli-rust";
  	};
  	profileExtra = ''
  		if [ -z "$WAYLAND-DISPLAY" ] && [ "$XDG-VTNR" = 1 ]; then
  		   exec uwsm start -S hyprland-uwsm.desktop
  		fi
  	'';
  };
 
  home.sessionVariables = {
    XCURSOR_THEME = "Capitaine";
    XCURSOR_SIZE  = "24";
  };
  
  home.packages = [
    pkgs.qbittorrent
    pkgs.gparted
    
  ];
  
  
}
