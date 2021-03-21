//
//  UpdateCommand.swift
//  SwiftUISparkleTestApp
//
//  Created by Till Hainbach on 09.03.21.
//

import SwiftUI


struct UpdateCommand: Commands {
  
    @ObservedObject var userDriver: SPUStandardObservableUserDriver
    
    struct BodyView: View {
        let updater: SparkleAutoUpdater?
        
        init(userDriver: SPUStandardObservableUserDriver) {
            self.updater = SparkleAutoUpdater(userDriver: userDriver)
            self.userDriver = userDriver
        }
        @ObservedObject var userDriver: SPUStandardObservableUserDriver
        
        var body: some View {
            Button("Check for updates") {
                guard let updater = self.updater else {
                    print("Updater not available!")
                    return
                }
                print("Checking for updates")
                updater.checkForUpdates()
            }
            .disabled(!userDriver.canCheckForUpdates)
            .keyboardShortcut("U", modifiers: .command)
        }
    }

    var body: some Commands {
        CommandGroup(after: .appInfo) {
            BodyView(userDriver: userDriver)
        }
        
    }
}

