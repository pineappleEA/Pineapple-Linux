#!/usr/bin/env sh
#Print pretty pineapple text and prepare environment
initial_wd=`pwd`
find /tmp/pineapple/* ! -name '*.7z' ! -name '*.aria2' 2>/dev/null | sort -n -r | xargs rm -rf --
mkdir -p /tmp/pineapple && cd /tmp/pineapple
while getopts ":n" options; do
    case "${options}" in
    	n) magicnumber=1;;
    	:)
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
printf "REMINDER:In case the build fails, grab the latest AppImage from https://edisionnano.github.io\n"
#Download and save links currently listed on PinEApple site
curl -s https://raw.githubusercontent.com/pineappleEA/pineappleEA.github.io/master/index.html | sed -e '0,/^			<!--link-goes-here-->$/d' -e '/div/q;p'| head -n -2 > version.txt
#Print current version and take user input
prompt()
{
printf "Latest version is "
latest=$(head -n 1 version.txt | grep -o 'EA [0-9]*' | sed 's/[^0-9]*//g')
printf $latest
printf "\n"
printf " [1] Download it \n [2] Download an older version \n [3] Uninstall \n [4] To display Discord Invite\n or anything else to exit.\nOption:"
read option <&1
#execute the given command
if [ "$option" = "1" ]; then
    	title=$latest
	curl -s $(head -n 1 version.txt | grep -o 'https.*7z') > version.txt
elif [ "$option" = "2" ]; then
	printf "Available versions:\n"
	uniq version.txt | grep -o 'EA [0-9]*' | sed -e ':a;N;$!ba;s/\n/,/g' -e 's/\EA //g'
	printf "Choose version number:"
	read version <&1
	title=$version
	old_ver="\s${version}</a><br>"
	exists=$(grep "$old_ver" version.txt)
	if [ "$exists" ]; then
        curl -s $(grep "YuzuEA-$version" version.txt | grep -o 'https.*7z') > version.txt
    else
        echo "Wrong version number, exiting..."
        exit
	fi
elif [ "$option" = "3" ]; then
	sudo rm /usr/local/bin/yuzu
	printf "\nUninstalling...\n"
	sudo rm /usr/share/icons/hicolor/scalable/apps/yuzu.svg
	sudo rm -f /usr/share/pixmaps/yuzu.svg
	sudo rm -f /usr/share/pixmaps/yuzu.png
	sudo rm /usr/share/applications/yuzu.desktop
	sudo rm /usr/share/mime/packages/yuzu.xml
	sudo rm -f /usr/local/share/applications/yuzu.desktop
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
else
	printf "Exiting...\n"
	exit
fi
}
prompt
#Download and unzip given version
available=$(curl -I -s https://codeload.github.com/pineappleEA/pineapple-src/zip/EA-$title | head -n 1 | grep -o "404")
if ! [ -z $available ]; then
	if ! [ -x "$(command -v aria2c)" ]; then
	    printf "You are missing aria2, downloading using the slower fallback wget method."
	    wget -N -c $(cat version.txt | grep -o 'https://cdn-.*.7z' | head -n 1)
	else
	    aria2c -c -x 6 -s 12 $(cat version.txt | grep -o 'https://cdn-.*.7z' | head -n 1)
	fi
	if [ $? -ne 0 ]; then
	    printf "Download failed!\n"
	    printf "If you are in Italy or Iran, please use a VPN in another country,\n"
	    printf "otherwise, please try again in a few minutes.\n"
	    exit
	fi
	ZIPNAME=YuzuEA-$title.7z
	7z x $ZIPNAME yuzu-windows-msvc-early-access/yuzu-windows-msvc-source-*
	if [ -d "yuzu-windows-msvc-early-access" ]; then
		cd yuzu-windows-msvc-early-access
	else
		printf "Extraction failed!\nMake sure you install all the necessary dependencies.\n"
		exit
	fi
	tar -xf yuzu-windows-msvc-source-*
	rm yuzu-windows-msvc-source-*.tar.xz 
	cd $(ls -d yuzu-windows-msvc-source-*)
else
	wget -N -c https://codeload.github.com/pineappleEA/pineapple-src/zip/EA-${title} -O pineapple-src-EA-${title}.zip
	if [ $? -ne 0 ]; then
		    printf "Download failed!\n"
		    printf "Make sure you have wget installed, and maybe try another version,\n"
		    printf "otherwise, please try again in a few minutes.\n"
		    exit
		fi
	7z x pineapple-src-EA-${title}.zip
	cd pineapple-src-EA-${title}
fi

find -path ./dist -prune -o -type f -exec sed -i 's/\r$//' {} ';'
find . -exec touch {} +
if [ "$magicnumber" ]; then
	printf "Magic Number\n"
	printf "\033[32;1mNVIDIA\033[0m"
	printf " only!\n"
	printf "This is a workaround to vulkan outright crashing, refer to the readme for more info.\n"
	printf "Choose:\n [1] for 12\n [2] for 14 (Turing/ 20 and 16 series cards)\n [3] for 16\n [4] for 20\n [5] for 24 (Pascal/ 10 series cards)\nOr anything else to skip this entirely\nOption: "
	read magicnumber <&1
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
curl https://raw.githubusercontent.com/PineappleEA/Pineapple-Linux/master/inject-git-info.patch > inject-git-info.patch
patch -p1 < inject-git-info.patch
find . -name "CMakeLists.txt" -exec sed -i 's/^.*-Werror$/-W/g' {} +
find . -name "CMakeLists.txt" -exec sed -i 's/^.*-Werror=.*)$/ )/g' {} +
find . -name "CMakeLists.txt" -exec sed -i 's/^.*-Werror=.*$/ /g' {} +
find . -name "CMakeLists.txt" -exec sed -i 's/-Werror/-W/g' {} +
find . -name "main.ui" -exec sed -i 's#../dist/yuzu.ico#/usr/share/pixmaps/yuzu.png#g' {} +

msvc=$(echo "${PWD##*/}"|sed 's/.*-//')
mkdir -p build && cd build
cmake .. -GNinja -DTITLE_BAR_FORMAT_IDLE="yuzu Early Access $title" -DTITLE_BAR_FORMAT_RUNNING="yuzu Early Access $title | {3}" -DENABLE_COMPATIBILITY_LIST_DOWNLOAD=ON -DENABLE_QT_TRANSLATION=ON -DGIT_BRANCH="HEAD" -DGIT_DESC="$msvc" -DUSE_DISCORD_PRESENCE=ON -DYUZU_USE_QT_WEB_ENGINE=OFF && ninja -j $(nproc)
if [ $? -ne 0 ]; then
	printf "\n------------------------------------------------------------------------------\n"
    printf "Compilation failed!\n"
    printf "You might want to try an older version of yuzu\n"
    printf "If that doesn't help, feel free to contact us on discord in the #linux channel\n"
    exit
fi
printf '\e[1;32m%-6s\e[m' "Compilation completed, do you wish to install it systemwide [y/n]?:"
read install <&1
#Save compiler output to ~/earlyaccess/yuzu and cleanup /tmp if user doesn't want to install
if [ "$install" = "n" ]; then
	mkdir -p ~/earlyaccess
	mv bin/yuzu ~/earlyaccess/yuzu
	cd ~/earlyaccess/
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
	curl https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/yuzu.xml > yuzu.xml
	sudo mv yuzu.xml /usr/share/mime/packages/yuzu.xml
	sudo update-mime-database /usr/share/mime
fi
cd /usr/share/icons/hicolor/scalable/apps
#Launcher shortcut
FILE=/usr/share/applications/yuzu.desktop
if [ -f "$FILE" ]; then
    :
else
	sudo sh -c "curl -s https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/yuzu.svg > yuzu.svg"
	sudo sh -c "curl -s https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/yuzu.png > /usr/share/pixmaps/yuzu.png"
	sudo sh -c "curl -s https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/yuzu.desktop > /usr/share/applications/yuzu.desktop"
	sudo update-desktop-database
fi
find /tmp/pineapple/* ! -name '*.7z' ! -name '*.aria2' | sort -n -r | xargs rm -rf --
printf '\e[1;32m%-6s\e[m' "Installation completed. Use the command yuzu or run it from your launcher."
printf "\n"
