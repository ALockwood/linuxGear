#!/bin/bash
set -e

pushd ~/Downloads > /dev/null
wget https://download.jetbrains.com/fonts/JetBrainsMono-1.0.2.zip
unzip -ojq JetBrainsMono-1.0.2.zip "*.ttf" -d jbmono
mkdir -p ~/.fonts
cp jbmono/*.ttf ~/.fonts
rm -rf jbmono
rm JetBrainsMono-1.0.2.zip
popd > /dev/null
fc-cache -f -v
