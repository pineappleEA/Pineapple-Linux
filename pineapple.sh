#!/usr/bin/env sh
#Print pretty pineapple text and prepare environment
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
#Set fallback links
pinesite () {
curl -s https://raw.githubusercontent.com/pineappleEA/pineappleEA.github.io/master/index.html || curl -s https://pineappleea.github.io
}

#Download and save links currently listed on PinEApple site
pinesite | sed -e '0,/^			<!--link-goes-here-->$/d' -e '/div/q;p'| head -n -2 > version.txt
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
	printf "Uninstalling..."
	sudo rm /usr/local/bin/yuzu
	sudo rm /usr/share/icons/hicolor/scalable/apps/yuzu.svg
	sudo rm -f /usr/share/pixmaps/yuzu.svg
	sudo rm -f /usr/share/pixmaps/yuzu.png
	sudo rm /usr/share/applications/yuzu.desktop
	sudo rm /usr/share/mime/packages/yuzu.xml
	sudo rm -f /usr/local/share/applications/yuzu.desktop
	sudo update-desktop-database
	sudo update-mime-database /usr/share/mime
	printf "\nUninstalled successfully\n"
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
	if [ -x "$(command -v aria2c)" ]; then
	    aria2c -c -x 6 -s 12 $(cat version.txt | grep -o 'https://cdn-.*.7z' | head -n 1)
	elif [ -x "$(command -v wget)" ]; then
	    printf "You are missing aria2, downloading using the slower fallback wget method."
	    wget -N -c $(cat version.txt | grep -o 'https://cdn-.*.7z' | head -n 1)
	else
		printf "You are missing both aria2 and wget, downloading using the even slower fallback curl method."
		curl -LOC - $(cat version.txt | grep -o 'https://cdn-.*.7z' | head -n 1)
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
	#Use cURL if wget isn't installed
	wget https://codeload.github.com/pineappleEA/pineapple-src/legacy.tar.gz/EA-${title} -O pineapple-src-EA-${title}.tar.gz || curl -o pineapple-src-EA-${title}.tar.gz https://codeload.github.com/pineappleEA/pineapple-src/legacy.tar.gz/EA-${title}
	if [ $? -ne 0 ]; then
		    printf "Download failed!\n"
		    printf "Make sure you have wget or curl installed, and maybe try another version,\n"
		    printf "otherwise, please try again in a few minutes.\n"
		    exit
		fi
	tar -xf pineapple-src-EA-${title}.tar.gz
	arch_dir=$(tar --exclude='*/*' -tf pineapple-src-EA-${title}.tar.gz)
	if [ -d "$arch_dir" ]; then
		cd $arch_dir
	else
		printf "Extraction failed!\nAborting...\n"
		exit
	fi
fi

#Get source modification date
build_date=$(date +%F -r .)
#Convert Dos line endings to UNIX ones
find -path ./dist -prune -o -type f -exec sed -i 's/\r$//' {} ';'
#Change all file modification dates to current, workaround for a Ninja bug
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
#Fix _NET_WM_ICON
curl -sO https://patch-diff.githubusercontent.com/raw/yuzu-emu/yuzu/pull/5274.diff || curl -sO https://gitlab.com/samantas5855/pineapple/-/raw/master/5274.diff
#Inject version info
curl -sO https://raw.githubusercontent.com/PineappleEA/Pineapple-Linux/master/inject-git-info.patch || curl -sO https://gitlab.com/samantas5855/pineapple/-/raw/master/inject-git-info.patch 
#Apply the patches
patch -p1 < inject-git-info.patch
patch -p1 < 5274.diff
#Replace warning to  errors with just warnings, needed when compiling with ninja
find . -name "CMakeLists.txt" -exec sed -i 's/^.*-Werror$/-W/g' {} +
find . -name "CMakeLists.txt" -exec sed -i 's/^.*-Werror=.*)$/ )/g' {} +
find . -name "CMakeLists.txt" -exec sed -i 's/^.*-Werror=.*$/ /g' {} +
find . -name "CMakeLists.txt" -exec sed -i 's/-Werror/-W/g' {} +
#Set the launch entry name to Early Access
sed -i -e '/Name=yuzu/ s/$/ Early Access/' dist/yuzu.desktop
#Dirty fix for some icons not appearing on Qt desktops and window managers
sed -i -e 's#Exec=yuzu %f#Exec=env QT_QPA_PLATFORMTHEME=gtk3 yuzu %f#g' dist/yuzu.desktop
#Potentially fix broken window grouping
sed -i -e '/yuzu %f/a StartupWMClass=yuzu' dist/yuzu.desktop
#Allow launching NSP and XCI files directly
sed -i -e 's_^MimeType=.*_&application/x-nx-nsp;application/x-nx-xci;_' dist/yuzu.desktop
#Add XCI and NSP entries to the mimetype XML to allow for direct launching
curl -s https://raw.githubusercontent.com/pineappleEA/Pineapple-Linux/master/yuzu.xml > ./dist/yuzu.xml || curl -s https://gitlab.com/samantas5855/pineapple/-/raw/master/yuzu.xml > ./dist/yuzu.xml
msvc=$(echo "${PWD##*/}"|sed 's/.*-//')
mkdir -p build && cd build
cmake .. -GNinja -DTITLE_BAR_FORMAT_IDLE="yuzu Early Access $title" -DTITLE_BAR_FORMAT_RUNNING="yuzu Early Access $title | {3}" -DENABLE_COMPATIBILITY_LIST_DOWNLOAD=ON -DENABLE_QT_TRANSLATION=ON -DGIT_BRANCH="HEAD" -DGIT_DESC="$msvc" -DBUILD_DATE="$build_date" -DUSE_DISCORD_PRESENCE=ON -DYUZU_USE_QT_WEB_ENGINE=OFF && ninja -j $(nproc)
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
if [ "$install" = "y" ] || [ "$install" = "Y" ]; then
	:
else
	printf "Aborting..."
    mkdir -p ~/earlyaccess
	mv bin/yuzu ~/earlyaccess/yuzu
	cd ~/earlyaccess/
	find /tmp/pineapple/* ! -name '*.7z' ! -name '*.aria2' | sort -n -r | xargs rm -rf --
	printf '\e[1;32m%-6s\e[m' "The binary sits at ~/earlyaccess/yuzu."
	printf "\n"
	exit
fi
#Install yuzu and cleanup /tmp
printf "Installing..."
sudo mv bin/yuzu /usr/local/bin/yuzu
#Mimetype fix
XML=/usr/share/mime/packages/yuzu.xml
if [ -f "$XML" ]; then
    :
else
	sudo sh -c "cp ../dist/yuzu.xml /usr/share/mime/packages"
	sudo update-mime-database /usr/share/mime
fi
#Launcher shortcut
FILE=/usr/share/applications/yuzu.desktop
if [ -f "$FILE" ]; then
    :
else
	sudo sh -c "cp ../dist/yuzu.svg /usr/share/icons/hicolor/scalable/apps"
	sudo sh -c "cp ../dist/yuzu.desktop /usr/share/applications"
	sudo update-desktop-database
fi
find /tmp/pineapple/* ! -name '*.7z' ! -name '*.aria2' | sort -n -r | xargs rm -rf --
printf "\n"
printf '\e[1;32m%-6s\e[m' "Installation completed. Use the command yuzu or run it from your launcher."
printf "\n"
