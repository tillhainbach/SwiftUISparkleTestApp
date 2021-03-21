//
//  SparkleAutoUpdater.swift
//  SwiftUISparkleTestApp
//
//  Created by Till Hainbach on 07.03.21.
//
import Foundation
import Sparkle
import os


class SparkleAutoUpdater: NSObject {
        
    let updater: SPUUpdater
    static let service = "GitHub - https://api.github.com"
    
    init?(userDriver: SPUStandardObservableUserDriver) {
        
        guard let token = SparkleAutoUpdater.retrieveToken() else {
            return nil
        }
        
        self.updater = SPUUpdater(hostBundle: Bundle.main, applicationBundle: Bundle.main, userDriver: userDriver, delegate: nil)
        self.updater.httpHeaders = ["Authorization": "Token \(token)",
                                    "Accept": "application/octet-stream"]
        
        do {
            try self.updater.start()
        } catch {
            Logger().error("Failed to start SPUUpdater with error: \(error as NSObject)")
            return nil
        }
    }

    
    func checkForUpdates() {
        updater.checkForUpdates()
    }
    
    static func retrieveToken() -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecReturnData as String: kCFBooleanTrue!,
                                    kSecMatchLimit as String: kSecMatchLimitOne]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            Logger().error("SparkleAutoUpdater was unable to find Github Token.")
            return nil
        }
        guard status == errSecSuccess else {
            let errorMessage = SecCopyErrorMessageString(status, nil) as String? ?? "Did not understand KeychainError code"
            Logger().error("\(errorMessage)")
            return nil
        }
        guard let tokenData = item as? Data,
              let token = String(data: tokenData, encoding: .utf8) else {
            Logger().error("unexpected password data")
            return nil
        }

        return token
    }
}
