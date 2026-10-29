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
    haskellPackages.implicit-hie
    fourmolu
    cabal-install

    odin

    (texliveBasic.withPackages (
      ps: with ps; [
        latexmk

        # languages
        fontspec
        unicode-math
        babel-russian
        hyphen-russian

        # decorations
        titlesec
        tcolorbox
        pdfcol

        # TikZ
        tikzfill

        mathtools
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

    # FPGA
    quartus-prime-lite
    iverilog # verilog HDL
    svls # systemverilog lsp
    gtkwave
    surfer # waveform viewer
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

  home.file.".latexmkrc".text = ''
    # Default to PDF generation (5 for xelatex / 4 for lualatex)
    $pdf_mode = 4;

    # Continuous preview mode settings (auto-recompile on save)
    $pvc_view_file_via_temporary = 0;

    # PDF previewer command (e.g., zathura, evince, okular)
    $pdf_previewer = "zathura %S";

    # Cleanup extensions when running `latexmk -c` or `latexmk -C`
    $clean_ext = "synctex.gz fls fdb_latexmk bbl nav snm vrb auxlock";
  '';

}
