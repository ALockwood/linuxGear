#!/bin/bash
set -e
# The latest LTS version of Node.js via nvm

# Check for nvm installation, will halt the script if not found
command -v nvm

# Install the latest LTS
nvm install --lts
