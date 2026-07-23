#!/bin/sh

repos=(
  9cc
  activeagent
  dd-trace-rb
  ginza-rb
  irb
  layered-design-for-ruby-on-rails-applications
  lr-parser-101
  magazine-rubyist-net
  metaprogramming-challenges-in-ruby
  mmtk-ruby
  mruby
  mrubyc
  picoruby
  polished-ruby-programming
  rails
  rbi
  rbs
  rbs-inline
  reading-metaprogramming-ruby
  rubocop
  rubocop-factory-bot
  rubocop-minitest
  rubocop-rails
  rubocop-rspec
  rubocop-rspec-rails
  ruby
  rubygems
  rules-ruby
  sorbet
  steep
  support-ts-tapl
  tapioca
  typeprof
)

cd ~/Home/Development/oss/

for repo in "${repos[@]}"; do
  echo "========== Cloning $repo =========="
  git clone --recurse-submodules git@github.com:hayat01sh1da/$repo.git
  echo "========== Finished Cloning $repo =========="

  echo "========== Setting upstream for $repo =========="
  parent=$(curl -s "https://api.github.com/repos/hayat01sh1da/$repo" | grep -m 2 '"full_name"' | tail -1 | sed 's/.*"full_name": "\(.*\)".*/\1/')
  if [ -n "$parent" ] && [ "$parent" != "hayat01sh1da/$repo" ]; then
    git -C "$repo" remote add upstream "git@github.com:$parent.git"
    git -C "$repo" fetch upstream --no-recurse-submodules
    echo "========== Finished Setting upstream ($parent) for $repo =========="
  else
    echo "========== Could not resolve upstream for $repo; skipped =========="
  fi
done

cd -

echo "||====================||"
echo "||    COMPLETED 🎉    ||"
echo "||====================||"

exit 0
