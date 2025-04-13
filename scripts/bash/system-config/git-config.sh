#!/bin/bash

read -p "Enter your email address: " email
if [ -z "$email" ]; then
    echo "😞"
    exit 1
fi

git config --global user.name "Andrew Lockwood"
git config --global user.email "${email}"
git config --global core.editor "code"
