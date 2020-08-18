#!/usr/bin/env sh
#Print pretty pineapple text and prepare environment
filename=""
initial_wd="$(pwd)"
[ -x "$(command -v aria2c)" ] && downloader="aria2c -c -x 6 -s 6" || downloader="wget -N -c"
_error() { echo "$1" ; exit 1 ; }
find /tmp/pineapple/* ! -name '*.7z' ! -name '*.aria2' | sort -n -r | xargs rm -rf --
mkdir -p /tmp/pineapple 
cd /tmp/pineapple || _error "dir /tmp/pineapple not found"
while getopts ":n:f:" options; do
    case "${options}" in
    	n) magicnumber=1;;
        f) filename=${OPTARG};;
    	:) ;;
	*) echo "invalid flag, see readme";;
    esac
done
echo "ICAgICAgICAgICAvJCQgICAgICAgICAgIC8kJCQkJCQkJCAgLyQkJCQkJCAgICAgICAgICAgICAg
ICAgICAgICAvJCQgICAgICAgICAgCiAgICAgICAgICB8X18vICAgICAgICAgIHwgJCRfX19fXy8g
LyQkX18gICQkICAgICAgICAgICAgICAgICAgICB8ICQkICAgICAgICAgIAogIC8kJCQkJCQgIC8k
JCAvJCQkJCQkJCB8ICQkICAgICAgfCAkJCAgXCAkJCAgLyQkJCQkJCAgIC8kJCQkJCQgfCAkJCAg
LyQkJCQkJCAKIC8kJF9fICAkJHwgJCR8ICQkX18gICQkfCAkJCQkJCAgIHwgJCQkJCQkJCQgLyQk
X18gICQkIC8kJF9fICAkJHwgJCQgLyQkX18gICQkCnwgJCQgIFwgJCR8ICQkfCAkJCAgXCAkJHwg
JCRfXy8gICB8ICQkX18gICQkfCAkJCAgXCAkJHwgJCQgIFwgJCR8ICQkfCAkJCQkJCQkJAp8ICQk
ICB8ICQkfCAkJHwgJCQgIHwgJCR8ICQkICAgICAgfCAkJCAgfCAkJHwgJCQgIHwgJCR8ICQkICB8
ICQkfCAkJHwgJCRfX19fXy8KfCAkJCQkJCQkL3wgJCR8ICQkICB8ICQkfCAkJCQkJCQkJHwgJCQg
IHwgJCR8ICQkJCQkJCQvfCAkJCQkJCQkL3wgJCR8ICAkJCQkJCQkCnwgJCRfX19fLyB8X18vfF9f
LyAgfF9fL3xfX19fX19fXy98X18vICB8X18vfCAkJF9fX18vIHwgJCRfX19fLyB8X18vIFxfX19f
X19fLwp8ICQkICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgJCQgICAg
ICB8ICQkICAgICAgICAgICAgICAgICAgICAKfCAkJCAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICQkICAgICAgfCAkJCAgICAgICAgICAgICAgICAgICAgCnxfXy8gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfF9fLyAgICAgIHxfXy8gICAgICAg
ICAgICAgICAgIA==" | base64 -d -
printf "\n"
printf "on pizza\n"
printf "Brought to you by EmuWorld!\n"
printf "\e[91m$(tput bold)NOW BACK FROM THE DEAD!\e[0m "
printf "Check option 4 to get a new invite.\n"
#Download and save links currently listed on PinEApple site
curl -s https://raw.githubusercontent.com/pineappleEA/pineappleEA.github.io/master/index.html | sed -e '0,/^			<!--link-goes-here-->$/d' -e '/div/q;p'| head -n -2 > version.txt
#Print current version and take user input
prompt()
{
printf "Latest version is "
latest=$(head -n 1 version.txt | grep -o 'EA .*' | tr -d '</a><br>' | sed 's/[^0-9]*//g')
printf '%s' "$latest"
printf "\n"
printf " [1] Download it \n [2] Download an older version \n [3] Uninstall \n [4] To display Discord Invite\n or anything else to exit.\nOption:"
if [ -n "$filename" ]; then
    :
else
    read -r option <&1
fi
#execute the given command
if [ "$option" = "1" ]; then
	title="$latest"
	curl -s "$(grep -m1 -o 'https.*7z' version.txt )" > version.txt
elif [ "$option" = "2" ]; then
	printf "Available versions:\n"
	uniq version.txt | grep -o 'EA .*' | tr -d '</a><br>' | sed -e ':a;N;$!ba;s/\n/,/g' -e 's/\EA //g'
	printf "Choose version number:"
	read -r version <&1
	title="$version"
	curl -s "$(grep "YuzuEA-$version" version.txt | grep -o 'https.*7z')" > version.txt
elif [ "$option" = "3" ]; then
	printf "\nUninstalling...\n"
	sudo rm /usr/local/bin/yuzu
	sudo rm /usr/share/icons/hicolor/scalable/apps/yuzu.svg
	sudo rm /usr/share/pixmaps/yuzu.svg
	sudo rm /usr/share/applications/yuzu.desktop
	sudo rm /usr/share/mime/packages/yuzu.xml
	sudo update-desktop-database
	sudo update-mime-database /usr/share/mime
	printf "Uninstalled successfully\n"
	exit
elif [ "$option" = "4" ]; then
	printf "Discord Invite:\n"
	echo "aHR0cHM6Ly9kaXNjb3JkLmdnL2NVNjRGR1o=" | base64 -d -
	printf "\n"
	sleep 2s
	prompt
elif [ -n "$filename" ]; then
    printf "\n\e[1;31mUsing local archive!!!\e[0m"
    cp "$initial_wd/$filename" "/tmp/pineapple/$filename"
else
	printf "Exiting...\n"
	exit
fi
}
prompt
#Download and unzip given version
if [ -n "$filename" ]; then
    :
else
    eval "$downloader" "$(grep -o 'https://cdn-.*.7z' version.txt | head -n 1)" || printf '%s\n' \
"Download failed!
If you are in Italy or Iran, please use a VPN in another country
otherwise, please try again in a few minutes"

fi
7z x Yuzu* yuzu-windows-msvc-early-access/yuzu-windows-msvc-source-*
cd yuzu-windows-msvc-early-access || _error "dir yuzu-windows-msvc-early-access not found"
tar -xf yuzu-windows-msvc-source-*
rm yuzu-windows-msvc-source-*.tar.xz 
#Compilation
cd "$(ls -d yuzu-windows-msvc-source-*)" || _error "dir yuzu-windows-msvc-source-* not found"
find . -path dist -prune -o -type f -exec sed -i 's/\r$//' {} ';'
if lspci | grep -q "NVIDIA" || [ "$magicnumber" ]; then
	printf "Magic Number\n"
	printf "\033[32;1mNVIDIA\033[0m"
	printf " only!\n"
	printf "This is a workaround to vulkan outright crashing, refer to the readme for more info.\n"
	printf "Choose:\n [1] for 12\n [2] for 14 (Turing/ 20 and 16 series cards)\n [3] for 16\n [4] for 20\n [5] for 24 (Pascal/ 10 series cards)\nOr anything else to skip this entirely\nOption: "
	read -r magicnumber <&1
	if [ "$magicnumber" = "1" ]; then
	    sed -i 's/- 9/- 12/g' src/video_core/renderer_vulkan/vk_stream_buffer.cpp
	elif [ "$magicnumber" = "2" ]; then
	    sed -i 's/- 9/- 14/g' src/video_core/renderer_vulkan/vk_stream_buffer.cpp
	elif [ "$magicnumber" = "3" ]; then
	    sed -i 's/- 9/- 16/g' src/video_core/renderer_vulkan/vk_stream_buffer.cpp
	elif [ "$magicnumber" = "4" ]; then
	    sed -i 's/- 9/- 20/g' src/video_core/renderer_vulkan/vk_stream_buffer.cpp
	elif [ "$magicnumber" = "5" ]; then
	    sed -i 's/- 9/- 24/g' src/video_core/renderer_vulkan/vk_stream_buffer.cpp
	else
	    :
	fi
fi
wget -q https://raw.githubusercontent.com/PineappleEA/Pineapple-Linux/master/inject-git-info.patch
patch -p1 < inject-git-info.patch
msvc=$(echo "${PWD##*/}"|sed 's/.*-//')
mkdir -p build && cd build || _error "dir build not found"
cmake .. -GNinja -DTITLE_BAR_FORMAT_IDLE="yuzu Early Access $title" -DTITLE_BAR_FORMAT_RUNNING="yuzu Early Access $title | {3}" -DENABLE_COMPATIBILITY_LIST_DOWNLOAD=ON -DGIT_BRANCH="HEAD" -DGIT_DESC="$msvc" -DUSE_DISCORD_PRESENCE=ON -DYUZU_USE_QT_WEB_ENGINE=ON
ninja -j "$(nproc)"
printf '\e[1;32m%-6s\e[m' "Compilation completed, do you wish to install it[y/n]?:"
read -r install <&1
#Save compiler output to ~/earlyaccess/yuzu and cleanup /tmp if user doesn't want to install
if [ "$install" = "n" ]; then
	mkdir -p ~/earlyaccess
	mv bin/yuzu ~/earlyaccess/yuzu
	cd ~/earlyaccess/ || _error "dir earlyaccess not found"
	find /tmp/pineapple/* ! -name '*.7z' ! -name '*.aria2' | sort -n -r | xargs rm -rf --
	printf '\e[1;32m%-6s\e[m' "The binary sits at ~/earlyaccess/yuzu."
	printf "\n"
	exit
else
    :
fi
#Install yuzu and cleanup /tmp
sudo mv bin/yuzu /usr/local/bin/yuzu
#Mimetype fix
XML=/usr/share/mime/packages/yuzu.xml
if [ -f "$XML" ]; then
    :
else
	wget -q https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/yuzu.xml
	sudo mv yuzu.xml /usr/share/mime/packages/yuzu.xml
	sudo update-mime-database /usr/share/mime
fi
cd /usr/share/pixmaps || _error "dir /usr/share/pixmaps not found"
#Launcher shortcut
FILE=/usr/share/applications/yuzu.desktop
if [ -f "$FILE" ]; then
    :
else
	sudo sh -c "curl -s https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/yuzu.svg > yuzu.svg"
	sudo cp /usr/share/pixmaps/yuzu.svg /usr/share/icons/hicolor/scalable/apps/yuzu.svg
	sudo sh -c "curl -s https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/yuzu.desktop > /usr/share/applications/yuzu.desktop"
	sudo update-desktop-database
fi
find /tmp/pineapple/* ! -name '*.7z' ! -name '*.aria2' | sort -n -r | xargs rm -rf --
printf '\e[1;32m%-6s\e[m' "Installation completed. Use the command yuzu or run it from your launcher."
printf "\n"
