#!/bin/bash
#SCRIPTS PARA HACER DESPLIEGUES Y ROLLBACKS

fecha=$(date +%Y%m%d)
rutafind="ruta/deseada" #AGREGAR RUTA ESPECIFICA PARA HACER TRABAJAR MENOS LA CPU
depth="3" #ESTO ES PARA ESPECIFICAR HASTA QUE PROFUNDIDAD DE CARPETAS BUSCARÁ.
excluido="OBJETOS|lib_original" #AGREGAR CARPETAS QUE QUIERES EXCLUIR DEL FIND

mkdir -p OBJETOS 2>/dev/null

if [ -z $1 ];then
        echo "Elige una opción, por ejemplo: ./calvo.sh deploy, o roll(rollback)"
fi

deploy() {

        obj=$(ls -1 OBJETOS/ 2>/dev/null )

        if [ -z "$obj" ];then
                echo "No hay nada mi bro :v"
                exit 1
        fi

        for x in $obj; do
                fichero=$(find "$rutafind" -maxdepth "$depth" -type f -name "$x" | grep -Ev "$excluido" | xargs realpath 2>/dev/null )

                if [ -z "$fichero" ]; then
                        read -p "No existe $x, escribe ruta donde quieres deplegarlo: " destino
                        read -p "Introduce Usuario, Grupo, permisos separado por espacios(ex: usuario grupo 777): " usuario grupo permiso
                        yes | cp OBJETOS/$x $destino
                        chown "$usuario:$grupo" "$destino/$nombre_archivo"
                        chmod "$permiso" "$destino/$nombre_archivo"
                        echo "Se desplego $x correctamente"

                elif [ $(echo "$fichero" | wc -w) -ge 1 ];then
                        for z in $fichero;do
                                backup=$(echo "${z}-BK-$fecha")
                                if [ -e "$backup" ]; then
                                        count=1
                                        while [ -e "${backup}_${count}" ]; do
                                                ((count++))
                                        done
                                        backup=$(echo ${backup}_${count})
                                        cp -p $z $backup
                                        echo "Se genero backup: $backup"
                                        yes | cp OBJETOS/$x $z
                                        echo "Se actualiza fichero $x correctamente"

                                else
                                cp -p $z $backup
                                echo "Se genero backup: $backup"
                                yes | cp OBJETOS/$x $z
                                echo "Se actualiza fichero $x correctamente"
                                fi
                        done

                else
                        backup=$(echo "${fichero}-BK-$fecha")
                        if [ -e "$backup" ]; then
                                count=1
                                while [ -e "${backup}_${count}" ]; do
                                        ((count++))
                                done
                                backup=$(echo ${backup}_${count})
                                cp -p $fichero $backup
                                echo "Se genero backup: $backup"
                                yes | cp OBJETOS/$x $fichero
                                echo "Se actualiza fichero $x correctamente"

                        else
                        cp -p $fichero $backup
                        echo "Se genero backup: $backup"
                        yes | cp OBJETOS/$x $fichero
                        echo "Se actualiza fichero $x correctamente"
                        fi
                fi
        done
        yes | rm OBJETOS/*
}


roll(){
        read -p "Introduzca nombre del fichero para hacer rollback: " fichero
        destino=$(find "$rutafind" -maxdepth "$depth" -type f -name "$fichero" | grep -Ev "$excluido" | sort | xargs realpath | xargs dirname)

        for x in $destino;do
                backup=$(find "$x" -maxdepth "$depth" -type f -name "$fichero-BK*" | grep -Ev "$excluido" | sort | tail -1 | xargs realpath)
                yes | cp -p "$backup" "$x"/"$fichero"
                echo "Se hizo rollback de $fichero con el backup: $backup"
        done
}

$1
