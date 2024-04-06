#!/bin/bash
set -e

wget https://go.microsoft.com/fwlink/?LinkID=760868 -O /tmp/vscode.deb
sudo apt install /tmp/vscode.deb
rm /tmp/vscode.deb
echo "VS Code installed!"
