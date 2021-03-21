#!/usr/bin/env sh

PROJECT_NAME=$1
PROJECT_DIR=$PROJECT_NAME
INFOPLIST_FILE="Info.plist"

CFBundleVersion=$(/usr/libexec/PlistBuddy \
    -c "Print CFBundleVersion" "${PROJECT_DIR}/${INFOPLIST_FILE}")
CFBundleShortVersionString=$(/usr/libexec/PlistBuddy \
    -c "Print CFBundleShortVersionString" \
    "${PROJECT_DIR}/${INFOPLIST_FILE}")

echo "----------"
echo "Creating release $CFBundleShortVersionString.$CFBundleVersion for $PROJECT_NAME\n"
rm -rf Archive/*
rm -rf Product/*

xcodebuild clean \
    -project $PROJECT_NAME.xcodeproj \
    -configuration Release \
    -alltargets

echo "\n\nArchiving $PROJECT_NAME.app\n"
xcodebuild archive \
    -project $PROJECT_NAME.xcodeproj \
    -scheme $PROJECT_NAME \
    -archivePath Archive/$PROJECT_NAME.xcarchive

xcodebuild \
    -exportArchive \
    -archivePath Archive/$PROJECT_NAME.xcarchive \
    -exportPath Product/ \
    -exportOptionsPlist exportOptions.plist

ARCHIVE_NAME="$PROJECT_NAME.v${CFBundleShortVersionString}.b${CFBundleVersion}.zip"


echo "\n\nCreating release zip-Archive...\n"
pushd Product/
zip -r "$ARCHIVE_NAME" $PROJECT_NAME.app
popd

echo "\n\nGenerating appcast...\n"
generate_appcast Product

URL="${GITHUB_URL}/${PROJECT_NAME}/releases/download/v${CFBundleShortVersionString}/${ARCHIVE_NAME}"
THE_URL="${URL//\//\\/}"
echo "${THE_URL}"
perl -pi -e "s/url=.+? /url=\"${THE_URL}\" /g" Product/appcast.xml
echo "----------"
