#!/bin/bash
set -e

if ! bver=$(bash --version | grep "version 4."); then
    echo "This script requires bash version >= 4.x"
    echo "Quitting..."
    exit 1
fi

# Setup a quick version of 'enhanced echo' to make colourizing text easier
NC="\e[0m"
declare -A colours
colours+=( 
    [white]="\e[1;37m" \
    [black]="\e[0;30m" \
    [blue]="\e[0;34m" \
    [light_blue]="\e[1;34m" \
    [green]="\e[0;32m" \
    [light_green]="\e[1;32m" \
    [cyan]="\e[0;36m" \
    [light_cyan]="\e[1;36m" \
    [red]="\e[0;31m" \
    [light_red]="\e[1;31m" \
    [purple]="\e[0;35m" \
    [light_purple]="\e[1;35m" \
    [brown]="\e[0;33m" \
    [yellow]="\e[1;33m" \
    [gray]="\e[0;30m" \
    [light_gray]="\e[0;37m" \
)
function eEcho() {
    if [ ! -z "${2}" ] && [ ${colours[$2]+x} ]; then
        echo -e "${colours[$2]}${1}${NC}"
    else
        echo "${1}"
    fi
}

if [ ! -f /sys/power/mem_sleep ]; then
    eEcho "This system does not support suspend!" red
    exit 1
fi

# make sure this doesn't show disabled (safeboot enabled?)
if checksb=$(cat /sys/power/disk | grep disabled); then
    eEcho "Safeboot may be enabled. Cannot proceed!" red
    exit 1
fi

# make hibernate is supported (disk listed)
if ! checkhib=$(cat /sys/power/state | grep disk); then
    eEcho "Hibernate not supported!" red
    exit 1
fi

#For more info: https://www.kernel.org/doc/html/v4.18/admin-guide/pm/sleep-states.html
SLEEP=$(cat /sys/power/mem_sleep | sed 's/.*\[\([a-zA-Z0-9_]*\)\].*/\1/')
echo -e "Current mem_sleep setting: ${colours[green]}${SLEEP}${NC}"

SWAP_SETTINGS=$(swapon --show)
HAS_SWAPFILE=1
# Check if the system is using a swap file or swap partition. If neither; bail
if checkpart=$(echo "${SWAP_SETTINGS}" | grep partition); then
    eEcho "System is configured with a swap partition." green
    $HAS_SWAPFILE=0
else
    if checkswapf=$(echo "${SWAP_SETTINGS}" | grep swapfile); then
        eEcho "System is configured with a swapfile." yellow
    else
        eEcho "Unable to determine swap settings!" red
        exit 1
    fi
fi

#TODO
echo "$HAS_SWAPFILE"