#!/usr/bin/env bash

carpeta="nginx"
verificar=$(git log --name-only --pretty=format:'' | awk 'NF {print} !NF {exit}' | grep $carpeta | wc -l)

if [ $verificar -eq 1 ]; then
	echo "si actualizaremos :D"
else
	echo "no hay nimi"
	exit 0
fi


cd $carpeta && docker compose up -d --dry-run

if [ $? -eq 0 ];then
	echo "Paso la prueba :v, desplegando..."
	docker compose up -d
	echo "Se actualiza contenedor"
else
	echo "algo malio sal, arregla tu porqueria"
fi
