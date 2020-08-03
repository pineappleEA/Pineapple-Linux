# Pineapple-Linux
A yuzu compiler and updater for Linux

## What does it do
This script downloads the latest yuzu Early Access (or an older version if you wish) from [PinEApple](https://pineappleea.github.io/), extracts it, compiles it and optionally installs it creating a launcher entry and a terminal command. The script also provides an unistall option in case something goes wrong

## Dependencies
The installer requires the same dependencies as yuzu for building plus 7zip for extraction. The way yuzu prompts users to install conan is not recommended.

### Arch
```sudo pacman -S --needed p7zip git base-devel ninja cmake sdl2 qt5 python2 python-pip boost catch2 fmt libzip lz4 mbedtls nlohmann-json openssl opus zlib zstd && yay -S conan```
or get conan from aur manually.
### Debian (incl. Ubuntu,Mint,pop os etc.)
```sudo apt-get install p7zip-full git build-essential ninja-build cmake libsdl2-dev qtbase5-dev libqt5opengl5-dev qtwebengine5-dev qtbase5-private-dev python python3-pip libboost-dev libboost-context-dev libzip-dev liblz4-dev libmbedtls-dev libssl-dev libopus-dev zlib1g-dev libzstd-dev```
Either get conan manually from [here](https://conan.io/downloads.html) or use ```sudo pip3 install conan```
### Fedora
```sudo dnf install p7zip git gcc ninja-build cmake SDL2-devel qt5-qtbase-devel python2 python-pip boost-devel fmt-devel libzip-devel libzstd-devel lz4-devel mbedtls-devel openssl-devel opus-devel zlib-devel && sudo pip install conan```
### Gentoo
```emerge dev-vcs/git app-arch/p7zip =sys-devel/gcc-7.1.0 dev-util/ninja dev-util/cmake media-libs/libsdl2 dev-qt/qtcore dev-qt/qtopengl && sudo pip install conan``` 
      
## Usage
Run the script using 

``curl https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/pineapple.sh | sh``

If you wanna call the updater using a command, you can append an alias to your .bash_rc/.zshrc. For example, adding

```alias pineapple="curl https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/pineapple.sh | sh"``` 
will run the script when you type in the command ```pineapple```.

Alternatively, download the script using ```wget https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/pineapple.sh``` and run it using ```sh pineapple.sh```.

But keep in mind that you may have to update the downloaded script from time to time.

## Tips
- If you have aria2 installed, the script will automatically use it to download yuzu with multiple connections, giving up to a 6x download speed improvement
If you do not have aria2 installed, the script will fall back to the slower wget

- Use ccache to make compilation way faster. Just install the ccache package and add append the path. For arch you can add ```export PATH="/usr/lib/ccache/bin/:$PATH"``` at the bottom of the file .zshrc/.bash_rc found on your home folder (Use ctrl+H to view hidden files), for debian based distros like ubuntu and mint you can follow the first answer [here](https://askubuntu.com/questions/470545/how-do-i-set-up-ccache).

