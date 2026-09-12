{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "rtfr";
  home.homeDirectory = "/home/rtfr";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    size = 16;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

}
