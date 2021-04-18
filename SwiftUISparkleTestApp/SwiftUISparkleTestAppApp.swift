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
    @StateObject var keychainServiceModel = KeychainServiceModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(updater)
                .environmentObject(keychainServiceModel)
        }
        .commands {
            UpdateCommand(updater: updater)
        }
    }
}
