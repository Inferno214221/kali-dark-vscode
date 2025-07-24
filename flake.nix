{
  description = "Kali-Dark VSCode Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        buildInputs = with pkgs; [ ];
        nativeBuildInputs = with pkgs; [ ] ++ buildInputs;
      in with pkgs; rec
      {
        devShells.default = mkShell {
          inherit nativeBuildInputs;
        };

        packages.default = stdenv.mkDerivation rec {
          name = vscodeExtUniqueId;
          vscodeExtUniqueId = "${vscodeExtPublisher}.${vscodeExtName}";
          vscodeExtPublisher = "inferno214221";
          vscodeExtName = "kali-dark-vscode";
          version = "1.0.0";

          src = ./.;

          dontDisableStatic = true;

          installPrefix = "share/vscode/extensions/${vscodeExtUniqueId}";

          installPhase = ''
            mkdir -p $out/$installPrefix
            find . -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"
          '';
        };
      }
    );
}
