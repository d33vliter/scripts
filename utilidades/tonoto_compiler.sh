#!/bin/bash
#sirve para ofuzcar tu script sh, compilado en go xdxdxd.
if [ -z "$1" ]; then
        tmp_script="/tmp/script.sh"
        touch $tmp_script
        echo '#!/bin/bash' > $tmp_script
        vim $tmp_script
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

yes | rm $tmp_script

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
fi
