#!/usr/bin/env sh

PRODUCT_NAME=$1
INFO_PLIST=$1/Info.plist

version=$(/usr/libexec/Plistbuddy \
    -c "Print CFBundleShortVersionString" "${INFO_PLIST}")

build_number=$(/usr/libexec/PlistBuddy \
    -c "Print CFBundleVersion" "${INFO_PLIST}")

prelease_version="${version}-alpha${build_number}"

zsh $(dirname $(realpath $0))/set_version.sh $prelease_version $PRODUCT_NAME
