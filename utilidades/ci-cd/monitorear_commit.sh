#!/usr/bin/env bash

repo_local="/home/$HOME/proyectos/cicd/pelo"
rama="main"

cd $repo_local || exit 1

last_commit=$(git rev-parse HEAD)

clear
echo "MONITOREANDO :V"

while true; do
	git fetch origin

	new_commit=$(git rev-parse origin/$rama)

	if [ $new_commit != $last_commit ];then
		clear;echo $(date)

		echo "Se detecto nuevo commit: $new_commit"

		last_commit="$new_commit"

		git pull origin $rama

		/home/$HOME/proyectos/cicd/actualizar_nginx.sh
	fi
		
	sleep 2s
done
