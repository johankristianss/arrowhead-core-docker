#!/bin/sh

if [ -z "$(ls -A ./certificates)" ]; then
   bash build.sh
fi

echo "Staring arrowhead..."
docker compose up -d --build
