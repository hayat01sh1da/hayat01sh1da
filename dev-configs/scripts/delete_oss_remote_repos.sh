#!/bin/sh

cd ~/Home/Development/oss/ || { echo "Failed to cd to oss directory; aborting." >&2; exit 1; }
base_dir=$(pwd)

# The delete_repo scope belongs to the account, not to a repository: request it
# once instead of going through the authorisation flow for every repository.
gh auth refresh -h github.com -s delete_repo

for repo in */;
do
  # Guard the cd: the force branch deletions below must only ever run inside
  # the intended repository, never in an unexpected working directory.
  cd "$repo" || { echo "Skipping $repo: cannot enter directory." >&2; continue; }
  echo "========== Deleting Remote Repository of $repo =========="
  gh repo set-default
  gh repo delete --yes
  echo "========== Finished Deleting Remote Repository of $repo =========="
  cd "$base_dir" || exit 1
done

cd -

echo "||====================||"
echo "||    COMPLETED 🎉    ||"
echo "||====================||"

exit 0
