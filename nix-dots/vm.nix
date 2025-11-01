# vm.nix
{ config, pkgs, ... }:

{
  # 1. Enable dconf for configuration management
  programs.dconf.enable = true;
  
  # 2. Add your user to the necessary group (replace 'ryuuma' if needed)
  users.users.ryuuma.extraGroups = [ "libvirtd" ];

  # 3. Install necessary packages for management and high-performance display (SPICE)
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    dconf # Explicitly include dconf package
    pkgs.adwaita-icon-theme # For correct appearance of GTK apps like virt-manager
  ];
  
  # 4. Virtualization services and configuration
  virtualisation = {
    libvirtd = {
      enable = true;
      
      qemu = {
        # Standard modern VM features
        ovmf.enable = true;
        swtpm.enable = true;
      };
    };
    
    # Enables USB passthrough via SPICE
    spiceUSBRedirection.enable = true;
  };
  
}
