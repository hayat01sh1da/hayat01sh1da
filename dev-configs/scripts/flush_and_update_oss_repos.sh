#!/bin/sh

cd ~/Home/Development/oss/ || { echo "Failed to cd to oss directory; aborting." >&2; exit 1; }
base_dir=$(pwd)

for repo in */;
do
  # Guard the cd: the force branch deletions below must only ever run inside
  # the intended repository, never in an unexpected working directory.
  cd "$repo" || { echo "Skipping $repo: cannot enter directory." >&2; continue; }
  echo "========== Flushing and Updating $repo =========="

  default_branch=$(git rev-parse --abbrev-ref origin/HEAD | cut -f2- -d/)
  default_remote_branch=$(git rev-parse --abbrev-ref origin/HEAD)
  default_upstream_branch=$(git rev-parse --abbrev-ref upstream/HEAD)

  if [ -n "$default_branch" ]; then
    git switch "$default_branch"
  else
    git switch -c "$default_branch" "$default_remote_branch"
  fi

  git remote set-head upstream --auto
  git branch | sed s/^[[:space:]]*// | grep -Ev "$default_branch" | xargs -n1 git branch -D
  git branch -r | sed s/^[[:space:]]*// | grep -v '^(origin|upstream)$/HEAD' | grep -Ev "$default_remote_branch" | grep -Ev "$default_upstream_branch" | xargs -n1 git branch -rD
  git submodule update --remote --merge
  git config --global submodule.recurse true
  echo "$default_branch" | xargs -n1 git pull origin
  echo "$default_branch" | xargs -n1 git fetch upstream
  echo "$default_upstream_branch" | xargs -n1 git merge
  echo "$default_branch" | xargs -n1 git push origin
  git stash clear
  echo "========== Finished Flushing and Updating $repo =========="
  cd "$base_dir" || exit 1
done

cd -

echo "||====================||"
echo "||    COMPLETED 🎉    ||"
echo "||====================||"

exit 0
