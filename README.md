# Aseprite Linux Compiler/Installer

### A shell script that will go fetch the source for compiling aseprite and compile it locally.

- before running this make sure that you have the required [build dependencies](https://github.com/aseprite/aseprite/blob/main/INSTALL.md)

```sh
sudo apt install -y g++ clang libc++-dev libc++abi-dev cmake ninja-build libx11-dev libxcursor-dev libxi-dev libgl1-mesa-dev libfontconfig1-dev
```

- make sure the script is executable
```sh
chmod +X aseprite-compiler-installer.sh
```

- run the script
```sh
./aseprite-compiler-installer.sh
```

## Post-install usage and notes

- run aseprite by opening a terminal and typing `aseprite`

- files will be placed in the following directories
- `$HOME/.local/bin/` will contain a small launcher shell script `aseprite` so that this can just be run with one command
- `$HOME/.local/share/applications/Aseprite/` is where the compiled program will reside
- `$HOME/deps/skia` is where some build dependencies will be placed, remove them when this is finished running if you desire
