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

# NOTE: These mitigations are expressly disabled because the 10th gen i7-10710U "Comet Lake" has CPU mitigations.
# Don't use if you're not running this CPU
# CVE Vulns checked before and after changes with: https://github.com/speed47/spectre-meltdown-checker
GRUB_OPTIONS="mds=off l1tf=off pti=off kpti=off"

if < /etc/default/grub grep "$GRUB_OPTIONS" &>/dev/null; then
    echo -e "${GREEN}Mitigations already applied 👍${NC}"
else
    echo "Appending mitigations..."
    sed -r "s/(^GRUB_CMDLINE_LINUX_DEFAULT=.*)(\")$/\1$GRUB_OPTIONS\" /g" /etc/default/grub
    update-grub
fi