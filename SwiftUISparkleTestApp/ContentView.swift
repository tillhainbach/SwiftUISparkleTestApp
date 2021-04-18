//
//  ContentView.swift
//  SwiftUISparkleTestApp
//
//  Created by Till Hainbach on 03.03.21.
//

import SwiftUI
import Combine

// draws red or green rectangle around textfield base on input
struct InputValidationTextFieldStyle: TextFieldStyle {
  @Binding var isValidInput: Bool

  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding(5)
      .background(
        RoundedRectangle(cornerRadius: 5)
          .stroke(isValidInput ? Color.green : Color.red, lineWidth: 2)
      ).padding()
  }


}

struct ContentView: View {
  @EnvironmentObject var updater: SparkleAutoUpdater
  @EnvironmentObject var keychainServiceModel: KeychainServiceModel

  var body: some View {
    VStack {
      Text("Please Enter your GitHub Personal Token")
        .background(Color(NSColor.underPageBackgroundColor))
      TextField("Enter GitHub Personal Token", text: $keychainServiceModel.token)
        .textFieldStyle(InputValidationTextFieldStyle(isValidInput: $keychainServiceModel.isValidToken))
        .padding()


      Button("Authorize Updater") {
        storeToken()
        updater.connectToGithub(with: keychainServiceModel.token)
      }
      .disabled(!keychainServiceModel.isValidToken)
    }
    .frame(minWidth: 500, minHeight: 400)

  }

  private func storeToken() {
    let token = keychainServiceModel.token
    let credentials = KeychainServiceModel.Credentials(username: "My-Test-App", password: token)

    do {
      try keychainServiceModel.add(credentials)
    } catch {
      print("Could not store token: \(error.localizedDescription)")
    }

  }

}

extension NSTextField {

  open override var focusRingType: NSFocusRingType {
    get { .none }
    set { }
  }

}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(SparkleAutoUpdater())
      .environmentObject(KeychainServiceModel())
  }
}
