#!/bin/bash

branch=$(git rev-parse --abbrev-ref HEAD)

if [ "$branch" != "default" ] ; then
  echo "The automerge script is only intended for use on the 'default' branch." >&2
  exit 1
fi

if [ -z "$GITHUB_TOKEN" ] ; then
  echo "The automerge script requires that the GITHUB_TOKEN environment variable be defined." >&2
fi

# Look up the remote origin, and alter it to use https with oauth.
origin=$(git config --get remote.origin.url | sed -e 's#git@github.com:#https://github.com/#')
origin=$(echo $origin | sed -e "s#https://github.com#https://$GITHUB_TOKEN:x-oauth-basic@github.com#")

git fetch $origin | sed -e "s#$GITHUB_TOKEN#[REDACTED]#g"

# Commits on the 'default' branch not yet on master in reverse order (oldest first),
# ignoring any commit that modifies only files in .circleci
commits=$(git log master..HEAD --pretty=format:"%h" -- . ':!.circleci' | sed '1!G;h;$!d')

# If nothing has changed, bail without doing anything.
if [ -z "$commits" ] ; then
  echo "Nothing to merge"
  echo "https://i.kym-cdn.com/photos/images/newsfeed/001/240/075/90f.png"
  exit 0
fi

echo ":::::::::: Auto-merging to master ::::::::::"

set -ex

git checkout master
for commit in $commits ; do
  git cherry-pick $commit
done
git checkout -
git rebase master

set +ex

git push -u $origin master | sed -e "s#$GITHUB_TOKEN#[REDACTED]#g"
git push -u $origin default | sed -e "s#$GITHUB_TOKEN#[REDACTED]#g"
