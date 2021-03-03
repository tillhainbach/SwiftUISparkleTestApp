//
//  SwiftUISparkleTestAppApp.swift
//  SwiftUISparkleTestApp
//
//  Created by Till Hainbach on 03.03.21.
//

import SwiftUI
import Sparkle

@main
struct SwiftUISparkleTestAppApp: App {
    
    let updater = AutoUpdater()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Check for updates") {
                    updater.checkUpdates()
                    print("Checking for updates")
                }
            }
        }
    }
}

class AutoUpdater: NSObject {
    
    let userDriver: SPUUserDriver = SPUStandardUserDriver(hostBundle: Bundle.main, delegate: nil)
    
    let updater: SPUUpdater?
        
        
    override init() {
        self.updater = SPUUpdater(
            hostBundle: Bundle.main, applicationBundle: Bundle.main, userDriver: userDriver, delegate: nil)
        do {
            try self.updater?.start()
        } catch {
            fatalError("Updater start failed: \(error)")
        }
    }

    
    func checkUpdates() {
        guard let updater = updater else {
            print("Updater was Nil")
            return
        }
        print("\(updater.feedURL)")
        updater.checkForUpdates()
    }

}

