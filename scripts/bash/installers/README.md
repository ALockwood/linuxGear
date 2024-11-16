# Bash Installers
A mix of scripts (or script-like notes) for installing various _things_ via bash.

⚠️ **WARNING!** These may be in very rough shape and may not even be runnable. ⚠️


## Windows/Linux File Permissions Notes
Windows and Linux (and VS Code on Windows, working with a WLS2 filesystem) has a real time with the executable perm.
To resolve issues if they crop up again, do the following:
```
# Unset the filemode in local repo scope:
  git config --unset --local core.fileMode
# In Windows set the filemode to false at the global scope:
  git config --global core.filemode false
# In WSL2 set the filemode to true at the global scope:
  git config --global core.filemode true
```
