#!/bin/bash

# Exit if we are not running on Circle CI
if [ -z "$CIRCLECI" ] ; then
  exit 0
fi

curl https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls/$CIRCLE_PR_NUMBER

base=$(curl https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls/$CIRCLE_PR_NUMBER 2>/dev/null | jq .base.ref)

echo "The base branch is $base"
