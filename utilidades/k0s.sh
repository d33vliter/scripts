#!/usr/bin/env bash

ruta='/etc/sv/k0s'

curl -sSf https://get.k0s.sh | sudo sh #instalar k0s

sudo mkir $ruta

sudo echo '#!/bin/sh' > ${ruta}/run 
#sudo echo 'exec /usr/local/bin/k0s controller --enable-worker' >> ${ruta}/run #para multiples nodos

sudo echo 'exec /usr/local/bin/k0s controller --single' >> ${ruta}/run #para usar todo en 1 nodo si eres pobre
sudo chmod +x ${ruta}/run

sudo cp /var/lib/k0s/pki/admin.conf ~/admin.conf
echo 'export KUBECONFIG=~/admin.conf' >> ~/.bashrc

source .bashrc
