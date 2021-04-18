# SwiftUISparkleTestApp

Sample Project for using Sparkle in a SwiftUI-lifecycle app. It includes a
wrapper class around SPUUpdater which can be interacted from within SwiftUI.

## How it works

Since the Sparkle framework originates from the `delegate`-era, we need to create a bridge between Sparkles-delegates+callbacks and SwiftUI's `Binding`-toSomething
philosophy. This is where the wrapper class `SparkleAutoUpdater` comes into play.
It essentially provides a publisher for `SPUUpdater.canCheckForUpdates` to which any SwiftUI View can subscribe. In this sample repo, that's the case for the `UpdateCommand`-View. The wrapper class also subscribes to the `.applicationDidFinishLaunching`-Notification and will start the `SPUUpdater` after application launch.

There is also a simple helpers class that you can use, if you are planning to update from releases within a private repo. The class will handle token validation and stores the token into the macOS keychain.

## Setup

You can find a detailed step-by-step guide [here](./docs/step-by-step.md).

## Questions?

You can open an [issue](https://github.com/tillhainbach/SwiftUISparkleTestApp/issues) and I'll try to help.

## References

[Sparkle] (https://sparkle-project.org)

## Licencse

For Sparkle stuff (in Framework) see their [license](https://github.com/sparkle-project/Sparkle/blob/master/LICENSE)

My stuff is licensed under [The Unlicense](./LICENSE).
