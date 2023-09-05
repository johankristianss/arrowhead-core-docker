#!/bin/sh

bash stop.sh

# Given the flag -r, the startup docker container will force a rebuild of the arrowhead system.
while getopts r flag
do
  case "${flag}" in
    r) REBUILD=true;;
  esac
done
if [ $REBUILD ]; then
    touch .rebuild  
fi


echo "Starting arrowhead..."
cd ..
docker compose up -d --build


if [ $REBUILD ]; then
    cd ./scripts
    rm .rebuild  
fi