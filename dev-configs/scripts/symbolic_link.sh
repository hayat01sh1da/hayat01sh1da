#!/bin/sh

cd ~/ || { echo "Failed to cd to home directory; aborting." >&2; exit 1; }

links=('Desktop' 'Downloads' 'Videos' 'Music' 'Pictures' 'Documents')
user='binlh'

echo "========== Creating Symbolic Links for Windows User Directories =========="
for link in "${links[@]}"
do
  # Only create the link if a file/dir/link of that name does not already exist.
  if [ ! -e ~/"$link" ]; then
    ln -s "/mnt/c/Users/$user/$link" ~/
  fi
done

if [ ! -e ~/Home ]; then
  ln -s "/mnt/c/Users/$user/" ~/Home
fi
echo "========== Finished Creating Symbolic Links for Windows User Directories =========="

cd -

echo "||====================||"
echo "||    COMPLETED 🎉    ||"
echo "||====================||"

exit 0
