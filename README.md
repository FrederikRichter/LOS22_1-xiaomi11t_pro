WIP!

Nix Shell to build lineage os 22.1 and more for Xiaomi 11t Pro

# About

This is a nix flake that aims to provide an easy to use and reproducible environment that sets up all sources that are needed to build lineageos 22.1 for the Xiaomi 11t pro (vili). All build dependencies should be included.

### Working
Everything tested and confirmed by now
this includes:
- NFC
- BT/WIFI
- LTE/4G
- 120Hz
- 120W hypercharge
- high polling rate
- dolby atmos
- miui camera
- Fingerprint reader

### Quirks
None at this time

When setting up the sources some clones fail because google rate limits. If that happens just enter Source after the script finished and run
```bash
repo sync
```
### Usage
```bash
nix develop github:FrederikRichter/LOS22_1-xiaomi11t_pro
setup_source
start_build
```
everything one could need (recovery, boot.img etc) should be in the out directory located in Source/.

Keep in mind to have at least 32gb of ram and 16gb of swap plus >300gb of disk space.

Tested in WSL 2 with 32gb of ram and 24gb of swap, build plus source setup took about 3h.
