#!/bin/sh

# Delete Cache, History and Temporary Directories and/or files
targets=(
  .*_history
  .aws
  .azure
  .cache/
  .local/
  .vscode-remote-containers
  node_modules/
  pnpm-lock.yaml
  pnpm-store
  snap/
  tmp/
)

# Abort if we cannot reach $HOME: the rm -rf / gem / pip steps below are
# destructive and must never run from an unexpected working directory.
cd ~/ || { echo "Failed to cd to home directory; aborting." >&2; exit 1; }

echo "========== Flushing Cache, History and Temporary Directories and/or files =========="
for target in "${targets[@]}";
do
  rm -rf ~/$target
done
echo "========== Done Flushing Cache, History and Temporary Directories and/or files =========="

echo "========== Flushing Gems =========="
# Flush Gems
gem uninstall -I -a -x --user-install --force
echo "========== Done Flushing Gems =========="

echo "========== Flushing Python Libraries =========="
# Flush Python Libraries
pip uninstall -y -r requirements.lock
echo "========== Finished Flushing Python Libraries =========="

cd -

echo "||====================||"
echo "||    COMPLETED 🎉    ||"
echo "||====================||"

exit 0
