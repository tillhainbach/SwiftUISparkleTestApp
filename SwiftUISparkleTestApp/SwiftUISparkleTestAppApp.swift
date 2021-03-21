//
//  SwiftUISparkleTestAppApp.swift
//  SwiftUISparkleTestApp
//
//  Created by Till Hainbach on 03.03.21.
//

import SwiftUI

@main
struct SwiftUISparkleTestAppApp: App {
    
    @StateObject var updater: SparkleAutoUpdater = SparkleAutoUpdater()

    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            UpdateCommand(updater: updater)
        }
    }
}
