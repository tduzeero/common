#!/bin/sh

CURRENT_TAG=$(git describe --tags --abbrev=0)
CURRENT_TAG_NUMBER=$(echo $CURRENT_TAG | cut -d'v' -f 2)
COMMITS_FROM_CURRENT_TAG=$(git log $CURRENT_TAG..HEAD --oneline --reverse)

MAJOR=$(echo $CURRENT_TAG_NUMBER | cut -d'.' -f 1)
MINOR=$(echo $CURRENT_TAG_NUMBER | cut -d'.' -f 2)
PATCH=$(echo $CURRENT_TAG_NUMBER | cut -d'.' -f 3)

if [[ $CURRENT_TAG_NUMBER == "" ]]; then
  MAJOR=0;
  MINOR=0;
  PATCH=1;
fi

OLDIFS="$IFS"
IFS=$'\n'
for COMMIT in $COMMITS_FROM_CURRENT_TAG; do
  COMMIT_SHA=${COMMIT:0:7}
  DESCRIPTION=$(git show -s --format=%B $COMMIT_SHA)

  if [[ $DESCRIPTION == *"BREAKING CHANGE:"* || $COMMIT == *"!:"* ]]; then
    MAJOR=$(( $MAJOR+1 ));
    MINOR=0
    PATCH=0
    continue;
  fi

  if [[ $COMMIT == *"feat:"* ]]; then
    MINOR=$(( $MINOR+1 ));
    PATCH=0
    continue;
  fi

  PATCH=$(( $PATCH+1 ));

done
IFS="$OLDIFS"

echo "${MAJOR}.${MINOR}.${PATCH}"

# if [ -z "${1:-}" ]; then
#    COMMIT="HEAD"

#    # Test whether the working tree is dirty or not
#    if [ -z "$(git status -s)" ]; then
#      STATUS=""
#    else
#      STATUS=".SNAPSHOT.$(hostname -s)"
#    fi
# else
#    COMMIT="$1"
#    STATUS=""
# fi

# DESCRIBE=$(git describe --always --tags "$COMMIT")
# VERSION=$(echo "$DESCRIBE" | sed 's/\(.*\)-\(.*\)-g\(.*\)/\1+\2.\3/' | sed 's/v\(.*\)/\1/')
# BRANCH=$(git branch --contains "$COMMIT" | grep -e "^\*" | sed 's/^\* //')

# echo "export GIT_BRANCH=$BRANCH"

# EXACT_TAG=$(git describe --always --exact-match --tags "$COMMIT" 2> /dev/null || true)
# if [ ! -z "$EXACT_TAG" ] ; then
#   echo "export GIT_EXACT_TAG=${EXACT_TAG}"
#   echo "export GIT_SEMVER_FROM_TAG=$VERSION$STATUS"
# else
#   # We split up the prefix and suffix so that we don't accidentally
#   # give sed commands via the branch name
#   PREFIX="$(echo "$VERSION" | sed 's/\(.*\)\(\+.*\)/\1/')"
#   SUFFIX="$(echo "$VERSION" | sed 's/\(.*\)\(\+.*\)/\2/')"
#   if [ -z $(echo "$PREFIX" | grep "-") ]; then
#     echo "export GIT_SEMVER_FROM_TAG=$PREFIX-$BRANCH""$SUFFIX$STATUS"
#   else
#     echo "export GIT_SEMVER_FROM_TAG=$PREFIX.$BRANCH""$SUFFIX$STATUS"
#   fi
# fi