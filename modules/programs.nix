{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btrfs-tools
    htop
  ];

  programs.git.enable = true;

  programs.neovim = {
    defaultEditor = true;
    enable        = true;
    viAlias       = true;
    vimAlias      = true;
  };
}
