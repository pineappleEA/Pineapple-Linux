# Pineapple-Linux
A Yuzu compiler and updater for Linux

## What does it do
This script downloads the latest Yuzu Early Access (or an older version if you wish) from PinEApple, extracts it, compiles it and optionally installs it creating a launcher entry and a terminal command. The script also provides an unistall option in case something goes wrong

## Dependencies
The installer requires the same dependencies as yuzu for building plus 7zip for extraction. The way yuzu prompts users to install conan is not recommended.

      | Distro          | Commands
      | --------------- | ----------------
      | Arch            | sudo pacman -S --needed p7zip git base-devel ninja cmake sdl2 qt5 python2 python-pip boost catch2 fmt libzip lz4 mbedtls nlohmann-json openssl opus zlib zstd && yay -S conan or get conan from aur manually.
      | Ubuntu / Mint   | sudo apt-get install p7zip-full git build-essential ninja-build cmake libsdl2-dev qtbase5-dev libqt5opengl5-dev qtwebengine5-dev qtbase5-private-dev python python3-pip libboost-dev libboost-context-dev libzip-dev liblz4-dev libmbedtls-dev libssl-dev libopus-dev zlib1g-dev libzstd-dev Either get conan manually from https://conan.io/downloads.html or use sudo pip3 install conan
      | Fedora          | sudo dnf install p7zip git gcc ninja-build cmake SDL2-devel qt5-qtbase-devel python2 python-pip boost-devel fmt-devel libzip-devel libzstd-devel lz4-devel mbedtls-devel openssl-devel opus-devel zlib-devel && sudo pip install conan
      | Gentoo          | emerge dev-vcs/git app-arch/p7zip =sys-devel/gcc-7.1.0 dev-util/ninja dev-util/cmake media-libs/libsdl2 dev-qt/qtcore dev-qt/qtopengl && sudo pip install conan
      
## Usage
Download the script using ``` wget https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/pineapple.sh ``` and run it using ```sh pineapple.sh ```

## Tips
Use ccache to make compilation way faster. Just install the ccache package and add ```  export PATH="/usr/lib/ccache/bin/:$PATH" ``` at the bottom of the file .zshrc/.bash_rc found on your home folder (Use ctrl+H to view hidden files).
