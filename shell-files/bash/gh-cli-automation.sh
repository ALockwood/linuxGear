#!/bin/bash
set -e

# A collection of functions to automate GitHub CLI tasks

# CONSTANTS
GH_DEFAULT_BRANCH="main" # Default branch for pull requests

# Make a PR from the local branch to the value defined in $GH_DEFAULT_BRANCH
function make-pr() {
  local title="$1"
  if [ -z "$title" ]; then
    echo "🤔 Are you SURE you want the title to be empty?"
    read -p "You can enter a title now, or press ENTER to continue with a shameful default: " usr_title
    if [ -z "$usr_title" ]; then
      title="Shame Me: I was Too Lazy to Enter a Title"
    else
      title="$usr_title"
    fi
  fi
  echo ""

  current_branch=$(git rev-parse --abbrev-ref HEAD)
  if [ -z "$current_branch" ]; then
    echo "😱 No current branch found?!"
    echo "Exiting..."
    return 1
  fi

  # Example usage:
  if is_branch_clean; then
    echo "Current branch is clean."
  else
    echo "Current branch is NOT clean."
  fi
  #gh pr create --base "${GH_DEFAULT_BRANCH}" --title "${title}" --body "\n\n${current_branch}" --web
}


function is_branch_clean() {
  # Check if the current branch is tracking a remote branch
  tracking_info=$(git status -b 2> /dev/null)
  if [[ ! "$tracking_info" =~ "Your branch is up to date with" ]] &&
     [[ ! "$tracking_info" =~ "Your branch is ahead of" ]]; then
    echo "💥 Not tracking a remote branch or behind. Fix this before making a PR."
    return 1
  fi

  # Check for untracked files
  untracked_files=$(git status --porcelain | grep "^??")
  if [ -n "$untracked_files" ]; then
    echo "Untracked files present:"
    echo "$untracked_files"
    echo "Please add or remove these files before making a PR."
    return 1
  fi

  # Check if there are any uncommitted changes (ahead is acceptable)
  dirty_index=$(git status --porcelain | grep "^M\|^A\|^D\|^R\|^C")
  if [ -n "$dirty_index" ]; then
    echo "Uncommitted changes present:"
    echo "$dirty_index"
    return 1
  fi

  # If all checks pass
  return 0
}

