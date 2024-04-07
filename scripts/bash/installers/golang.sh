#!/bin/bash
set -e

# Installs x86 Go version set in $VERSION
VERSION="1.22.2"

# Download and install Go
wget "https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz

# Remove existing Go installation
sudo rm -rf /usr/local/go
# Install Golang, remove temp file
sudo tar -C /usr/local -xzf /tmp/go.tar.gz && rm /tmp/go.tar.gz

# Assume if not already set in path then it's OK to add to .bashrc
if ! echo $PATH | grep -q "/usr/local/go/bin"; then
    echo "Updating ~/.bashrc..."
    echo -e '\nexport PATH=$PATH:/usr/local/go/bin' >> $HOME/.bashrc
    # Update path temporarily
    PATH=$PATH:/usr/local/go/bin
fi

# Check go version
go version