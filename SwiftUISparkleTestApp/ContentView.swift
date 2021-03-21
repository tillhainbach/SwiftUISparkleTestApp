//
//  ContentView.swift
//  SwiftUISparkleTestApp
//
//  Created by Till Hainbach on 03.03.21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var updater: SparkleAutoUpdater
    
    var body: some View {
        NavigationView {
            Text("Hello, world!")
                .padding()
            
            List {
                ForEach(0..<10, id: \.self) { number in
                    Text("This is item number \(number)")
                }
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
