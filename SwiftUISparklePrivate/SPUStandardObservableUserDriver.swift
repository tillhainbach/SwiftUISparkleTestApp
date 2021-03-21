//
//  SPUStandardObservableUserDriver.swift
//  ArchitecturalSampleArchiver
//
//  Created by Till Hainbach on 09.03.21.
//

import Foundation
import Sparkle


class SPUStandardObservableUserDriver: NSObject, ObservableObject, SPUUserDriver {
    let standardUserDriver: SPUStandardUserDriver
    
    @Published var canCheckForUpdates: Bool = false
        
    init (hostBundle: Bundle, delegate: SPUStandardUserDriverDelegate?) {
        standardUserDriver = SPUStandardUserDriver(hostBundle: hostBundle, delegate: delegate)
    }
    
    func showCanCheck(forUpdates canCheckForUpdates: Bool) {
        standardUserDriver.showCanCheck(forUpdates: canCheckForUpdates)
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
