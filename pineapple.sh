#Clean old files (minus archive), prepare the env
find /tmp/pineapple/* ! -name '*.7z' 2>/dev/null | sort -n -r | xargs rm -rf --
mkdir -p /tmp/pineapple && cd /tmp/pineapple
#Download and save links currently listed on PinEApple site
curl -s https://raw.githubusercontent.com/pineappleEA/pineappleEA.github.io/master/index.html| sed -e '0,/^			<!--link-goes-here-->$/d' -e '/div/q;p'| head -n -2 | uniq > version.txt
latest=$(head -n 1 version.txt | sed -n 's:.*EA [0-9]*')
#Print UwU text
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
printf "\non pizza\nBrought to you by EmuWorld!\n\e[91m$(tput bold)NOW BACK FROM THE DEAD!\e[0m Check option 4 to get a new invite.\nLatest yuzu EA version is $latest\n"
prompt()
{
    printf " [1] Download it \n [2] Download an older version \n [3] Uninstall \n [4] To display Discord Invite\n or anything else to exit.\nOption:"
    read option <&1
    if [ "$option" = "1" ]; then
        id=$(head -n 1 version.txt | sed -n 's:.*<!--\(.*\)-->.*:\1:p')
        version=$latest
    elif [ "$option" = "2" ]; then
        old=$(tail -n+2 version.txt | grep -o 'EA .*' | tr -d '</a><br>' | sed -e ':a;N;$!ba;s/\n/,/g' | sed 's/EA //g')
        printf "Available older versions:\n$old\nChoose old version:"
        read title <&1
        version=$title
        old_ver="\s${version}</a><br>"
        if [[ $(grep "$old_ver" version.txt) ]]; then
            line_num=$(grep -n $version version.txt | cut -f1 -d:)
            id=$(head -$line_num version.txt | tail -1 | sed -n 's:.*/d/\(.*\)/view.*:\1:p')
        else
            echo "Wrong version number, exiting..."
            exit
        fi
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
    else
        printf "Exiting...\n"
        exit
    fi
}
prompt
#Download from gdrive
printf "Connecting to Google Drive(this may take some time)..."
filename="YuzuEA-$version.7z"
curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${id}" > /dev/null
printf "\n"
curl -Lb ./cookie -C - "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${id}" -o ${filename}
#Extract the archive
ZIPNAME=YuzuEA-$title.7z
7z x $ZIPNAME yuzu-windows-msvc-early-access/yuzu-windows-msvc-source-*
if [ -d "yuzu-windows-msvc-early-access" ]; then
	cd yuzu-windows-msvc-early-access
else
	printf "Extraction faile, please report.\nGrab the latest appimage from https://edisionnano.github.io/\n"
	exit
fi
tar -xf yuzu-windows-msvc-source-*
rm yuzu-windows-msvc-source-*.tar.xz 
#Compilation
cd $(ls -d yuzu-windows-msvc-source-*)
find -path ./dist -prune -o -type f -exec sed -i 's/\r$//' {} ';'
find . -exec touch {} +
wget -q https://raw.githubusercontent.com/PineappleEA/Pineapple-Linux/master/inject-git-info.patch
patch -p1 < inject-git-info.patch
msvc=$(echo "${PWD##*/}"|sed 's/.*-//')
mkdir -p build && cd build
cmake .. -GNinja -DTITLE_BAR_FORMAT_IDLE="yuzu Early Access $version" -DTITLE_BAR_FORMAT_RUNNING="yuzu Early Access $version | {3}" -DENABLE_COMPATIBILITY_LIST_DOWNLOAD=ON -DGIT_BRANCH="HEAD" -DGIT_DESC="$msvc" -DUSE_DISCORD_PRESENCE=ON -DYUZU_USE_QT_WEB_ENGINE=ON && ninja -j $(nproc)
if [ $? -ne 0 ]; then
	printf "\n------------------------------------------------------------------------------\nCompilation failed but fear not, you can always use our precompiled Appimages (includes autoupdater) and binaries at:\nhttps://edisionnano.github.io/\nIf you see a compilation error please check that you have all the dependencies and report it on our discord server.\nYou might want to try an older version of yuzu\nIf that doesn't help, feel free to contact us on discord in the #linux channel\n"
    exit
fi
printf '\e[1;32m%-6s\e[m' "Compilation completed, do you wish to install it[y/n]?:"
read install <&1
#Save compiler output to ~/earlyaccess/yuzu and cleanup /tmp if user doesn't want to install
if [ "$install" = "n" ]; then
	mkdir -p ~/earlyaccess
	mv bin/yuzu ~/earlyaccess/yuzu
	cd ~/earlyaccess/
	find /tmp/pineapple/* ! -name '*.7z' ! -name '*.aria2' | sort -n -r | xargs rm -rf --
	printf '\e[1;32m%-6s\e[m' "The binary sits at ~/earlyaccess/yuzu.\n"
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
cd /usr/share/pixmaps
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
find /tmp/pineapple/* ! -name '*.7z' | sort -n -r | xargs rm -rf --
printf '\e[1;32m%-6s\e[m' "Installation completed. Use the command yuzu or run it from your launcher.\n"
