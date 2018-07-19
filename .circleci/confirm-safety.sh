#!/bin/bash

# Exit if we are not running on Circle CI
if [ -z "$CIRCLECI" ] ; then
  exit 0
fi

if [ -z "$CIRCLE_PULL_REQUEST" ] ; then
  echo "No CIRCLE_PULL_REQUEST defined"
  exit 1
fi

// CIRCLE_PULL_REQUEST=https://github.com/greg-1-anderson/WordPress/pull/6
PR_NUMBER=$(echo CIRCLE_PULL_REQUEST | sed -e 's#.*/pull/##')

echo curl https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls/$CIRCLE_PR_NUMBER
curl https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls/$CIRCLE_PR_NUMBER

base=$(curl https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls/$CIRCLE_PR_NUMBER 2>/dev/null | jq .base.ref)

echo "The base branch is $base"
