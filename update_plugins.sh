#!/bin/bash

oldstaged=($(git ls-files -m))
oldunstaged=($(git ls-files --others --exclude-standard))

echo "Updating core"
wp core update

git ls-files -m | \
while read i
do
  if [[ ! " ${oldstaged[@]} " =~ " ${i} " ]]; then
    if [[ ! " ${oldunstaged[@]} " =~ " ${i} " ]]; then
      git add $i
    else
      echo "skipping unstaged $i"
    fi
  else
    echo "skipping staged $i"
  fi
done

VERSION=$(wp core version)
git commit -m "WordPress Core update $VERSION"

echo "Updating plugins"
wp plugin update --all

git status | grep -oP 'wp-content/plugins/\K(.*?)/' | sort -t: -u -k1,1 | \
while read i
do
  git add "wp-content/plugins/$i" && git commit -m "Updated plugin: $i"
done
