Pasos para hacer funcionar todo bien:

1.Instalar wine-proton:

`doas ln -sf /usr/local/wine-proton/bin/wine /usr/local/bin/wine`

2. Para audio:
   
`WINEPREFIX=~/.wine wine reg add "HKCU\Software\Wine\Drivers" /v Audio /d pulse /f`

4. Fonts:
   
`winetricks -q corefonts tahoma`

5. En winecfg agregar d3d11 y dxgi.
