#!/usr/bin/env bash

set -euo pipefail

version=$(curl -sL https://api.github.com/repos/k3s-io/k3s/tags |jq -r ".[].name" | head -1)
svc_path='/etc/sv/k3s'

#Descargar e instalar
curl -sL -o /tmp/k3s "https://github.com/k3s-io/k3s/releases/download/${version}/k3s"
sudo install -m 0755 /tmp/k3s /usr/local/bin/k3s
rm /tmp/k3s

#Crear e iniciar servicio runit
echo "[+] Configurando servicio runit...espere 5 segundos para que genere el /etc/rancher"
sudo mkdir -p "$svc_path"

sudo tee "${svc_path}/run" > /dev/null <<EOF
#!/bin/sh
exec /usr/local/bin/k3s server
EOF

sudo chmod +x "${svc_path}/run"

#Enlace simbólico para que runit lo gestione
if [ ! -L /var/service/k3s ]; then
  sudo ln -s "$svc_path" /var/service/
fi
sleep 5s #esto es necesario para que pueda hacer la config de /etc/rancher

#Copiar archivo de configuración de kubeconfig
echo "[+] Copiando configuración de kubeconfig..."
mkdir -p ~/.k3s
sudo cp /etc/rancher/k3s/k3s.yaml ~/.k3s/config
sudo chown $(id -u):$(id -g) ~/.k3s/config

#Agregar export si no existe
if grep -q 'KUBECONFIG=~/.k3s/config' ~/.bashrc; then
  echo 'ya existe el export en tu .bashrc, refrescando config.'
else
  echo 'export KUBECONFIG=~/.k3s/config' >> ~/.bashrc
  echo 'agregado export KUBECONFIG a tu .bashrc'
fi

echo "[+] Refrescando entorno..."
export KUBECONFIG=~/.k3s/config
source ~/.bashrc


echo "[+] Verificando configuración de k3s..."
k3s check-config

echo "[✓] Instalación completada. Ya puedes usar k3s :D"
