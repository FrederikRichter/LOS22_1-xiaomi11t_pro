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
            bison
            git-repo
            ccache
            gcc
            git
            git-lfs
            gnupg
            gperf
            readline
            libz
            libelf
            lz4
            openssl
            libxml2
            lzop
            schedtool
            squashfsTools
            libxslt
            zip
            zlib
            python3
            gnumake
            pkg-config
          ];

        # setting up source, fixed commit hash to 22.1 Branch
          shellHook = ''
            echo "Setting up source"
            mkdir Source/
            cd Source && repo init --partial-clone --depth=1 -u https://github.com/LineageOS/android.git -b 538c2539f5863a792f5909a05bbfddb43419449c --git-lfs
            repo sync -c -j8 --jobs-network=8 --jobs-checkout=12
          '';
        };
      }
    );
}

