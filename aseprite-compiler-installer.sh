#!/bin/bash

# Info on how this all magically works
# https://github.com/aseprite/skia/releases
# https://github.com/aseprite/aseprite/blob/main/INSTALL.md


#----------- Some nice logging functions I stole from elsewhere ------------#
print_ansi_code() {
  printf '\033[%sm' "$1"
}

print_color() {
  print_ansi_code "0;$1"
  printf '%s' "$2"
  print_ansi_code '0'
}

stamp() {
	printf '[%s]' "$(date '+%F %r')"
}

log() {
	{ print_color '33' "$(stamp)"; echo " $1"; } >&2
}

#------------------------------Build Functions-------------------------------#

create_binary_launcher() {
	log 'Making binary launcher in $HOME/.local/bin/aseprite...'
	sleep 1
	echo -e '#!/bin/bash\n$HOME/.local/share/applications/Aseprite/aseprite' >> $HOME/.local/bin/aseprite
	chmod +x $HOME/.local/bin/aseprite
}

# Start build process

create_skia_dir() {
	log 'Creating skia dependency directory in $HOME/deps/skia'
	sleep 1
	mkdir -p $HOME/deps/skia
	cd $HOME/deps/skia
}

download_skia() {
	log 'Downloading Skia...'
	sleep 1
	wget -qO- https://api.github.com/repos/aseprite/skia/releases/latest \
	| grep "browser_download_url.*Skia-Linux-Release-x64-libc%2B%2B.zip" \
	| cut -d : -f 2,3 \
	| tr -d \" \
	| xargs wget
}

extract_skia() {
	log 'Extracting Skia...'
	sleep 1
	unzip *.zip -d ./
}

remove_temp_zip() {
	log 'Removing temporary skia zip'
	sleep 1
	rm *.zip
}

make_aseprite_dirs() {
	log 'Making Aseprite install dir in $HOME/.local/share/applications/Aseprite-x64'
	sleep 1
	mkdir -p $HOME/.local/share/applications/Aseprite-x64/
}

download_aseprite() {
	log 'Cloning Aseprite Repo'
	sleep 1
	cd $HOME/.local/share/applications/Aseprite-x64/
	git clone --recursive https://github.com/aseprite/aseprite.git . 
}

build_aseprite() {
	log 'Building Aseprite from Source'
	sleep 1
	mkdir build 
	cd build
	export CC=clang
	export CXX=clang++
	cmake \
	  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
	  -DCMAKE_CXX_FLAGS:STRING=-stdlib=libc++ \
	  -DCMAKE_EXE_LINKER_FLAGS:STRING=-stdlib=libc++ \
	  -DLAF_BACKEND=skia \
	  -DSKIA_DIR=$HOME/deps/skia \
	  -DSKIA_LIBRARY_DIR=$HOME/deps/skia/out/Release-x64 \
	  -DSKIA_LIBRARY=$HOME/deps/skia/out/Release-x64/libskia.a \
	  -G Ninja \
	  ..
	ninja aseprite
	log 'Moving binary and reqs to ~/.local/share/applications/Aseprite'
	sleep 1
	mkdir $HOME/.local/share/applications/Aseprite
	mv $HOME/.local/share/applications/Aseprite-x64/build/bin/* $HOME/.local/share/applications/Aseprite
	log 'Cleaning up compilation files...'
	sleep 1
	rm -rf $HOME/.local/share/applications/Aseprite-x64
}

#------------------------------------Main------------------------------------#

main() {
	create_binary_launcher &&
	create_skia_dir &&
	download_skia &&
	extract_skia &&
	remove_temp_zip &&
	make_aseprite_dirs &&
	download_aseprite &&
	build_aseprite
}

# Run it
main "$@"
