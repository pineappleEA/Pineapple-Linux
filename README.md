# Pineapple-Linux
A yuzu compiler and updater for Linux

## What does it do
This script downloads the latest yuzu Early Access (or an older version if you wish) from [PinEApple](https://pineappleea.github.io/), extracts it, compiles it and optionally installs it creating a launcher entry and a terminal command. The script also provides an uninstall option in case something goes wrong

## Dependencies
The installer requires the same dependencies as yuzu for building plus 7zip for extraction.

### Arch
```sudo pacman -S --needed base-devel cmake git glslang ninja p7zip python2 python-pip qt5-base qt5-tools && yay -S conan```
or get conan from aur manually. Installing it via pip is not recommended on Arch.
### Debian (incl. Ubuntu,Mint,pop os etc.)
```sudo apt install build-essential cmake g++-10 gcc-10 git glslang-tools libavcodec-dev libavutil-dev libboost-context-dev libboost-dev liblz4-dev libmbedtls-dev libopus-dev libqt5opengl5-dev libsdl2-dev libssl-dev libswscale-dev libx11-xcb-dev libxcb-dri3-dev libzip-dev libzstd-dev make ninja-build p7zip-full python python3-pip qtbase5-dev qtbase5-private-dev qttools5-dev xorg-dev zlib1g-dev```
Either get conan manually from [here](https://conan.io/downloads.html) or use ```sudo pip3 install conan```
Make sure GCC and G++ 10 is used, look at the Notes section bellow for more info.
### Fedora
```sudo dnf install alsa-lib-devel boost-devel cmake ffmpeg-devel fmt-devel gcc jack-audio-connection-kit-devel libzip-devel libzip-tools libzstd-devel lz4-devel make mbedtls-devel ninja-build openssl-devel opus-devel pulseaudio-libs-devel python2 python-pip qt5-linguist qt5-qtbase-devel qt5-qtbase-private-devel SDL2-devel zlib-devel```
### Gentoo
```emerge dev-vcs/git app-arch/p7zip =sys-devel/gcc-7.1.0 dev-util/ninja dev-util/cmake media-libs/libsdl2 dev-qt/linguist-tools dev-qt/qtcore dev-qt/qtopengl && sudo pip install conan``` 
      
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

## Notes
- Debuntu and based distro (Mint, PopOs, etc.) users need to make sure they have g++ ≥ 10 using ```g++ -v``` (the version is at the bottom). If you have 9 or less, switch to 10 using
```sudo apt install gcc-10 g++-10```
```sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10```
```sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10```

## Tips
- Use ccache to make compilation way faster. Just install the ccache package and add append the path. For arch you can add ```export PATH="/usr/lib/ccache/bin/:$PATH"``` (for Fedora and SUSE this would be ```export PATH="/usr/lib64/ccache/:$PATH"```) at the bottom of the file .zshrc/.bash_rc found on your home folder (Use ctrl+H to view hidden files), for debian based distros like ubuntu and mint you can follow the first answer [here](https://askubuntu.com/questions/470545/how-do-i-set-up-ccache).

- If you have an Nvidia gpu you can boost performance by adding ```env LD_PRELOAD="libpthread.so.0 libGL.so.1" __GL_THREADED_OPTIMIZATIONS=1 ``` after ```Exec=``` on the yuzu.desktop file located in /usr/share/applications (you'll need sudo to edit it) or copy it to ~/.local/share/applications.

- For AMD/Intel GPUs that would be ```glsl_zero_init=true MESA_EXTENSION_OVERRIDE="-GL_KHR_texture_compression_astc_ldr -GL_KHR_texture_compression_astc_sliced_3d"```
