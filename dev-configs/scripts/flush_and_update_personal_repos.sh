#!/bin/sh

cd ~/Home/Development/personal/ || { echo "Failed to cd to personal directory; aborting." >&2; exit 1; }
base_dir=$(pwd)

for repo in */;
do
  # Guard the cd: the force branch deletions below must only ever run inside
  # the intended repository, never in an unexpected working directory.
  cd "$repo" || { echo "Skipping $repo: cannot enter directory." >&2; continue; }
  echo "========== Flushing and Updating $repo =========="

  default_branch=$(git rev-parse --abbrev-ref origin/HEAD | cut -f2- -d/)
  default_remote_branch=$(git rev-parse --abbrev-ref origin/HEAD)

  if [ -n "$default_branch" ]; then
    git switch "$default_branch"
  else
    git switch -c "$default_branch" "$default_remote_branch"
  fi

  git branch | sed s/^[[:space:]]*// | grep -Ev "$default_branch" | xargs -n1 git branch -D
  git branch -r | sed s/^[[:space:]]*// | grep -v ^origin/HEAD | grep -Ev "$default_remote_branch" | xargs -n1 git branch -rD
  git pull --recurse-submodules
  git submodule update --remote --merge
  git config --global submodule.recurse true
  git stash clear
  echo "========== Finished Flushing and Updating $repo =========="
  cd "$base_dir" || exit 1
done

cd -

echo "||====================||"
echo "||    COMPLETED 🎉    ||"
echo "||====================||"

exit 0
