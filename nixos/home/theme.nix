{config, pkgs, ...}:
{

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

  # dconf = {
  #   enable = true;
  #   settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  # };
}
