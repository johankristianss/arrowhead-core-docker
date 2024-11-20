#!/bin/sh

cd ../scripts

if [ -f ".rebuild" ]; then
    bash build.sh -f
else
    bash build.sh

fi
