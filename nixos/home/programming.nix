{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  home.sessionVariables = {
    # Home profiles do not run the OCaml library setup hooks used by nix-shell.
    OCAMLPATH = lib.makeSearchPath "lib/ocaml/${pkgs.ocaml.version}/site-lib" (
      lib.closePropagation [ pkgs.ocamlPackages.alcotest ]
    );
    PYTHONSTARTUP = "${config.home.homeDirectory}/.pythonrc.py";
  };

  home.file.".pythonrc.py".text = ''
    from math import *
  '';

  home.packages =
    let
      haskellDevShell =
        let
          haskell = pkgs.haskell.packages.ghc9103;
        in
        [
          # the compiler
          (haskell.ghcWithPackages (ps: [
            ps.parsec
            ps.pretty-simple
          ]))
          # toolchain
          pkgs.cabal-install
          # language server
          haskell.haskell-language-server
          # metadata generator for hls
          haskell.implicit-hie
          # formatter
          pkgs.fourmolu
          # parser utilities
          haskell.BNFC
          haskell.alex
          haskell.happy
        ];

      ccStack = with pkgs; [
        (lib.hiPrio clang)
        (lib.lowPrio gcc)

        clang-tools # clangd, clang-tidy, other utilities

        # build systems
        cmake
      ];

      fpgaStack = with pkgs; [
        # FPGA
        (quartus-prime-lite.override {
          supportedDevices = [
            "Cyclone IV"
          ];

          # Includes the Questa FPGA simulator
          withQuesta = true;
        })
        verilator
        yosys
        iverilog # verilog HDL
        svls # systemverilog lsp
        gtkwave
      ];

      latexStack = with pkgs; [
        (texliveBasic.withPackages (
          ps: with ps; [
            latexmk

            # languages
            fontspec
            unicode-math
            lualatex-math
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
        texlab # TeX LSP
        tex-fmt
      ];
    in
    with pkgs;
    haskellDevShell
    ++ ccStack
    ++ fpgaStack
    ++ latexStack
    ++ [

      automake

      python314
      nodejs

      rustup

      ocaml
      dune_3
      ocamlPackages.findlib
      ocamlPackages.alcotest

      odin

      # programming tools
      lua-language-server
      nixfmt
      vscode-json-languageserver
    ];

  programs = {
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
