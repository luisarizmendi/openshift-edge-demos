#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <new-url>"
    exit 1
fi

NEW_URL="$1"
OLD_URL="https://github.com/luisarizmendi/openshift-edge-demos"

find ../ -type f -exec sed -i "s|$OLD_URL|$NEW_URL|g" {} +

echo "Replaced all instances of '$OLD_URL' with '$NEW_URL' in the directory '../'."
