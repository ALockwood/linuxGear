#!/bin/bash
set -e

#This will configure the files in ./bash to be included in .bashrc.
#It will overwrite the "shell files source block" on each run.

SOURCE_CMD=""
BASHRC_BACKUP_FILE="$HOME/.bashrc.$(date +%s).bak"
BASHRC_FILE="$HOME/.bashrc"
BLOCK_START="#--shell files source block START--"
BLOCK_END="#--shell files source block END--"
#Thanks for the below to: https://stackoverflow.com/questions/59895/how-to-get-the-source-directory-of-a-bash-script-from-within-the-script-itself
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ ! -f ${BASHRC_FILE} ]; then
    echo "Unable to locate .bashrc at ${BASHRC_FILE}"
    echo "Quitting!"
    exit 1
fi

#Backup current .bashrc
echo "Backing up .bashrc to ${BASHRC_BACKUP_FILE}"
cp ${BASHRC_FILE} ${BASHRC_BACKUP_FILE}

#Check for the start and end delimiters
startFound=$(cat ${BASHRC_FILE} | { grep "${BLOCK_START}" || true; })
endFound=$(cat ${BASHRC_FILE} | { grep "${BLOCK_END}" || true; })

#If only start OR end was found - quit
if [[ ( ! -z "$startFound" && -z "$endFound" )  || ( -z "$startFound"  && ! -z "$endFound" ) ]]; then
    echo "🛑 Unable to locate start AND end blocks in .bashrc - quitting!"
    exit 1
fi

#if start and end not found, add them now
if [ -z "$startFound" ]  && [ -z "$endFound" ]; then
    echo "⚠️ Shell source block not found. Adding shell files source block..."
    echo -e "\n${BLOCK_START}" >> ${BASHRC_FILE}
    echo -e "\n${BLOCK_END}" >> ${BASHRC_FILE}
else
    echo "✔️ Shell files source block located"
fi

#Make sure all the .sh files in the directory are trusted or you're gonna have a bad time
echo "Getting shell files to add..."
for shellFile in ${DIR}/bash/*.sh; do
    SOURCE_CMD="${SOURCE_CMD}source ""$shellFile""\n"
done
echo "Adding shell files to .bashrc source block..."
sed -i -ne '/'"${BLOCK_START}"'/ {p; a'"${SOURCE_CMD}"'' -e ':a; n; /'"${BLOCK_END}"'/ {p; b}; ba}; p' ${BASHRC_FILE}

echo "Done!"
