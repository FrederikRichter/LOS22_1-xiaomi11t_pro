{
    description = "Dev env for building Lineage OS for vili (Xiaomi 11T Pro)";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, flake-utils }:
        flake-utils.lib.eachDefaultSystem (system:
            let
                pkgs = import nixpkgs { inherit system; };
                lib = nixpkgs.lib;

                JOBS_NETWORK = "4";
                JOBS_CHECKOUT = "4";

                # Define the Git Clone Script
                sourceScript = pkgs.writeTextFile {
                    name = "setup_source";
                    text = ''
                # !${pkgs.bashInteractive}/bin/bash
                    echo "Setting up source directory..."
                    mkdir -p Source
                    cd Source

                    if [ ! -d .repo ]; then
                        echo "Initializing repo..."
                        repo init --partial-clone --depth=1 -u https://github.com/LineageOS/android.git -b 538c2539f5863a792f5909a05bbfddb43419449c --git-lfs
                        else
                            echo "repo already initialized"
                        fi

                    echo "Syncing repo..."
                    repo sync --jobs-network=${JOBS_NETWORK} --jobs-checkout=${JOBS_CHECKOUT} --force-checkout

                    echo "Cloning necessary repositories for Xiaomi 11T Pro (vili)..."

                    clone_repo() {
                        if [ -d "$2" ]; then
                            echo "Removing existing $2..."
                            rm -rf "$2"
                        fi
                        echo "Cloning $1 into $2..."
                        git clone --depth=1 "$1" -b lineage-22.1 "$2"
                    }

                    clone_repo "https://github.com/FrederikRichter/device_xiaomi_sm8350-common.git" "device/xiaomi/sm8350-common"
                    clone_repo "https://github.com/AOSP-for-vili/android_kernel_xiaomi_sm8350.git" "kernel/xiaomi/sm8350"
                    clone_repo "https://github.com/AOSP-for-vili/android_hardware_xiaomi.git" "hardware/xiaomi"
                    clone_repo "https://github.com/AOSP-for-vili/vendor_xiaomi_vili.git" "vendor/xiaomi/vili"
                    clone_repo "https://github.com/AOSP-for-vili/vendor_xiaomi_sm8350-common.git" "vendor/xiaomi/sm8350-common"
                    clone_repo "https://github.com/AOSP-for-vili/vendor_xiaomi_camera.git" "vendor/xiaomi/camera"
                    clone_repo "https://gitlab.com/0mar99/vendor-xiaomi-vili-firmware.git" "vendor/xiaomi/vili-firmware"
                    clone_repo "https://github.com/FrederikRichter/device_tree_xiaomi_vili.git" "device/xiaomi/vili"

                    echo "Applying Leica camera patch..."
                    cd frameworks/base
                    PATCH_FILE="0001-Add-backwards-compatible-CaptureResultExtras-constructor.patch"
                    if [ ! -f "$PATCH_FILE" ]; then
                        wget https://raw.githubusercontent.com/xiaomi-haydn-devs/Patch-Haydn/14/Leicamera/$PATCH_FILE
                        patch -p1 < $PATCH_FILE --skip
                    else
                        echo "Patch already applied, skipping..."
                    fi
                    cd ../..
                '';
                  executable = true;
                destination = "/bin/setup_source";
                };

                # make build script
                buildScript = pkgs.writeTextFile{
                    name = "start_build";
                    text = ''
                        # !${pkgs.bashInteractive}/bin/bash
                        if [ -d "Source" ]; then
                            cd Source || exit
                            echo "Entered Source Directory"
                        else
                            echo "Source directory does not exist"
                            exit 1  # Stop the script if "Source" doesn't exist
                        fi
                        source ./build/envsetup.sh 
                        build_build_var_cache
                        brunch vili
                '';
                executable = true;
                destination = "/bin/start_build";
                };
                # Define FHS Environment
                fhsEnv = pkgs.buildFHSEnv {
                    name = "LOS22_1-env";
                    targetPkgs = pkgs: (with pkgs; [
                        bison git-repo ccache gcc git bashInteractive git-lfs gnupg gperf wget
                        readline libz libelf lz4 openssl m4 ncurses5 libxml2 lzop
                        schedtool squashfsTools libxslt zip unzip libxcrypt-legacy
                        zlib python3 gnumake pkg-config bc libgcc
                        bash-completion
                        psmisc flex fontconfig nettools imagemagick android-tools
                        libelf procps freetype pngcrush rsync ncurses
                    ]) ++ [ sourceScript buildScript ];

                    
                    profile = ''
                        # Setting Release Target
                        export TARGET_RELEASE=ap4a

                        # New Commands Message
                        echo "New Commands: start_build, setup_source (WARNING: REMOVES GIT REPOS IF ALREADY EXIST, KEEPS LARGE .repo)"
                        

                    '';
                };

            in
            {
                devShells.default = pkgs.mkShell {
                    buildInputs = [ fhsEnv ];
                    shellHook = ''
                        # ignore any ssh configs for git
                        export GIT_SSH_COMMAND="ssh -F /dev/null"


                        echo "Entering FHS environment..."
                        exec ${fhsEnv}/bin/LOS22_1-env  # Corrected entry point
                    '';
                };

                packages.fhsEnv = fhsEnv;
            }
        );
}
