#!/usr/bin/env bash

set -euo pipefail  # buena práctica para scripts seguros

ruta='/etc/sv/k0s'

# Instalar k0s
echo "[+] Instalando k0s..."
curl -sSf https://get.k0s.sh | sudo sh

# Crear directorio del servicio
echo "[+] Creando directorio para servicio runit..."
sudo mkdir -p "$ruta"

# Crear script de inicio runit
echo "[+] Escribiendo script runit..."

cat > "${ruta}/run" <<EOF
#!/bin/sh
exec /usr/local/bin/k0s controller --single
EOF

# Si prefieres usar múltiples nodos, descomenta esta línea y comenta la de arriba:
# exec /usr/local/bin/k0s controller --enable-worker

sudo chmod +x "${ruta}/run"

# Enlace simbólico (si no existe) para que runit lo active
if [ ! -L /var/service/k0s ]; then
  echo "[+] Activando servicio runit..."
  sudo ln -s "$ruta" /var/service/
fi

# Copiar y exportar kubeconfig
echo "[+] Configurando KUBECONFIG..."
cp /var/lib/k0s/pki/admin.conf ~/.admin.conf

# Agregar al bashrc solo si no existe
if ! grep -q 'KUBECONFIG=~/.admin.conf' ~/.bashrc; then
  echo 'export KUBECONFIG=~/.admin.conf' >> ~/.bashrc
  echo '[✓] Variable KUBECONFIG agregada a ~/.bashrc'
else
  echo '[i] KUBECONFIG ya estaba presente en ~/.bashrc'
fi

# Aplicar cambios de entorno
export KUBECONFIG=~/.admin.conf
source ~/.bashrc

echo "[✓] k0s instalado y configurado correctamente."
