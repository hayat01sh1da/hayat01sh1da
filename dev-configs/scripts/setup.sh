#!/bin/sh

cd ~/ || { echo "Failed to cd to home directory; aborting." >&2; exit 1; }

echo "========== Updating System Packages =========="
# Update System Packages
sudo apt update && sudo apt full-upgrade -y && sudo apt auto-remove -y && sudo apt clean
sudo apt list --installed > ~/Home/Development/github-profile/dev-configs/lib/apt/apt-installed-packages.lock
echo "========== Finished Updating System Packages =========="

# Flush and Update `.lang_env` Repositories
lang_envs=('ndenv' 'rbenv' 'pyenv')
langs=('node' 'ruby' 'python')

for i in "${!lang_envs[@]}";
do
  echo "========== Flushing and Updating ${lang_envs[$i]} =========="
  # Guard each cd: the branch -D commands below must only run inside the
  # intended repository, never in whatever directory we happened to be in.
  cd ".${lang_envs[$i]#*.}" || { echo "Skipping ${lang_envs[$i]}: directory not found." >&2; continue; }
  git branch | grep -v 'origin/HEAD' | xargs -n1 git branch -D
  git branch -r | sed 's/^[[:space:]]*//' | grep -v '^origin/HEAD' | grep -v '^upstream/HEAD' | grep -Ev '^upstream/(master|main)$' | xargs -n1 git branch -rD
  git submodule foreach 'git push origin --delete feature-branch || :'
  git rev-parse --abbrev-ref HEAD | xargs git pull origin

  cd "./plugins/${langs[$i]}-build/" || { echo "Skipping ${langs[$i]}-build: directory not found." >&2; cd ~/ || exit 1; continue; }
  git branch | grep -v 'origin/HEAD' | xargs -n1 git branch -D
  git branch -r | sed 's/^[[:space:]]*//' | grep -v '^origin/HEAD' | grep -v '^upstream/HEAD' | grep -Ev '^upstream/(master|main)$' | xargs -n1 git branch -rD
  git rev-parse --abbrev-ref HEAD | xargs git pull origin
  echo "========== Finished Flushing and Updating ${lang_envs[$i]} =========="
  cd ~/
done

# Update RubyGems via Gemfile and Bundler
echo "========== Updating RubyGems via Gemfile and Bundler =========="
gem update --system
gem install bundler
bundle update --bundler
bundle install
bundle lock --add-checksums
bundle update --all
cp ~/Gemfile ~/Home/Development/github-profile/dev-configs/lib/RubyGems/
cp ~/Gemfile.lock ~/Home/Development/github-profile/dev-configs/lib/RubyGems/
echo "========== Finished Updating RubyGems via Gemfile and Bundler =========="

# Update PyPI Libraries via pip and `requirements.txt`
echo "========== Updating PyPI Libraries via pip and 'requirements.txt' =========="
pip install --upgrade pip
pip install -r ~/requirements.txt --upgrade
pip freeze > ~/requirements.lock
cp ~/requirements.txt ~/Home/Development/github-profile/dev-configs/lib/PyPI/
cp ~/requirements.lock ~/Home/Development/github-profile/dev-configs/lib/PyPI/
echo "========== Finished Updating PyPI Libraries via pip and 'requirements.txt' =========="

# Update npm Packages via pnpm and `package.json`
echo "========== Updating npm Packages via pnpm and 'package.json' =========="
# npm >= 11.6 runs a globally installed package's lifecycle scripts only when
# they are allow-listed, and pnpm ships preinstall/postinstall hooks, so keep
# it listed. (The `pnpm` command itself comes from the package's `bin` field
# and is linked either way -- this flag is not what makes it appear.)
npm install -g --allow-scripts=pnpm pnpm
# ndenv exposes globally installed binaries only through shims it regenerates
# on demand, so a fresh `npm install -g` stays invisible until it rehashes.
# Note: rehash cannot create a shim whose name is already taken by a directory
# under `$NDENV_ROOT/shims/`, so keep PNPM_HOME out of the shims directory.
if command -v ndenv > /dev/null 2>&1; then
  ndenv rehash
fi

if command -v pnpm > /dev/null 2>&1; then
  pnpm update
  pnpm install
  pnpm update
  cp ~/package.json ~/Home/Development/github-profile/dev-configs/lib/npm/
  cp ~/pnpm-lock.yaml ~/Home/Development/github-profile/dev-configs/lib/npm/
  cp ~/pnpm-workspace.yaml ~/Home/Development/github-profile/dev-configs/lib/npm/
else
  echo "Skipping pnpm: not found on PATH after 'npm install -g pnpm'." >&2
fi
echo "========== Finished Updating npm Packages via pnpm and 'package.json' =========="

# Claude Code
echo "========== Updating CLAUDE.md =========="
cp ~/Home/Development/personal/CLAUDE.md ~/Home/Development/github-profile/dev-configs/lib/Claude/CLAUDE.md
echo "========== Finished Updating CLAUDE.md =========="

cd -

echo "||====================||"
echo "||    COMPLETED 🎉    ||"
echo "||====================||"

exit 0
