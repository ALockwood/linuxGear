#!/bin/bash
set -e

# Installs bash-git-prompt in $GP_DIR and configures ~/.bashrc to use it
GP_DIR="$HOME/src/.bash-git-prompt"

# Clone bash-git prompt
mkdir -p ${GP_DIR}
if [ -d ${GP_DIR} ]; then
    echo "Removing existing bash-git-prompt directory"
    rm -rf ${GP_DIR}
fi
echo "Cloning bash-git-prompt to ${GP_DIR}"
git clone https://github.com/magicmonty/bash-git-prompt.git ${GP_DIR} --depth=1 --quiet

# Remove existing git prompt block if it exists
sed -i '/#--GIT PROMPT START--/,/#--GIT PROMPT END--/d' ~/.bashrc
# Configure bashrc
echo '#--GIT PROMPT START--
GP_DIR="$HOME/src/.bash-git-prompt"
if [ -f "${GP_DIR}/gitprompt.sh" ]; then
    #DIR_BASE="\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]"
    #GIT_PROMPT_END="${DIR_BASE}$ "
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_THEME=Solarized_Ubuntu
    source ${GP_DIR}/gitprompt.sh
fi
#--GIT PROMPT END--' >> ~/.bashrc
