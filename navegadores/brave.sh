#!/usr/bin/env bash

clear
version=$(curl -s https://brave.com/latest/ | grep 'release-notes' | grep -Ev 'Windows Only' | head -1 | cut -d '>' -f3 | cut -d '<' -f1 | sed 's/v//g')
file=$(ls /opt/ 2> /dev/null | grep 'Brave' | wc -l)


if [ "$file" = 0 ];then
	clear;echo "Instalando Brave Browser";sleep 1s
	wget https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser-${version}-linux-amd64.zip
	unzip brave-browser-${version}-linux-amd64.zip -d Brave
	rm -rf brave-browser-${version}-linux-amd64.zip
	cp -rp Brave /opt/
	rm -rf Brave
	clear;echo "Se Instalo Brave Browser :D"

cat << EOF > /usr/share/applications/brave.desktop
[Desktop Entry]
Name=Brave
StartupWMClass=discord
Comment=All-in-one voice and text chat for gamers.
GenericName=Internet Messenger
Exec=/opt/Brave/brave
Icon=/opt/Brave/product_logo_32.png
Type=Application
Categories=Network;WebBrowser;
Path=/usr/bin
EOF

elif [ "$version" != $(/opt/Brave/brave --version | cut -d ' ' -f3 | cut -c5-) ];then
	clear;echo "Actualizando Brave Browser";sleep 1s
	rm -rf /opt/Brave
	wget https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser-${version}-linux-amd64.zip    
        unzip brave-browser-${version}-linux-amd64.zip -d Brave
	rm -rf brave-browser-${version}-linux-amd64.zip
        cp -rp Brave /opt/
	rm -rf Brave
	clear;echo "Se actualizo Brave Browser a la version: $version"

else
	clear;echo "Ya tienes la ultima version: $version"
fi

