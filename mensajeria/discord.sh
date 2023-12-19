#!/usr/bin/env bash

wget "https://discord.com/api/download?platform=linux&format=tar.gz" -O discord.tar.gz
tar -xvzf discord.tar.gz -C /opt
rm -rf discord.tar.gz
ln -sf /opt/Discord/Discord /usr/bin/Discord

cat << EOF > /usr/share/applications/discord.desktop
[Desktop Entry]
Name=Discord
StartupWMClass=discord
Comment=All-in-one voice and text chat for gamers.
GenericName=Internet Messenger
Exec=/usr/bin/Discord
Icon=/opt/Discord/discord.png
Type=Application
Categories=Network;InstantMessaging;
Path=/usr/bin
EOF
