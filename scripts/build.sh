#!/bin/sh

# Given the flag -f, the build will force a rebuild of the arrowhead system.
while getopts f flag
do
  case "${flag}" in
    f) FORCE=true;;
  esac
done

if [[ -z "$(ls -A ../certificates)" || $FORCE ]]; then
    echo "Building arrowhead.."

    echo "Generating certificates..."
    cd ./certificate-generation-scripts
    bash generate_core_certificates.sh
    cd ../
    bash build_custom_systems.sh
else
    echo "Already built!"
fi

