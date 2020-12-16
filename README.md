# Pineapple-Linux
A yuzu compiler and updater for Linux

## What does it do
This script downloads the latest yuzu Early Access (or an older version if you wish) from [PinEApple](https://pineappleea.github.io/), extracts it, compiles it and optionally installs it creating a launcher entry and a terminal command. The script also provides an uninstall option in case something goes wrong

## Dependencies
The installer requires the same dependencies as yuzu for building plus 7zip for extraction.

### Arch
```sudo pacman -S --needed p7zip git base-devel ninja cmake sdl2 qt5-base python2 python-pip boost catch2 fmt libzip lz4 mbedtls nlohmann-json openssl opus zlib zstd glslang && yay -S conan```
or get conan from aur manually. Installing it via pip is not recommended on Arch.
### Debian (incl. Ubuntu,Mint,pop os etc.)
```sudo apt-get install gcc-10 g++-10 glslang-tools p7zip-full git build-essential ninja-build cmake libsdl2-dev qtbase5-dev libqt5opengl5-dev qtbase5-private-dev python python3-pip libboost-dev libboost-context-dev libzip-dev liblz4-dev libmbedtls-dev libssl-dev libopus-dev zlib1g-dev libzstd-dev libavcodec-dev libavutil-dev libswscale-dev xorg-dev libx11-xcb-dev```
Either get conan manually from [here](https://conan.io/downloads.html) or use ```sudo pip3 install conan```
Make sure GCC and G++ 10 is used, one way is to add on your .bashrc/.zshrc ```export CC=/usr/bin/gcc-10``` and ```export CXX=/usr/bin/g++-10```
### Fedora
```sudo dnf install boost-devel cmake fmt-devel gcc git libdmx-devel libfontenc-devel libfontenc-devel libFS-devel libICE-devel libSM-devel libXau-devel libXaw-devel libXaw-devel libxcb-devel libXcomposite-devel libXcursor-devel libXdamage-devel libXdmcp-devel libXdmcp-devel libXext-devel libXfixes-devel libXft-devel libXi-devel libXinerama-devel libxkbfile-devel libXmu-devel libXpm-devel libXrandr-devel libXrender-devel libXres-devel libXres-devel libXScrnSaver-devel libXScrnSaver-devel libXt-devel libXtst-devel libXtst-devel libXv-devel libXvMC-devel libXxf86dga-devel libXxf86vm-devel libzip-devel libzstd-devel lz4-devel mbedtls-devel ninja-build openssl-devel opus-devel p7zip p7zip-plugins python2 python-pip qt5-qtbase-devel SDL2-devel xcb-util-image-devel xcb-util-keysyms-devel xcb-util-renderutil-devel xcb-util-wm-devel xkeyboard-config-devel xorg-x11-server-devel xorg-x11-xkb-utils-devel xorg-x11-xtrans-devel zlib-devel && sudo pip install conan```
### Gentoo
```emerge dev-vcs/git app-arch/p7zip =sys-devel/gcc-7.1.0 dev-util/ninja dev-util/cmake media-libs/libsdl2 dev-qt/qtcore dev-qt/qtopengl && sudo pip install conan``` 
      
## Usage
Run the script using 

``curl -s https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/pineapple.sh | sh  -s --``
You can append any arguments after --.
If you wanna call the updater using a command, you can append an alias to your .bash_rc/.zshrc. For example, adding

```alias pineapple="curl -s https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/pineapple.sh | sh -s --"``` 
will run the script when you type in the command ```pineapple```.

Alternatively, download the script using ```wget https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/pineapple.sh``` and run it using ```sh pineapple.sh```.

This is not recommended, since we need to update the script from time to time to fix yuzu's compilation process, but can be useful to install older versions.

## Magic Number
**NVIDIA users only!**
This fixes the issue where vulkan outright crashes when starting a game which is cause by a bug on the nvidia drivers that require allocable_size to be more than 4 MiB.
This has been fixed in EA 995. If you want to test vulkan on an earlier build, you can manually invoke it with the ```-n``` option.

## Tips
- If you have aria2 installed, the script will automatically use it to download yuzu with multiple connections, giving up to a 6x download speed improvement. 
If you do not have aria2 installed, the script will fall back to the slower wget

- Use ccache to make compilation way faster. Just install the ccache package and add append the path. For arch you can add ```export PATH="/usr/lib/ccache/bin/:$PATH"``` (for Fedora and SUSE this would be ```export PATH="/usr/lib64/ccache/:$PATH"```) at the bottom of the file .zshrc/.bash_rc found on your home folder (Use ctrl+H to view hidden files), for debian based distros like ubuntu and mint you can follow the first answer [here](https://askubuntu.com/questions/470545/how-do-i-set-up-ccache).

- If you have an Nvidia gpu you can boost performance by adding ```env LD_PRELOAD="libpthread.so.0 libGL.so.1" __GL_THREADED_OPTIMIZATIONS=1 ``` after ```Exec=``` on the yuzu.desktop file located in /usr/share/applications (you'll need sudo to edit it).

- For AMD/Intel GPUs that would be ```glsl_zero_init=true MESA_EXTENSION_OVERRIDE="-GL_KHR_texture_compression_astc_ldr -GL_KHR_texture_compression_astc_sliced_3d"```
