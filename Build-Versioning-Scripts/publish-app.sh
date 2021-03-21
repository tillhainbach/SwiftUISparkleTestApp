#!/bin/sh

#  publish-app.sh
#  SwiftUISparkleTestApp
#
#  Created by Till Hainbach on 10.03.21.
#

function header {
    echo "\n$(tput bold)*** $1 ***$(tput sgr0)\n"
}
#set -e
set -x
header "Uploading Release to Github"

PROJECT_NAME=$1

BUILD_NUMBER=$(/usr/libexec/PlistBuddy \
    -c "Print CFBundleVersion" "${PROJECT_NAME}/Info.plist")
VERSION=$(/usr/libexec/PlistBuddy \
    -c "Print CFBundleShortVersionString" \
    "${PROJECT_NAME}/Info.plist")

gh release create \
    "v$VERSION" Product/$PROJECT_NAME.v$VERSION.b$BUILD_NUMBER.zip \
    -t "v$VERSION" -n ""
   

header "Retrieving Release Asset Id"
URL=$(zsh $(dirname $(realpath $0))/get_release_asset_url.sh $PROJECT_NAME "v$VERSION")
THE_URL="${URL//\//\\/}"

header "Generating Appcast for Release"
generate_appcast Product
#echo "${THE_URL}"
perl -pi -e "s/url=.+? /url=\"${THE_URL}\" /g" Product/appcast.xml

set +e
header "Publishing Appcast to gh-pages"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

git stash
git checkout gh-pages
cp Product/appcast.xml ./appcast.xml
git add appcast.xml

git commit -m "Update appcast for new release"

git push --force origin gh-pages
git checkout $CURRENT_BRANCH
git stash pop


