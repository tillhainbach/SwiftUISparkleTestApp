#!/usr/bin/env sh

NEW_BUILD_NUMBER=$1
PRODUCT_NAME=$2
INFO_PLIST=$PRODUCT_NAME/Info.plist

echo "----"
echo "Info.plist for target: ${INFO_PLIST}"

/usr/libexec/Plistbuddy -c "Set :CFBundleVersion ${NEW_BUILD_NUMBER}" "${INFO_PLIST}"

echo "Build number set to $NEW_BUILD_NUMBER"
echo "----"
exit 0
