{
  description = "instatypst — Sistema de diseño en Typst: temas de color y tipografía, plantillas para redes sociales";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        nerdFontsExtra = [
          pkgs.nerd-fonts.iosevka
          pkgs.nerd-fonts.zed-mono
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.typst
            pkgs.poppler_utils
            pkgs.python3 # scripts/nueva-plantilla.py
          ] ++ nerdFontsExtra;
          shellHook = ''
            export TYPST_ROOT="$PWD"
            export TYPST_FONT_PATHS="$PWD/Fonts"
            echo "instatypst: $(typst --version) · fuentes: ./Fonts + nerd-fonts (iosevka, zed-mono) de nixpkgs"
          '';
        };
      });
}
