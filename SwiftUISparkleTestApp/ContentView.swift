//
//  ContentView.swift
//  SwiftUISparkleTestApp
//
//  Created by Till Hainbach on 03.03.21.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var updater: SparkleAutoUpdater
  @EnvironmentObject var keychainServiceModel: KeychainServiceModel

  @State private var keychainService = ""

  var body: some View {
    HStack {
      authorizeWithToken
        .padding()

      Divider()

      authorizeFromKeychain
        .padding()
    }
    .frame(minWidth: 500, minHeight: 400)

  }

  //MARK: - Sub Views
  private var authorizeWithToken: some View {
    VStack(alignment: .leading) {
      Text("Please Enter your GitHub Personal Token")
      TextField("Enter GitHub Personal Token", text: $keychainServiceModel.token)
        .textFieldStyle(InputValidationTextFieldStyle(isValidInput: $keychainServiceModel.isValidToken))

      Button("Authorize Updater") {
        storeToken()
        updater.connectToGithub(with: keychainServiceModel.token)
      }
      .disabled(!keychainServiceModel.isValidToken)
    }
  }

  private var authorizeFromKeychain: some View {
    VStack(alignment: .leading) {
      Text("Enter Keychain Service for Github Token")
      TextField("Enter Keychain Service", text: $keychainService)
        .textFieldStyle(InputValidationTextFieldStyle(isValidInput: $keychainServiceModel.isValidToken))
      Button("Get Token") {
        retrieveCredentialsAndAuthorize()
      }
    }
  }

  //MARK: - Private Methods
  private func storeToken() {
    let token = keychainServiceModel.token
    let credentials = KeychainServiceModel.Credentials(username: "My-Test-App", password: token)

    do {
      try keychainServiceModel.add(credentials)
    } catch {
      print("Could not store token: \(error.localizedDescription)")
    }

  }

  private func retrieveCredentialsAndAuthorize() {
    do {
      let credentials = try keychainServiceModel.retrieveCredentials(for: keychainService)
      keychainServiceModel.isValidToken = true
      updater.connectToGithub(with: credentials.password)
    } catch {
      print("\(error)")
    }
  }

}

//MARK: - Preview
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(SparkleAutoUpdater())
      .environmentObject(KeychainServiceModel())
  }
}
