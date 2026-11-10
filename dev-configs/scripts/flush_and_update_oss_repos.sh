#!/bin/sh

cd ~/Home/Development/oss/ || { echo "Failed to cd to oss directory; aborting." >&2; exit 1; }
base_dir=$(pwd)

# Set once, and only when it is not set yet, instead of rewriting ~/.gitconfig
# for every repository on every run.
[ "$(git config --global --get submodule.recurse)" = true ] || git config --global submodule.recurse true

for repo in */;
do
  # Guard the cd: the force branch deletions below must only ever run inside
  # the intended repository, never in an unexpected working directory.
  cd "$repo" || { echo "Skipping $repo: cannot enter directory." >&2; continue; }
  echo "========== Flushing and Updating $repo =========="

  default_remote_branch=$(git rev-parse --abbrev-ref origin/HEAD)
  default_branch=${default_remote_branch#*/}
  default_upstream_branch=$(git rev-parse --abbrev-ref upstream/HEAD)

  if [ -n "$default_branch" ]; then
    git switch "$default_branch"
  else
    git switch -c "$default_branch" "$default_remote_branch"
  fi

  git remote set-head upstream --auto
  # One `git branch -D` for all branches instead of one process per branch.
  git branch | sed s/^[[:space:]]*// | grep -Ev "$default_branch" | xargs -r git branch -D --
  git branch -r | sed s/^[[:space:]]*// | grep -v '^(origin|upstream)$/HEAD' | grep -Ev "$default_remote_branch" | grep -Ev "$default_upstream_branch" | xargs -r git branch -rD --
  git submodule update --remote --merge
  git pull origin "$default_branch"
  git fetch upstream "$default_branch"
  git merge "$default_upstream_branch"
  git push origin "$default_branch"
  git stash clear
  echo "========== Finished Flushing and Updating $repo =========="
  cd "$base_dir" || exit 1
done

cd -

echo "||====================||"
echo "||    COMPLETED 🎉    ||"
echo "||====================||"

exit 0
