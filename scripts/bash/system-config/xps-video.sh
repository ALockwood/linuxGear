#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    >&2 echo -e "${RED}Run as root!${NC}"
    exit 2
fi

if [[ $(uname -r) == *"4.15"* ]]; then
    echo "options i915 enable_fbc=1 enable_guc_loading=1 enable_guc_submission=1 fastboot=1" > /etc/modprobe.d/i915.conf
else
    echo "options i915 enable_fbc=1 enable_guc=3 fastboot=1" > /etc/modprobe.d/i915.conf
fi
update-initramfs -u
update-grub
