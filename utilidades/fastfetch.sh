#!/usr/bin/env bash

version=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases | jq -r '.[].tag_name' | head -1)

wget https://github.com/fastfetch-cli/fastfetch/releases/download/${version}/fastfetch-linux-amd64.tar.gz
tar -xvf fastfetch-linux-amd64.tar.gz

yes | mv fastfetch-linux-amd64/usr/bin/fastfetch /usr/bin/fastfetch
rm -rf fastfetch-linux-amd64.tar.gz fastfetch-linux-amd64
