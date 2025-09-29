#!/bin/sh
ruta='/media/external/bsd/Guild Wars 2' #cambiala a la ruta donde hayas instalado GW2
WINEPREFIX="$HOME/.wine"
WINEESYNC=1
WINEDEBUG=-all
DXVK_HUD="devinfo,fps,gpuload,compiler"
DXVK_STATE_CACHE=1
export WINEPREFIX DXVK_HUD DXVK_STATE_CACHE WINEESYNC WINEDEBUG

cd "$ruta" || { echo "No se pudo acceder a $ruta"; exit 1; } 

trap 'wineserver -k' EXIT
wine 'Gw2-64.exe' -ignorecoherentgpucrash
