WIP!

Nix Shell to build vanilla lineage os 22.1 for Xiaomi 11t Pro

# About

This is a nix flake that aims to provide an easy to use and reproducible environment that sets up all sources that are needed to build lineageos 22.2 for the Xiaomi 11t pro (vili). All build dependencies should be included.

### Working
Everything tested and confirmed by now
this includes:
- NFC
- BT/WIFI
- LTE/4G
- 120Hz
- 120W hypercharge
- high polling rate
- Fingerprint reader
- Dolby (HDR/Equalizer)

### Quirks/Bugs
- Some LineageOS bugs
- Device Health Monitor Not Displaying Battery Status Correctly in Settings

When setting up the sources some clones fail because google rate limits. If that happens just enter Source Directory after the script finished and run
```bash
repo sync
```
### Usage
#### Building
```bash
nix develop github:FrederikRichter/LineageOS_22-Xiaomi11TPro_vili/22.2
setup_source
start_build
```
everything one could need (recovery, boot.img etc) should be in the out directory located in Source/.

Keep in mind to have at least 32gb of ram and 16gb of swap plus >300gb of disk space.

Tested in WSL 2 with 32gb of ram, 24gb of swap and Ryzen 5 7600x. build plus source setup took about 3h.

#### Updating Source git repos
```bash
nix flake update
```

#### Changing Build Inputs
Just edit the inputs in the flake.nix, you can pin repos to specific commit hashes, refer to nix doc



