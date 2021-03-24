SETTINGS="/Users/tillhainbach/Library/Containers/de.hainbach.SwiftUISparkleTestApp/Data/Library/Preferences/de.hainbach.SwiftUISparkleTestApp.plist"

echo "$SETTINGS"


hasLaunched=$(/usr/libexec/PlistBuddy \
    -c "Print SUHasLaunchedBefore" \
    "${SETTINGS}")

#open $SETTINGS
echo "has launched? $hasLaunched"

