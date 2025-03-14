{
    description = "Development environment for Android-like build system";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, flake-utils }:
        flake-utils.lib.eachDefaultSystem (system:
                let
                system = "x86_64-linux";
                pkgs = nixpkgs.legacyPackages.${system};
                lib = nixpkgs.lib;

                systemInfo = lib.systems.elaborate { inherit system; };


# EDIT THIS TO ADJUST JOBS
                JOBS = "8";
                JOBS_NETWORK = JOBS;
                JOBS_CHECKOUT = JOBS;

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
                        echo "Enabling CCACHE with 50G Disk Space"
                        ccache -M 50G
                        echo "Setting up source"
                        mkdir -p Source/
                        cd Source && repo init --partial-clone --depth=1 -u https://github.com/LineageOS/android.git -b 538c2539f5863a792f5909a05bbfddb43419449c --git-lfs
                        repo sync --jobs-network=${JOBS_NETWORK} --jobs-checkout=${JOBS_CHECKOUT} --force-checkout
                        '';

                    env = {
                        USE_CCACHE=1;
                        CCACHE_EXEC="${pkgs.ccache}/bin/ccache";
                    };
                };
            }
    );
}

