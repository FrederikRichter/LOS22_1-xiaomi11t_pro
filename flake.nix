{
  description = "Development environment for Android-like build system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            bc
            bison
            git-repo
            ccache
            curl
            flex
            gcc
            git
            git-lfs
            gnupg
            gperf
            imagemagick
            readline
            libz
            libelf
            lz4
            #libsdl2
            openssl
            libxml2
            lzop
            pngcrush
            rsync
            schedtool
            squashfsTools
            libxslt
            zip
            zlib
            ncurses
            python3
            gnumake
            pkg-config
          ];

          shellHook = ''
            echo "Welcome to the Android-like build environment!"
          '';
        };
      }
    );
}

