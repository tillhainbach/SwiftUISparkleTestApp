#!/usr/bin/env sh
set -e

PROJECT_NAME=$1
PROJECT_DIR=$PROJECT_NAME
INFOPLIST_FILE="Info.plist"

CFBundleVersion=$(/usr/libexec/PlistBuddy \
    -c "Print CFBundleVersion" "${PROJECT_DIR}/${INFOPLIST_FILE}")
CFBundleShortVersionString=$(/usr/libexec/PlistBuddy \
    -c "Print CFBundleShortVersionString" \
    "${PROJECT_DIR}/${INFOPLIST_FILE}")

ARCHIVE_NAME="$PROJECT_NAME.v$CFBundleShortVersionString.b$CFBundleVersion.zip"

pushd Product/
zip -r "$ARCHIVE_NAME" $PROJECT_NAME.app
popd
