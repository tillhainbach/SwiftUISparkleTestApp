# SwiftUISparkleTestApp
Sample Project for using Sparkle and SwiftUI

Since I could not find a could step-by-step guide for setting up Sparkle within a SwiftUI-based macOS-App
I thought I'll publish some of my today's findings here in a sample repo.

My goal was to use SwiftUI for a macOS, with Sparkle as an AutoUpdater and use
github pages and github releases for the updating process.

## Setting up the Xcode project.

Open Xcode and select a "Create new Xcode-Project".

<img src="docs/images/xcode-new-project.png" width="500" >

Select "macOS -> App -> Next".

<img src="docs/images/xcode-select-mac-app.png" width="600" >

Enter your product name, team and bundle identifier and click next

<img src="docs/images/xcode-project-settings.png" width="600" >

Choose a location where you want to store your project. Select "Create git repo..." and click "next".

Go to the project settings:

   - "Signing & Capabilities" -> App Sandbox allow:
        - Incoming Connections
        - Outgoing Connections

 ## Sparkle 2.x Setup

For a sandboxed app you need Sparkle 2.x (currently in beta). Unfortunately, there are no prebuilt binaries available
so you have to build them yourself.

### Build Sparkle 2.x

From Sparkle's [readme](https://github.com/sparkle-project/Sparkle/tree/2.x) and [docs](https://sparkle-project.org/documentation/):

```sh
git clone https://github.com/sparkle-project/Sparkle

cd Sparkle

git checkout 2.x
git submodule update --init --recursive

make release
```

### Add Sparkle Framework to XCode project

Unpack ne resulting `Sparkle-2.0.0.tar.xz` archive and drag'n'drop
`Sparkle.framework` into your XCode project.
Make sure you have "Copy items if needed" selected.

Citing from [Sparkle-docs](https://sparkle-project.org/documentation/):

> - Link the Sparkle framework to your app target:
>   - Drag Sparkle.framework into the Frameworks folder of your Xcode project.
>   - Be sure to check the “Copy items into the destination group’s folder” box in the sheet that appears.
>   - Make sure the box is checked for your app’s target in the sheet’s Add to targets list.
> - Make sure the framework is copied into your app bundle:
>   - Click on your project in the Project Navigator.
>   - Click your target in the project editor.
>   - Click on the General tab.
>   - In Frameworks, Libraries, and Embedded Content section, change Sparkle.framework to Embed & Sign.

### Additional XPC-Services

Sandboxed apps need some [additional setup](https://sparkle-project.org/documentation/sandboxing/):

> In an extracted Sparkle-2.0.0.tar.xz distribution in the XPCServices/ directory you will notice:
> -org.sparkle-project.InstallerConnection.xpc
> - org.sparkle-project.InstallerLauncher.xpc
> - org.sparkle-project.InstallerStatus.xpc

Add them to your project:

> - Add the XPC Services to your app target:
>   - Drag the XPC Services you need into your Xcode project.
>   - Be sure to check the “Copy items into the destination group’s folder” box in the sheet that appears.
>   - Make sure the box is checked for your app’s target in the sheet’s Add to targets list
> - Make sure the XPC Services are properly copied in your app bundle:
>   - Click on your project in the Project Navigator.
>   - Click your target in the project editor.
>   - Click on the Build Phases tab.
>   - Remove the XPC Services in the Copy Bundle Resources phase if Xcode auto-added them there.
>   - Click + to add a new Copy Files Phase.
>   - Choose XPC Services as the Destination.
>   - Drag the XPC Services you added from Xcode’s project navigator to the new Copy Files Phase.

See additional note on [testing](https://sparkle-project.org/documentation/sandboxing/)


## Configure your App with Sparkle

You need to create EdDSA (ed25519) signatures.

> To prepare signing with EdDSA signatures:
> 1. First, run ./bin/generate_keys tool (from the Sparkle distribution root). This needs to be done only once. This tool will do two things:
>       - It will generate a private key and save it in your login Keychain on your Mac. You don’t need to do anything with it, but don’t lose access to your Mac’s Keychain. If you lose it, you may not be able to issue any new updates!
>       - It will print your public key to embed into applications. Copy that key (it’s a base64-encoded string). You can run ./bin/generate_keys again to see your public key at any time.
> 2. Add your public key to your app’s `Info.plist` as a `SUPublicEDKey property.

Additionally, add `SUFeedURL` to `Info.plist` and enter the url to your app's
`appcast.xml`. If you want to use github pages with github releases, enter
something like:

```xml
<key>SUFeedURL</key>
<string>https://GithubUserName.github.io/YourRepoName/appcast.xml</string>

```

## Add SPUUpdater to SwiftUI

In your project create a new Swift file `AutoUpdater.swift` (or something else)
and add:

```swift
// AutoUpdater.swift


import Sparkle
import os

class AutoUpdater: NSObject {

    // Using the SPUStandardUserDriver
    let userDriver: SPUUserDriver = SPUStandardUserDriver(hostBundle: Bundle.main, delegate: nil)

    let updater: SPUUpdater?


    override init() {

        // Create SPUUpdater instance and hook it up to Bundle.main
        // and userDriver
        self.updater = SPUUpdater(
            hostBundle: Bundle.main, applicationBundle: Bundle.main, userDriver: userDriver, delegate: nil)
        do {
            try self.updater?.start()
        } catch {
            Logger().error("Failed to SPUUpdater: \(error)")
        }
    }


    func checkForUpdates() {
        guard let updater = updater else {
            Logger().error("updater was nil")
            return
        }
        Logger().info("Checking for updates at \(updater.feedURL)")
        updater.checkForUpdates()
    }

}

```

Add AutoUpdater to your app Scene struct and hook up a `check for updates`
command in the Menu Bar.

```Swift
// <ProductName>App.swift

...

@main
struct SwiftUISparkleTestAppApp: App {

    let updater = AutoUpdater()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands { // Add Check for updates after AppInfo
            CommandGroup(after: .appInfo) {
                Button("Check for updates") {
                    updater.checkUpdates()
                }
            }
        }
    }
}


```

In `ContentView.swift` add a frame to make the app more visible on screen


```SwiftUI
//ContentView.swift


struct ContentView: View {

    ...

    Text("Hello, App with Sparkle!")
        .padding()
        .frame(minWidth: 500, minHeight: 400)


```

You can now deploy the app:
- `Product -> Archive -> Distribute App -> Copy App -> Next`

Choose a location and launch the test app
(or drag it into Applications and then launch it from there).
Close the app and relaunch.
Your should be prompt by Sparkle whether Sparkle should check for updates
automatically. Agree by clicking the button or pressing `return`.

## Deploy with Github Releases and Sparkle

Now let's deploy an update for the app.

In `ContentView.swift` change the Text to:

```Swift
//ContentView.swift

...

    Text("Hello, App Version 2.0 Updated using Sparkle")

...

```

In Target Settings under the `General`-Tab:
- set `Version` to `2.0`
- set `Build` to 2


Deploy the app using the XCode Archive and then navigate to the directory.
Archive the app-bundle into a Zip-file and then generate the appcast.xml:

> Run generate_appcast tool from Sparkle’s distribution archive specifying the path to the folder with update archives. Allow it to access the Keychain if it asks for it (it’s needed to generate signatueres in the appcast).
>
> `$ ./bin/generate_appcast /path/to/your/updates_folder/`

Upload the Archive to Github releases and set the tag to `2.0`.
Modify the generated `appcast.xml` to point to your github release.

```xml
<!-- appcast.xml -->
...

<enclosure url="https://github.com/GithubUserName/YourRepoName/releases/download/ReleaseTag/AppArchive.zip" .../>

...
```

Copy/move the `appcast.xml` to your `gh-pages` branch or into the `docs`
directory (or in more general where you deploy your github page from...)


## Check if all works!

Launch your applications again. If not done automatically, you may check for
updates by clicking on "Check for Updates" in the MenuBar (under your app's
name). Fingers crossed, the Sparkle should detect that a need version is
available and ask whether you want to proceed updating. Agree to the update and,
hopefully, sparkle will ask you to `install and relaunch`. After the update,
the app should restart and you will see the updated text view.
