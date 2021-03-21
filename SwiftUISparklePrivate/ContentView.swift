//
//  ContentView.swift
//  SwiftUISparklePrivate
//
//  Created by Till Hainbach on 10.03.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Group {
            Text("Hello, world!")
                .padding()
        }
        .frame(minWidth: 400, idealWidth: 500, maxWidth: .infinity, minHeight: 200, idealHeight: 400, maxHeight: .infinity, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
