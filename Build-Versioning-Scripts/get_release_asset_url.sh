#!/bin/bash

#  get_release_asset_url.sh
#  SwiftUISparklePrivate
#
#  Created by Till Hainbach on 11.03.21.
#

set -e

DEBUG=false

REPO_NAME=$1
VERSION_TAG=$2
GITHUB_API='https://api.github.com'
END_POINT='repos'
CREDENTIALS=$(git credential-osxkeychain get << END
host=github.com
END
)
USER=$(echo "$CREDENTIALS" | grep username | cut -f2 -d "=")
TOKEN=$(echo "$CREDENTIALS" | grep password | cut -f2 -d "=")

if $DEBUG; then
    echo "Using $TOKEN for $USER"
fi



API_CALL_URL="$GITHUB_API/$END_POINT/$USER/$REPO_NAME/releases/tags/$VERSION_TAG"

if $DEBUG; then
    echo "Calling to $API_CALL_URL"
fi

response=$(curl -sH "Authorization: token $TOKEN" "$API_CALL_URL")
asset_url=$(echo $response \
    | grep -C3 "name.:.\+$REPO_NAME" \
    | grep -w url | sed -E 's/[ \t]*"url": "(.*)",/\1/g'
)

echo "$asset_url"
