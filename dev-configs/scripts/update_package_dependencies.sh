#!/usr/bin/env bash

python_apps=(
  botpress-accuracy-reporters/python
  coding-tests/python
  deep-learnings
  file-extension-converters/python
  json-data-sorters/python
  natural-language-processing
  spreen-clean/PyPI
  spreen-pr/PyPI
  spreen-readme/PyPI
  spreen-tracks/PyPI
  spreen-wiki/PyPI
  template-creators/python
  tutorials/python
  web-scrapers
)

ruby_apps=(
  botpress-accuracy-reporters/ruby
  coding-tests/ruby
  file-extension-converters/ruby
  json-data-sorters/ruby
  spreen-readme/ruby
  spreen-clean/RubyGem
  spreen-pr/RubyGem
  spreen-tracks/RubyGem
  spreen-wiki/RubyGem
  template-creators/ruby
)

js_apps=(
  coding-tests/javascript
  tutorials/javascript
  tutorials/reactjs
  tutorials/ruby-on-rails/perfect-ruby-on-rails
  tutorials/typescript
)

rails_apps=(
  botpress-accuracy-reporters/ruby-on-rails
  tutorials/ruby-on-rails/e-navigator
  tutorials/ruby-on-rails/perfect-ruby-on-rails
  tutorials/ruby-on-rails/restful-api
)

# Mirror the updated versions in requirements.lock back to requirements.txt,
# as the Python - Daily Dependencies Update workflows do.
mirror_requirements() {
  python <<'PY'
import re
from importlib.metadata import version
with open('requirements.txt') as f:
    lines = f.read().splitlines()
with open('requirements.txt', 'w') as f:
    for line in lines:
        m = re.match(r'([A-Za-z0-9._-]+)==\S+$', line.strip())
        f.write(f'{m.group(1)}=={version(m.group(1))}\n' if m else line + '\n')
PY
}

# Mirror the updated gem versions in Gemfile.lock back to the Gemfile, as the
# Ruby / Ruby on Rails - Daily Dependencies Update workflows do.
mirror_gemfile() {
  ruby <<'RUBY'
versions = File.read('Gemfile.lock').scan(/^    (\S+) \((\d+(?:\.\d+)*)\)$/).to_h
gemfile = File.read('Gemfile').gsub(/^(\s*gem '([^']+)', )'~> [^']+'/) do
  versions[$2] ? "#{$1}'~> #{versions[$2]}'" : $~[0]
end
File.write('Gemfile', gemfile)
RUBY
}

# Mirror the on-disk versions into the Environment section of the app's READMEs
# (and the description field of its package.json), as the daily workflows do.
# Rather than reimplement the rules, this runs the very script those workflows
# run, so the local and CI results cannot drift apart; only its mirroring side
# effect is wanted here, so the report it prints on stdout is discarded.
#
#     mirror_readmes <repo>/<app> <ecosystem> <lockfile> <manifest>
#
# The app path is split into the repository (its first segment, which is where
# .github/scripts and the git history live) and the path of the app within it,
# which may be empty when the app is the repository itself.
mirror_readmes() {
  local app=$1 ecosystem=$2 lockfile=$3 manifest=$4
  local repo=${app%%/*} within=${app#*/}
  [ "$within" = "$app" ] && within=''
  local report="$repo/.github/scripts/dependency_report.sh"
  if [ ! -f "$report" ]; then
    echo "No dependency report script in $repo; skipping README mirroring." >&2
    return
  fi
  ( cd "$repo" && bash .github/scripts/dependency_report.sh \
      "$ecosystem" "${within:+$within/}$lockfile" "${within:+$within/}$manifest" Dependencies >/dev/null )
}

cd ~/Home/Development/personal/ || { echo "Failed to cd to personal directory; aborting." >&2; exit 1; }
base_dir=$(pwd)

# The mirroring above reads package.json through jq, exactly as the workflows do
# on runners that ship it. Without jq the pnpm version cannot be read and the
# JavaScript READMEs are left alone, so say so once rather than failing quietly.
if ! command -v jq > /dev/null; then
  echo "jq is not installed; README mirroring will be skipped for the JavaScript apps." >&2
fi

# The daily workflows upgrade the package managers on every run because each
# runner starts fresh; locally once per invocation is enough.
echo "========== Updating pip =========="
pip install --upgrade pip
echo "========== Updating Bundler =========="
gem update --system
gem install bundler

for python_app in "${python_apps[@]}"
do
  echo "========== Updating PyPI Library Dependencies in $python_app =========="
  # Guard the cd: the uninstall/overwrite steps below must only ever run
  # inside the intended app directory, never in an unexpected one.
  cd "$python_app" || { echo "Skipping $python_app: cannot enter directory." >&2; continue; }
    pip uninstall -y -r ~/requirements.lock
    sed -E 's/==.*//' requirements.txt | xargs pip install --upgrade
    pip freeze > requirements.lock
    pip --version | awk '{print "pip==" $2}' >> requirements.lock
    mirror_requirements
  cd "$base_dir" || exit 1
  mirror_readmes "$python_app" pip requirements.lock requirements.txt
  echo "========== Finished Updating PyPI Library Dependencies in $python_app =========="
done

pip install -r ~/requirements.txt --upgrade

for ruby_app in "${ruby_apps[@]}"
do
  echo "========== Updating RubyGems Dependencies in $ruby_app =========="
  cd "$ruby_app" || { echo "Skipping $ruby_app: cannot enter directory." >&2; continue; }
    BUNDLE_FROZEN=false bundle update --bundler
    BUNDLE_FROZEN=false bundle update --all
    mirror_gemfile
  cd "$base_dir" || exit 1
  mirror_readmes "$ruby_app" gem Gemfile.lock Gemfile
  echo "========== Finished Updating RubyGems Dependencies in $ruby_app =========="
done

for js_app in "${js_apps[@]}"
do
  echo "========== Updating npm Package Dependencies in $js_app =========="
  # Guard the cd: rm -rf below must never run in an unexpected directory.
  cd "$js_app" || { echo "Skipping $js_app: cannot enter directory." >&2; continue; }
    rm -rf node_modules
    corepack use pnpm@latest
    pnpm install
    pnpm update
  cd "$base_dir" || exit 1
  mirror_readmes "$js_app" pnpm pnpm-lock.yaml package.json
  echo "========== Finished Updating npm Package Dependencies in $js_app =========="
done

for rails_app in "${rails_apps[@]}"
do
  echo "========== Updating RubyGems Dependencies in $rails_app =========="
  cd "$rails_app" || { echo "Skipping $rails_app: cannot enter directory." >&2; continue; }
    docker-compose build
    docker-compose up -d
    docker-compose exec app gem update --system
    docker-compose exec app gem install bundler
    docker-compose exec -e BUNDLE_FROZEN=false app bundle update --bundler
    docker-compose exec -e BUNDLE_FROZEN=false app bundle update --all
    docker-compose exec app bundle exec rbs collection update
    mirror_gemfile
  cd "$base_dir" || exit 1
  mirror_readmes "$rails_app" gem Gemfile.lock Gemfile
  echo "========== Finished Updating RubyGems Dependencies in $rails_app =========="
done

cd -

echo "||====================||"
echo "||    COMPLETED 🎉    ||"
echo "||====================||"

exit 0
