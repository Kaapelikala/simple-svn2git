#!/bin/bash

SVNREPO=$1

WORKDIR=$(pwd)
GITDIR=$WORKDIR/gitDir
rm -rf $GITDIR
mkdir $GITDIR
cd $GITDIR
git init
echo "$SVNREPO to git $(date)" > README.md
echo "" > .gitignore
git add README.md
git add .gitignore
git commit -m "$SVNREPO to git."

i=0
for TAG in `svn ls $SVNREPO/tags/|sed 's;/;;g'|sort --version-sort`; do
  cd $GITDIR
  find . -maxdepth 1 ! -iname .git ! -iname README.md ! -iname .gitignore -exec rm -rf {} \;
  cd $WORKDIR
  svn checkout $SVNREPO/tags/$TAG gitDir
  cd $GITDIR
  rm -rf .svn
  git add .
  git commit -m $TAG
  git tag -a $TAG -m $TAG
  i=$((i+1))
done
cd $GITDIR
find . -maxdepth 1 ! -iname .git ! -iname README.md ! -iname .gitignore -exec rm -rf {} \;
cd $WORDIR
svn checkout $SVNREPO/trunk gitDir
cd $GITDIR
rm -rf .svn
git add .
git commit -m "Added current trunk"

echo "Now set remotes and force push to master."
