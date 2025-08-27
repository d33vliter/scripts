#!/bin/bash

if [ -z "$1" ]; then
        tmp_script="/tmp/script.sh"
        vim $tmp_script
        if [ ! -f "$tmp_script" ]; then
                exit 1
        fi
        script=$(cat $tmp_script)

cat > main.go <<EOF
package main

import (
        "os"
        "os/exec"
)

func main() {
        // Tu script Bash como un string literal
        script := \`$script\`

        // Ejecutar el script directamente usando bash -c
        cmd := exec.Command("bash", "-c", script)

        // Redirigir la salida estándar y de errores al terminal
        cmd.Stdout = os.Stdout
        cmd.Stderr = os.Stderr

        // Ejecutar el comando
        err := cmd.Run()
        if err != nil {
                // Mostrar error si algo falla
                os.Stderr.WriteString("Error ejecutando el script: " + err.Error() + "\n")
        }
}
EOF

go build main.go

rm main.go

rm $tmp_script

elif [ -n "$1" ]; then
        script=$(cat $1)
        nombre=$(basename $1 .sh).go

cat > $nombre <<EOF
package main

import (
        "os"
        "os/exec"
)

func main() {
        // Tu script Bash como un string literal
        script := \`$script\`

        // Ejecutar el script directamente usando bash -c
        cmd := exec.Command("bash", "-c", script)

        // Redirigir la salida estándar y de errores al terminal
        cmd.Stdout = os.Stdout
        cmd.Stderr = os.Stderr

        // Ejecutar el comando
        err := cmd.Run()
        if err != nil {
                // Mostrar error si algo falla
                os.Stderr.WriteString("Error ejecutando el script: " + err.Error() + "\n")
        }
}
EOF

go build $nombre

rm $nombre.go

fi
