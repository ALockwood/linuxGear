#!/bin/bash
# A collection of functions to automate GitHub CLI tasks


# Make a PR from the local branch to the value defined in $GH_DEFAULT_BRANCH
function make-pr() {
  local GH_DEFAULT_BRANCH="main" # Default branch for pull requests
  
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

  if is_branch_clean; then
    echo "👍 Current branch is clean, attempting to create PR..."
    # --body doesn't accept multiline input, so we use a workaround
    echo -e "\n\n${current_branch}" | gh pr create --base "${GH_DEFAULT_BRANCH}" --title "${title}" --web  --body-file - 
  fi
}


function is_branch_clean() {
  # Check if the current branch is tracking a remote branch
  tracking_info=$(git status -b 2> /dev/null)
  if [[ ! "$tracking_info" =~ "Your branch is up to date with" ]]; then
    echo "💥 Not tracking a remote branch or out of sync with remote. Resolve this before making a PR."
    return 1
  fi

  # Check for untracked files
  untracked_files=$(git status --porcelain | grep "^??")
  if [ -n "$untracked_files" ]; then
    echo "Untracked files present:"
    echo "$untracked_files"
    echo "💥 Please add or remove these files before making a PR."
    return 1
  fi

  # Check if there are any uncommitted changes (ahead is acceptable)
  dirty_index=$(git status --porcelain | grep "^M\|^A\|^D\|^R\|^C\|^ M\|^AM\|^RM\|^CM")
  if [ -n "$dirty_index" ]; then
    echo "Uncommitted changes present:"
    echo "$dirty_index"
    echo "💥 Please commit or stash these changes before making a PR."
    return 1
  fi

  # If all checks pass
  return 0
}
