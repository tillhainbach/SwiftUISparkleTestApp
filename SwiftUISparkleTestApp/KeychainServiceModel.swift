//
//  KeychainServiceModel.swift
//  SwiftUISparkleTestApp
//
//  Created by Till Hainbach on 25.03.21.
//

import SwiftUI
import Combine

//MARK: - KeychainServiceModel
public final class KeychainServiceModel: NSObject, ObservableObject {
  @Published var token: String = ""
  @Published var isValidToken: Bool = false

  static let GithubAPI = URL(string: "https://api.github.com/")!
  // There should always be a Bundle Identifier, if not, something is very fishy.
  static let service = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String

  public struct Credentials {
    var username: String
    var password: String
  }

  enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
  }


  //MARK: - Init
  public override init() {
    super.init()
    self.setUpValidationPipeline()

  }

  //MARK: - Public Methods
  /// Retrieve Credentials from keychain
  public func retrieveCredentials() throws -> Credentials {

    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrService as String: KeychainServiceModel.service,
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnAttributes as String: true,
                                kSecReturnData as String: true]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status != errSecItemNotFound else { throw KeychainError.noPassword }
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status)}

    guard let existingItem = item as? [String : Any],
          let passwordData = existingItem[kSecValueData as String] as? Data,
          let password = String(data: passwordData, encoding: .utf8),
          let account = existingItem[kSecAttrAccount as String] as? String
    else {
      throw KeychainError.unexpectedPasswordData
    }
    let credentials = Credentials(username: account, password: password)

    return credentials
  }

  /// Add Credentials to keychain
  public func add(_ credentials: Credentials) throws {
    let account = credentials.username
    let password = credentials.password.data(using: .utf8)!

    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrAccount as String: account,
                                kSecAttrService as String: KeychainServiceModel.service,
                                kSecValueData as String: password]

    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status)}

  }

  //MARK: - Private Methods
  private func setUpValidationPipeline() {
    $token
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .removeDuplicates()
      .flatMap { token in
        return self.validateToken(token)
      }
      .receive(on: DispatchQueue.main)
      .assign(to: &$isValidToken)
  }

  /// Validates response by  cheking status code == 200 and token scope
  private func validateHTTPResponse(_ httpResponse: HTTPURLResponse) -> Bool {
    guard httpResponse.statusCode == 200,
      let scopes = httpResponse.value(forHTTPHeaderField: "x-oauth-scopes") else {
      return false
    }

    return scopes.contains("repo")
  }

  /// Validate Token by calling the Github API and checking the HTTPresponse
  private func validateToken(_ token: String) -> AnyPublisher<Bool, Never> {
    guard token.count == 40 else {
      return Just(false).eraseToAnyPublisher()
    }

    var request = URLRequest(url: Self.GithubAPI)
    request.httpMethod = "GET"
    request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")

    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap() { element -> Bool in
        guard let httpResponse = element.response as? HTTPURLResponse else {
          return false
        }
        return self.validateHTTPResponse(httpResponse)
      }
      .replaceError(with: false)
      .eraseToAnyPublisher()
  }


}

