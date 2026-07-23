#!/bin/sh

repos=(
  botpress-accuracy-reporters
  coding-tests
  deep-learnings
  file-extension-converters
  github-wiki-organiser-action
  json-data-sorters
  natural-language-processing
  pr-title-from-branch-action
  readme-updaters
  spreen-clean
  spreen-pr
  spreen-tracks
  spreen-wiki
  spreen-wiki.wiki
  template-creators
  tutorials
  web-scrapers
)

cd ~/Home/Development/personal/

for repo in "${repos[@]}"
do
  echo "========== Cloning $repo =========="
  git clone --recurse-submodules git@github.com:hayat01sh1da/$repo.git
  echo "========== Finished Cloning $repo =========="
done

cd -

echo "||====================||"
echo "||    COMPLETED 🎉    ||"
echo "||====================||"

exit 0
