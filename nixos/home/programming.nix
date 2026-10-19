{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  # Home profiles do not run the OCaml library setup hooks used by nix-shell.
  home.sessionVariables.OCAMLPATH = lib.makeSearchPath "lib/ocaml/${pkgs.ocaml.version}/site-lib" (
    lib.closePropagation [ pkgs.ocamlPackages.alcotest ]
  );

  home.packages = with pkgs; [
    # language support
    (lib.hiPrio clang)
    (lib.lowPrio gcc)
    python314
    nodejs
    rustup

    # OCaml
    ocaml
    dune_3
    ocamlPackages.findlib
    ocamlPackages.alcotest

    # Haskell
    (haskellPackages.ghcWithPackages (ps: [
      ps.parsec
    ]))
    haskellPackages.haskell-language-server
    fourmolu
    cabal-install

    (texliveBasic.withPackages (
      ps: with ps; [
        latexmk

        # languages
        fontspec
        babel-russian
        hyphen-russian

        # decorations
        titlesec
        tcolorbox
        pdfcol

        # TikZ
        tikzfill
      ]
    ))

    # build systems
    cmake

    # programming tools
    clang-tools # clangd, clang-tidy, other utilities
    lua-language-server
    nixfmt
    tex-fmt
    texlab # TeX LSP
    vscode-json-languageserver
  ];

  programs = {
    amp.enable = true;
    neovide = {
      enable = true;
      settings = {
        font = {
          normal = [ "Cascadia Code" ];
          size = 12.0;
        };
      };
    };

    gh.enable = true;
    git = {
      enable = true;
      settings = {
        user = {
          email = "rottenfront@atomicmail.io";
          name = "Andre Rottenfront";
        };
      };
    };
  };

}
