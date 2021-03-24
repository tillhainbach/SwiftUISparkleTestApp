//
//  SparkleAutoUpdater.swift
//  SwiftUISparkleTestApp
//
//  Created by Till Hainbach on 07.03.21.
//
import Foundation
import Sparkle
import os


class SparkleAutoUpdater: NSObject, ObservableObject {
    
    static let service = "GitHub - https://api.github.com"
    
    var updater: SPUUpdater?
    let standardUserDriver: SPUStandardUserDriver

    @Published var canCheckForUpdates: Bool = false
    
    override init() {
        standardUserDriver = SPUStandardUserDriver(hostBundle: Bundle.main, delegate: nil)
        super.init()
        setUpdater()
    }
    
    func setUpdater() {
        guard let token = SparkleAutoUpdater.retrieveToken() else {
            return
        }
        
        let updater = SPUUpdater(hostBundle: Bundle.main, applicationBundle: Bundle.main, userDriver: self, delegate: nil)
        updater.httpHeaders = ["Authorization": "Token \(token)",
                                    "Accept": "application/octet-stream"]
        
        do {
            try updater.start()
            self.updater = updater
        } catch {
            Logger().error("Failed to start SPUUpdater with error: \(error.localizedDescription)")
            return
        }
    }

    
    func checkForUpdates() {
        updater?.checkForUpdates()
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

extension SparkleAutoUpdater: SPUUserDriver {
    
    func showCanCheck(forUpdates canCheckForUpdates: Bool) {
        standardUserDriver.showCanCheck(forUpdates: canCheckForUpdates)
        print("canCheckForUpdates is now \(canCheckForUpdates)")
        self.canCheckForUpdates = canCheckForUpdates
    }
    
    func show(_ request: SPUUpdatePermissionRequest, reply: @escaping (SUUpdatePermissionResponse) -> Void) {
        standardUserDriver.show(request, reply: reply)
    }
    
    func showUserInitiatedUpdateCheck(completion updateCheckStatusCompletion: @escaping (SPUUserInitiatedCheckStatus) -> Void) {
        standardUserDriver.showUserInitiatedUpdateCheck(completion: updateCheckStatusCompletion)
    }
    
    func dismissUserInitiatedUpdateCheck() {
        standardUserDriver.dismissUserInitiatedUpdateCheck()
    }
    
    func showUpdateFound(with appcastItem: SUAppcastItem, userInitiated: Bool, reply: @escaping (SPUUpdateAlertChoice) -> Void) {
        standardUserDriver.showUpdateFound(with: appcastItem, userInitiated: userInitiated, reply: reply)
    }
    
    func showDownloadedUpdateFound(with appcastItem: SUAppcastItem, userInitiated: Bool, reply: @escaping (SPUUpdateAlertChoice) -> Void) {
        standardUserDriver.showDownloadedUpdateFound(with: appcastItem, userInitiated: userInitiated, reply: reply)
    }
    
    func showResumableUpdateFound(with appcastItem: SUAppcastItem, userInitiated: Bool, reply: @escaping (SPUInstallUpdateStatus) -> Void) {
        standardUserDriver.showResumableUpdateFound(with: appcastItem, userInitiated: userInitiated, reply: reply)
    }
    
    func showInformationalUpdateFound(with appcastItem: SUAppcastItem, userInitiated: Bool, reply: @escaping (SPUInformationalUpdateAlertChoice) -> Void) {
        standardUserDriver.showInformationalUpdateFound(with: appcastItem, userInitiated: userInitiated, reply: reply)
    }
    
    func showUpdateReleaseNotes(with downloadData: SPUDownloadData) {
        standardUserDriver.showUpdateReleaseNotes(with: downloadData)
    }
    
    func showUpdateReleaseNotesFailedToDownloadWithError(_ error: Error) {
        standardUserDriver.showUpdateReleaseNotesFailedToDownloadWithError(error)
    }
    
    func showUpdateNotFoundWithError(_ error: Error, acknowledgement: @escaping () -> Void) {
        standardUserDriver.showUpdateNotFoundWithError(error, acknowledgement: acknowledgement)
    }
    
    func showUpdaterError(_ error: Error, acknowledgement: @escaping () -> Void) {
        standardUserDriver.showUpdaterError(error, acknowledgement: acknowledgement)
    }
    
    func showDownloadInitiated(completion downloadUpdateStatusCompletion: @escaping (SPUDownloadUpdateStatus) -> Void) {
        standardUserDriver.showDownloadInitiated(completion: downloadUpdateStatusCompletion)
    }
    
    func showDownloadDidReceiveExpectedContentLength(_ expectedContentLength: UInt64) {
        standardUserDriver.showDownloadDidReceiveExpectedContentLength(expectedContentLength)
    }
    
    func showDownloadDidReceiveData(ofLength length: UInt64) {
        standardUserDriver.showDownloadDidReceiveData(ofLength: length)
    }
    
    func showDownloadDidStartExtractingUpdate() {
        standardUserDriver.showDownloadDidStartExtractingUpdate()
    }
    
    func showExtractionReceivedProgress(_ progress: Double) {
        standardUserDriver.showExtractionReceivedProgress(progress)
    }
    
    func showReady(toInstallAndRelaunch installUpdateHandler: @escaping (SPUInstallUpdateStatus) -> Void) {
        standardUserDriver.showReady(toInstallAndRelaunch: installUpdateHandler)
    }
    
    func showInstallingUpdate() {
        standardUserDriver.showInstallingUpdate()
    }
    
    func showSendingTerminationSignal() {
        standardUserDriver.showSendingTerminationSignal()
    }
    
    func showUpdateInstallationDidFinish(acknowledgement: @escaping () -> Void) {
        standardUserDriver.showUpdateInstallationDidFinish(acknowledgement: acknowledgement)
    }
    
    func dismissUpdateInstallation() {
        standardUserDriver.dismissUpdateInstallation()
    }
    
}
