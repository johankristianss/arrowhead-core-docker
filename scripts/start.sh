#!/bin/sh

bash stop.sh

# Given the flag -r, the startup docker container will force a rebuild of the arrowhead system.
while getopts rd flag
do
  case "${flag}" in
    r) REBUILD=true;;
    d) DETACH=true
  esac
done
if [ $REBUILD ]; then
    touch .rebuild  
fi


echo "Starting arrowhead..."
cd ..
if [ $DETACH ]; then
  docker compose up -d --build
else
  docker compose up --build
fi

if [ $REBUILD ]; then
    cd ./scripts
    rm .rebuild  
fi