#!/bin/bash
#Script Para hacer despliegues, y rollback

fecha=$(date +%Y%m%d)

mkdir -p objetos 2>/dev/null

if [ -z $1 ];then
	echo "Elige una opción, por ejemplo: ./calvo.sh deploy, o rollback"
fi

deploy() {

	obj=$(ls -1 objetos/ 2>/dev/null )
	
	if [ -z "$obj" ];then
		echo "No hay nada mi bro :v"
		exit 1
	fi

	for x in $obj; do
		fichero=$(find . -type f -name "$x" | grep -Ev "objetos" | xargs realpath 2>/dev/null )
		
		if [ -z "$fichero" ]; then
			read -p "No existe $x, escribe ruta donde quieres deplegarlo: " ruta
			cp -p objetos/$x $ruta
			echo "Se desplego $x correctamente"
			yes | rm objetos/$x
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
				yes | cp objetos/$x $fichero
				echo "Se actualiza fichero $x correctamente"
				yes | rm objetos/$x
			else
			cp -p $fichero $backup
			echo "Se genero backup: $backup"
			yes | cp objetos/$x $fichero
			echo "Se actualiza fichero $x correctamente"
			yes | rm objetos/$x
			fi
		fi
	done
}


roll(){
	read -p "Introduzca nombre del fichero para hacer rollback: " fichero
	destino=$(find .  -name "$fichero" | grep -Ev "objetos" | sort | tail -1 | xargs realpath)
	backup=$(find .  -name "$fichero-BK*" | grep -Ev "objetos" | sort | tail -1 | xargs realpath)
	yes | cp -p $backup $destino
	echo "Se hizo rollback de $fichero con el backup: $backup"
}

$1
