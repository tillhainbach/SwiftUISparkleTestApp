#!/usr/bin/env sh

NEW_VERSION=$1
PRODUCT_NAME=$2
INFO_PLIST=$PRODUCT_NAME/Info.plist

echo "----"
echo "Info.plist for target: ${INFO_PLIST}"

/usr/libexec/Plistbuddy -c "Set :CFBundleShortVersionString ${NEW_VERSION}" "${INFO_PLIST}"

echo "Version set to $NEW_VERSION"
echo "----"
exit 0
