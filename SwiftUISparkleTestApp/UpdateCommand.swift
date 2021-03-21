//
//  UpdateCommand.swift
//  SwiftUISparkleTestApp
//
//  Created by Till Hainbach on 09.03.21.
//

import SwiftUI

struct UpdateCommand: Commands {
  
    @ObservedObject var updater: SparkleAutoUpdater
    
    struct BodyView: View {

        @ObservedObject var updater: SparkleAutoUpdater
        
        var body: some View {
            Button("Check for updates") {
                print("Checking for updates")
                updater.checkForUpdates()
            }
            .disabled(!updater.canCheckForUpdates)
            .keyboardShortcut("U", modifiers: .command)
        }
    }

    var body: some Commands {
        CommandGroup(after: .appInfo) {
            BodyView(updater: updater)
        }
        
    }
}

