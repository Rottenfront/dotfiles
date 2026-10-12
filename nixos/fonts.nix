
{ config, pkgs, ... }:

{
  # fontconfig
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      paratype-pt-sans
      paratype-pt-serif
      paratype-pt-mono

      liberation_ttf
      cascadia-code

      texliveConTeXt.fonts
      corefonts
      stix-two

      (pkgs.runCommand "sofia-sans" { } ''
        mkdir -p $out/share/fonts/truetype
        cp ${./sofia-sans/SofiaSans-VariableFont_wght.ttf} $out/share/fonts/truetype/
        cp ${./sofia-sans/SofiaSans-Italic-VariableFont_wght.ttf} $out/share/fonts/truetype/
      '')
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        sansSerif = [ "Sofia Sans" ];
        serif = [ "PT Serif" ];
        monospace = [ "Cascadia Code" ];
        emoji = [ "Noto Color Emogi" ];
      };

      hinting = {
        enable = true;
        style = "slight";
      };

      # antialias = true;
      subpixel = {
        rgba = "rgb";
      };
    };
  };
}
