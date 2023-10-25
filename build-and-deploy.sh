#!/bin/bash
# 
# Script to pull latest vimwiki updates into contents directory, build hugo site, and deploy to kaimcbride.github.io
#
#

build_dir=~/Sites/hugo-ataraxia
cd $build_dir
pwd

# 1. Pull latest from wimwiki into content folder

echo "## Git Pull latest from vimwiki"
cd content
git pull

# 2. Rename index.md to _index.md in top level folders
echo "## Renaming index.md to _index.md in PARA directories"
[ -f projects/index.md ] && mv projects/index.md projects/_index.md
[ -f area/index.md ] && mv area/index.md area/_index.md
[ -f res/index.md ] && mv res/index.md res/_index.md
[ -f archive/index.md ] && mv archive/index.md archive/_index.md

cd ..

# 3. Build hugo site into public
# 4. Stop if hugo failed to build or had an error
echo "## Building hugo site with terminal template"
hugo -t terminal || exit $?

# 5. commit changes to public and push to kaimcbride.github.io
cd public
pwd
git add .
git status
echo -n "Proceed with commit and push ? (Y/n)"
read proceed

if [ $proceed == 'n' ];  then
    echo "Ok. Exiting..."
    exit 1
fi

echo "Ready to commit changes to kaimcbride.github.io"
echo -n "Commit Message: "
read commit_message
echo "Your commit message will be: $commit_message"

git commit -a  -m "$commit_message"
git push
cd ..


