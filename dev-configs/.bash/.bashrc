#!/bin/sh

# System
## Ubuntu Version
alias uver="lsb_release -a"

## IP Adress
alias ip="grep nameserver /etc/resolv.conf | awk '{print \$2}'"

## bash_profile
alias cbshp="cat ~/Home/Development/github-profile/dev-configs/.bash/.bash_profile"
alias vbshp="vim ~/Home/Development/github-profile/dev-configs/.bash/.bash_profile"
alias rbshp="cp ~/Home/Development/github-profile/dev-configs/.bash/.bash_profile ~/"
alias sbshp="source ~/.bash_profile"

## bashrc
alias cbshr="cat ~/Home/Development/github-profile/dev-configs/.bash/.bashrc"
alias vbshr="vim ~/Home/Development/github-profile/dev-configs/.bash/.bashrc"
alias rbshr="cp ~/Home/Development/github-profile/dev-configs/.bash/.bashrc ~/"

## Package Update
alias aver="sudo apt -v"
alias aist="sudo apt install -y"
alias aprg="sudo apt remove --purge"
alias aarm="sudo apt auto-remove"
alias aud="sudo apt update && sudo apt full-upgrade -y && sudo apt auto-remove"
alias als="sudo apt list --installed"
alias alslck="sudo apt list --installed > ~/Home/Development/github-profile/dev-configs/lib/apt-installed-packages.lock"

## Mount Volume
alias dmnt="sudo mount -t drvfs"
alias dumnt="sudo umount -t drvfs"

## Change Directory
alias cdc="cd /mnt/c"
alias cdd="cd ~/Home/Development/github-profile"
alias cdo="cd ~/Home/Development/oss"
alias cdp="cd ~/Home/Development/personal"

## Open Directory
alias open="cmd.exe /c start"

## Copy to Clipboard
alias clp='clip.exe'

# File Handling
## Find
alias ffd="find . -type f -name"
alias dfd="find . -type d -name"

## Empty Directories
alias lsed="find . -type d -empty -print"
alias rmed="find . -type d -empty -delete"
alias rmeda="cd / && sudo find . -type d -empty -delete && cd -"

## desktop.ini
alias lsd="find . -type f -name "desktop.ini" -print"
alias rmd="find . -type f -name "desktop.ini" -prune -exec rm -rf {} +"
alias rmda="cd / && sudo find . -name desktop.ini -type f -prune -exec rm -rf {} + && cd -"

## Python Cache
alias lsp="find . -type d -regextype posix-extended -regex '.*py.*cache.*' -print"
alias rmp="find . -type d -regextype posix-extended -regex '.*py.*cache.*' -prune -exec rm -rf {} +"
alias rmpa="cd / && sudo find . -type d -regextype posix-extended -regex '.*py.*cache.*' -prune -exec rm -rf {} + && cd -"

## Temporary Files
alias lst="find . -type d -regextype posix-extended -regex '[Tt]e?mp' -print"
alias rmt="find . -type d -regextype posix-extended -regex '[Tt]e?mp' -delete"
alias rmta="cd / && sudo find . -type d -regextype posix-extended -regex '[Tt]e?mp' -delete && cd -"

## File Cleaner
alias fcln="cd ~/Home/Development/personal/file-cleaners/ruby/ && rake run_file_cleaner && cd -"

## File Extension Converter
alias fec="cd ~/Home/Development/personal/file-extension-converters/ruby/ && rake run_file_extension_converter && cd -"

## iTunes File Delimiter Replacer
alias fdr="cd ~/Home/Development/personal/itunes-file-delimiter-replacers/ruby/ && rake run_itunes_file_delimiter_replacer && cd -"

## JSON Data Sorting
alias jss="cd ~/Home/Development/personal/json-data-sorters/ruby/ && rake run_json_data_sorter && cd -"

# Claude Code
alias cpcld="cp ~/Home/Development/personal/CLAUDE.md ~/Home/Development/github-profile/dev-configs/lib/Claude/CLAUDE.md"

# Versioning
## Git
# Resolved at call time (not at .bashrc load time) so gbrda/gbrrda work from
# any directory, in whichever repository the shell currently sits in.
git_default_branch() {
  git rev-parse --abbrev-ref origin/HEAD 2>/dev/null | cut -f2- -d/
}
git_default_remote_branch() {
  git rev-parse --abbrev-ref origin/HEAD 2>/dev/null
}
alias gver="git -v"
alias gini="git init"
alias gcf="git config"
alias gcfl="git config --local"
alias gcfg="git config --global"
alias gcflls="git config --list --local"
alias gcfgls="git config --global --list"
alias gcfsys="git config --system"
alias gr="git remote"
alias grad="git remote add"
alias grrm="git remote remove"
alias grrn="git remote rename"
alias grurl="git remote url"
alias grstu="git remote set-head upstream --auto"
alias gref="git rev-parse --abbrev-ref HEAD"
alias grefo="git rev-parse --abbrev-ref origin/HEAD"
alias grefu="git rev-parse --abbrev-ref upstream/HEAD"
alias gcln="git clone"
alias gclns="git clone --recurse-submodules"
alias gft="git fetch"
alias gpl="git pull"
alias gbr="git branch"
alias gbrc="git branch --show-current"
alias gbrm="git branch -m"
alias gbrr="git branch -r"
alias gbrd="git branch -D"
alias gbrrd="git branch -rD"
alias gbrds="git branch | grep hayat01sh1da | xargs git branch -D"
alias gbrrds="git branch -r | grep hayat01sh1da | xargs git branch -rD"
gbrda() {
  local default_branch=$(git_default_branch)
  if [ -z "$default_branch" ]; then
    echo 'gbrda: cannot determine the default branch (not in a git repository, or origin/HEAD is unset: run `git remote set-head origin --auto`).' >&2
    return 1
  fi
  git branch | sed 's/^[[:space:]]*//' | grep -Ev "$default_branch" | xargs -r -n1 git branch -D
}
gbrrda() {
  local default_remote_branch=$(git_default_remote_branch)
  if [ -z "$default_remote_branch" ]; then
    echo 'gbrrda: cannot determine the default remote branch (not in a git repository, or origin/HEAD is unset: run `git remote set-head origin --auto`).' >&2
    return 1
  fi
  git branch -r | sed 's/^[[:space:]]*//' | grep -v ^origin/HEAD | grep -Ev "$default_remote_branch" | xargs -r -n1 git branch -rD
}
alias gver="git -v"
alias gini="git init"
alias gsw="git switch"
alias gswc="git switch -c"
alias gtg="git tag"
alias gdf="git diff"
alias gst="git status"
alias gad="git add"
alias gada="git add -A"
alias gcm="git commit"
alias gcmm="git commit -m"
alias gcmam="git commit -am"
alias gcma="git commit --amend"
alias grv="git revert"
alias gchp="git cherry-pick"
alias gsts="git stash"
alias gstsp="git stash pop"
alias gstsc="git stash clear"
alias grss="git reset --soft"
alias grssh="git reset --soft HEAD^"
alias grsh="git reset --hard"
alias grshh="git reset --hard HEAD^"
alias glg="git log"
alias glgo="git log --oneline"
alias grst="git restore"
alias grsts="git restore --staged"
alias gps="git push origin"
alias gpsf="git push origin -f"
alias gpsu="git push origin -u"
alias gmrg="git merge"
alias grb="git rebase"
alias grbi="git rebase -i"
alias grbc="git rebase --continue"
alias gig="git update-index --assume-unchanged"
alias guig="git update-index --no-assume-unchanged"
alias gigls="git ls-files -v"
alias gsad="git submodule add"
alias gsst="git submodule status"
alias gsud="git submodule update --remote --merge"
alias gspl="git pull --recurse-submodules"
alias gsaud="git config --global submodule.recurse true"
alias gprn="git prune"
alias cact="echo '$GITHUB_ACCESS_TOKEN' | clip.exe && echo 'GITHUB_ACCESS_TOKEN copied to clipboard'"
alias crsa="echo '$RSA_PASSWORD' | clip.exe && echo 'RSA password copied to clipboard'"

## PR Title Printer
# Ref. https://github.com/hayat01sh1da/spreen-pr
alias b2p="pr-title"

## Repository Flushing and Update
alias flsh="bash ~/Home/Development/github-profile/dev-configs/scripts/flush.sh"
alias sup="bash ~/Home/Development/github-profile/dev-configs/scripts/setup.sh"
alias fsup="bash ~/Home/Development/github-profile/dev-configs/scripts/flush.sh && bash ~/Home/Development/github-profile/dev-configs/scripts/setup.sh"
alias clno="bash ~/Home/Development/github-profile/dev-configs/scripts/clone_oss_repos.sh"
alias clnp="bash ~/Home/Development/github-profile/dev-configs/scripts/clone_personal_repos.sh"
alias rclno="cp ~/Home/Development/github-profile/dev-configs/scripts/clone_oss_repos.sh ~/Home/Development/oss/"
alias rclnp="cp ~/Home/Development/github-profile/dev-configs/scripts/clone_personal_repos.sh ~/Home/Development/personal/"
alias rfudo="cp ~/Home/Development/github-profile/dev-configs/scripts/flush_and_update_oss_repos.sh ~/Home/Development/oss/"
alias rfudp="cp ~/Home/Development/github-profile/dev-configs/scripts/flush_and_update_personal_repos.sh ~/Home/Development/personal/"
alias fudp="bash ~/Home/Development/github-profile/dev-configs/scripts/flush_and_update_personal_repos.sh"
alias fudo="bash ~/Home/Development/github-profile/dev-configs/scripts/flush_and_update_oss_repos.sh"
alias rudpd="cp ~/Home/Development/github-profile/dev-configs/scripts/update_package_dependencies.sh ~/Home/Development/personal/"
alias fuda="
  bash ~/Home/Development/github-profile/dev-configs/scripts/flush_and_update_personal_repos.sh &&
  bash ~/Home/Development/github-profile/dev-configs/scripts/flush_and_update_oss_repos.sh
"
alias udpd="bash ~/Home/Development/github-profile/dev-configs/scripts/update_package_dependencies.sh"

# Ruby
alias rbver="ruby -v"
alias whr="which ruby"

## rbenv
alias rbesup="git clone git@github.com:rbenv/rbenv.git ~/.rbenv && cd ~/.rbenv/plugins/ruby-build && git clone git@github.com:rbenv/ruby-build.git . && cd -"
alias rbever="rbenv -v"
alias rbeist="rbenv install"
alias rbeistls="rbenv install --list"
alias rbeuist="rbenv uninstall"
alias rbevers="rbenv versions"
alias rbelcl="rbenv local"
alias rbeglb="rbenv global"

## Gem
alias gmver="gem -v"
alias gmls="gem list"
alias gmist="gem install"
alias gmistl="gem install --local"
alias gmuist="gem uninstall"
alias gmprg="gem uninstall -I -a -x --user-install --force"
alias gmud="gem update"
alias gmclu="gem cleanup"
alias gmclua="gem cleanup --all"
alias gmsrch="gem search -r"
alias gmsgi="gem signin"
alias gmsgo="gem signout"
alias gmbld="gem build"
alias gmps="gem push"
alias gmynk="gem yank"

## Bundle
alias bver="bundle -v"
alias bini="bundle init"
alias bist="bundle install"
alias bud="bundle update --all"
alias blck="bundle lock --add-checksums"
alias bexe="bundle exec"

## Static Code Analysis
alias rcp="rubocop"
alias rcpver="rubocop -v"
alias rcpa="rubocop -a"
alias rcpalg="rubocop -a > rubocop.log"
alias rcpal="rubocop -A"
alias rcpallg="rubocop -A > rubocop.log"
alias rcptd="rubocop --auto-gen-config"
alias rcprtd="rubocop --regenerate-todo"

## Typechecking
alias rbsver="rbs -v"
alias rbscini="rbs collection init"
alias rbscist="rbs collection install"
alias rbscud="rbs collection update"
alias rbsi="rbs-inline"
alias rbsiver="rbs-inline -v"
alias rbsiout="rbs-inline --output sig/generated/ ."
alias stver="steep -v"
alias stch="steep check"
alias stchlg="steep check > steep.log"

## Rails
alias rver="rails -v"
alias rc="rails c"
alias rt="rails -T"
alias rrt="rails routes"
alias rdsup="rails db:setup"
alias rdc="rails db:create"
alias rdm="rails db:migrate"
alias rdmr="rails db:migrate:reset"
alias rds="rails db:seed"
alias rdr="rails db:drop"
alias rtst="rails test"
alias rcrde="rails credentials:edit"
alias raud="rails app:update"

# Python
alias pyver="python -v"
alias whp="which python"
alias pybld="python -m build"

# twine
alias twver="twine -v"
alias twchd="twine check dist/*"
alias twupld="twine upload dist/*"

## pyenv
alias pyesup="git clone git@github.com:pyenv/pyenv.git ~/.pyenv && cd ~/.pyenv/plugins/python-build && bash install.sh && cd -"
alias pyever="pyenv -v"
alias pyeist="pyenv install"
alias pyeistls="pyenv install --list"
alias pyeuist="pyenv uninstall"
alias pyevers="pyenv versions"
alias pyelcl="pyenv local"
alias pyeglb="pyenv global"

## pip install
alias piver="pip --version"
alias pist="pip install"
alias pistu="pip install -y --upgrade"
alias pistr="pip install -r requirements.txt"
alias pistru="pip install -r requirements.txt --upgrade"
alias puist="pip uninstall -y"
alias puistr="pip uninstall -y -r requirements.lock"
alias pfrz="pip freeze"
alias pfrzlck="pip freeze > requirements.lock"
alias pls="pip list"
alias psup="
  pip install --upgrade pip
  pip install -r ~/requirements.txt --upgrade
  pip freeze > ~/requirements.lock
"

## pytest
alias ptst="pytest"
alias ptst="pytest -v"
alias aflk="autoflake8 --in-place --remove-duplicate-keys --remove-unused-variables --recursive ."
alias aflkver="autoflake8 --version"
alias apep="autopep8 --in-place --aggressive --aggressive --recursive ."
alias apepver="autopep8 --version"

# Jupyter notebook
alias jn="jupyter notebook"

# JavaScript
alias ndver="node -v"

## ndenv
alias ndesup="git clone git@github.com:riywo/ndenv.git ~/.ndenv && cd ~/.ndenv/plugins/node-build && git clone git@github.com:riywo/node-build.git . && cd -"
alias ndever="ndenv -v"
alias ndeist="ndenv install"
alias ndeistls="ndenv install --list"
alias ndeuist="ndenv uninstall"
alias ndevers="ndenv versions"
alias ndelcl="ndenv local"
alias ndeglb="ndenv global"

## npm
alias npver="npm -v"
alias npist="npm install"
alias npistg="npm install -g"
alias npud="npm update"
alias npls="npm list"

## pnpm
alias pnpver="pnpm -v"
alias pnpist="pnpm install"
alias pnpud="pnpm update"
alias pnpls="pnpm list"

# Docker
## Docker itself
alias dver="docker -v"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"
alias dprn="docker system prune"
alias drmi="docker rmi"
alias dvls="docker volume ls"
alias dvrm="docker volume rm"
alias dvprn="docker volume prune"

## docker-compose
alias dbld="docker-compose build"
alias dup="docker-compose up"
alias dupd="docker-compose up -d"
alias dlgs="docker-compose logs -f"
alias drst="docker-compose restart"
alias dstp="docker-compose stop"
alias ddwn="docker-compose down"
alias dexe="docker-compose exec"
alias dprg="docker-compose down --rmi all -v"

## docker-compose app
alias dbist="docker-compose exec -e BUNDLE_FROZEN=false app bundle install"
alias dbud="docker-compose exec -e BUNDLE_FROZEN=false app bundle update --all"
alias drbsh="docker-compose exec app bash"

## docker-compose DB
alias ddb="docker-compose exec db mysql -u root"

## Rails
alias drver="docker-compose exec app bin/rails -v"
alias drc="docker-compose exec app bin/rails c"
alias drt="docker-compose exec app bin/rails -T"
alias drrt="docker-compose exec app bin/rails routes"
alias drsup="docker-compose exec app bin/setup --skip-server"
alias drdsup="docker-compose exec app bin/rails db:setup"
alias drdc="docker-compose exec app bin/rails db:create"
alias drdm="docker-compose exec app bin/rails db:migrate"
alias drdmr="docker-compose exec app bin/rails db:migrate:reset"
alias drds="docker-compose exec app bin/rails db:seed"
alias drdr="docker-compose exec app bin/rails db:drop"
alias drtst="docker-compose exec app bin/rails test"
alias drcrde="docker-compose exec app bin/rails credentials:edit"
alias draud="docker-compose exec app bin/rails app:update"

## RSpec
alias drsp="docker-compose exec app bundle exec rspec"
alias drspver="docker-compose exec app bundle exec rspec -v"

## Rubocop
alias drcp="docker-compose exec app bundle exec rubocop"
alias drcpver="docker-compose exec app bundle exec rubocop -v"
alias drcpa="docker-compose exec app bundle exec rubocop -a"
alias drcpalg="docker-compose exec app bundle exec rubocop -a > rubocop.log"
alias drcpal="docker-compose exec app bundle exec rubocop -A"
alias drcpallg="docker-compose exec app bundle exec rubocop -A > rubocop.log"
alias drcptd="docker-compose exec app bundle exec rubocop --auto-gen-config"
alias drcprtd="docker-compose exec app bundle exec rubocop --regenerate-todo"

## RBS, RBS-Inline and Steep
alias drbscver="docker-compose exec app bundle exec rbs -v"
alias drbscini="docker-compose exec app bundle exec rbs collection init"
alias drbscist="docker-compose exec app bundle exec rbs collection install"
alias drbscud="docker-compose exec app bundle exec rbs collection update"
alias drbsi="docker-compose exec app bundle exec rbs-inline"
alias drbsiver="docker-compose exec app bundle exec rbs-inline -v"
alias drbsiout="docker-compose exec app bundle exec rbs-inline --output sig/generated/ ."
alias dstver="docker-compose exec app bundle exec steep -v"
alias dstch="docker-compose exec app bundle exec steep check"
alias dstchlg="docker-compose exec app bundle exec steep check > steep.log"

## pnpm
alias dpnpver="docker-compose exec app pnpm -v"
alias dpnpist="docker-compose exec app pnpm install"
alias dpnpud="docker-compose exec app pnpm update"
alias cpnpls="docker-compose exec app pnpm list"

# Webdriver
alias dlwd="
  wget https://storage.googleapis.com/chrome-for-testing-public/$WEBDRIVER_VERSION/linux64/chromedriver-linux64.zip -P ~/Home/Development/personal/web-scrapers/webdrivers &&
    cd ~/Home/Development/personal/web-scrapers/webdrivers &&
    unzip chromedriver-linux64.zip &&
    mv chromedriver-linux64/chromedriver chromedriver &&
    rm -rf chromedriver-linux64* &&
    cd -
"

# GitHub Wiki
# Ref. https://github.com/hayat01sh1da/spreen-wiki
spud() {
  local path="$1"
  local org="$2"
  local repo="$3"
  spreen update --path "$path" --org "$org" --repo "$repo"
}
spcnt() {
  local path="$1"
  spreen count-report --path "$path"
}
spexp() {
  local path="$1"
  spreen llm-export --path "$path"
}

# Others
alias chdn="echo '$HIDDEN_PASSWORD' | clip.exe && echo 'Hidden password copied to clipboard'"
