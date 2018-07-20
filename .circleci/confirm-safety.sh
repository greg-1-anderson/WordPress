#!/bin/bash

# Exit if we are not running on Circle CI
if [ -z "$CIRCLECI" ] ; then
  exit 0
fi

if [ -z "$CIRCLE_PULL_REQUEST" ] ; then
  echo "No CIRCLE_PULL_REQUEST defined"
  exit 1
fi

# CIRCLE_PULL_REQUEST=https://github.com/greg-1-anderson/WordPress/pull/6
PR_NUMBER=$(echo $CIRCLE_PULL_REQUEST | sed -e 's#.*/pull/##')

echo curl https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls/$PR_NUMBER
# curl https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls/$PR_NUMBER

base=$(curl https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls/$PR_NUMBER 2>/dev/null | jq .base.ref)

echo "The base branch is $base"

if [ "$base" == '"default"' ] ; then
  echo "It is safe to merge this PR into the $base branch"
  exit 0
fi

if [ "$base" == '"master"' ] ; then
  echo "ERROR: merging this PR into the $base branch is not allowed. Change the base branch for the PR to merge into the \"default\" branch instead."
  exit 1
fi

echo "Merging probably okay, if you are merging one PR into another. Use caution; do not merge to the \"master\" branch."
