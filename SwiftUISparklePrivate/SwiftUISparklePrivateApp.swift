//
//  SwiftUISparklePrivateApp.swift
//  SwiftUISparklePrivate
//
//  Created by Till Hainbach on 10.03.21.
//

import SwiftUI

@main
struct SwiftUISparkleTestAppApp: App {
    
    @StateObject var userDriver: SPUStandardObservableUserDriver = SPUStandardObservableUserDriver(hostBundle: Bundle.main, delegate: nil)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            UpdateCommand(userDriver: userDriver)
        }
    }
}

