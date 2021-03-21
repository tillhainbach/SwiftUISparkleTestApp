#!/usr/bin/env sh

# To make executable, use: chmod u+x Build-Versioning-Scripts/Increment_Build_Number.sh
# to locate your target's info.plist use
PRODUCT_SETTINGS_PATH=$1/Info.plist

echo "----"
echo "Info.plist for target: ${PRODUCT_SETTINGS_PATH}"

buildNum=$(/usr/libexec/Plistbuddy -c "Print CFBundleVersion" "${PRODUCT_SETTINGS_PATH}")
echo "Current build #: $buildNum"

if [ -z "$buildNum" ]; then
echo "No build number found in $PRODUCT_SETTINGS_PATH"
exit 2
fi

buildNum=$(expr $buildNum + 1)
echo "Build # incremented to: $buildNum"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNum" "$PRODUCT_SETTINGS_PATH"
echo "----"
exit 0
