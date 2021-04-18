//
//  SparkleAutoUpdater.swift
//  SwiftUISparkleTestApp
//
//  Created by Till Hainbach on 07.03.21.
//
import Foundation
import Sparkle
import os
import Combine

@available(macOS 10.15, *)
public final class SparkleAutoUpdater: NSObject, ObservableObject {
  @Published var canCheckForUpdates: Bool = false

  /// store SPUUPdater and SPUStandardUserDriver
  private var updater: SPUUpdater?
  private let standardUserDriver: SPUStandardUserDriver = SPUStandardUserDriver(hostBundle: Bundle.main, delegate: nil)

  private var cancellable: AnyCancellable?

  public init(userDriver: SPUUserDriver? = nil, delegate: SPUUpdaterDelegate? = nil) {
    super.init()
    setUpdater(userDriver: userDriver, delegate: delegate)
  }

  /// Check for updates
  public func checkForUpdates() {
    updater?.checkForUpdates()
  }

  private func setUpdater(userDriver: SPUUserDriver?, delegate: SPUUpdaterDelegate?) {
    let userDriver = userDriver ?? self
    updater = SPUUpdater(hostBundle: Bundle.main, applicationBundle: Bundle.main, userDriver: userDriver, delegate: delegate)
    // Subscribe to didFinishLaunchingNotification and start updater
    // when application finished launching
    cancellable = NotificationCenter.default.publisher(for: NSApplication.didFinishLaunchingNotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in self?.start() }
  }

  private func start() {
    do {
      try updater?.start()
    } catch {
      // Post Failure notification, present as an alert to the user or log error
      NotificationCenter.default.post(name: Self.didFailStartingUpdater, object: error)
      return
    }
  }

}

//MARK: - Extension: Notification.Name
extension SparkleAutoUpdater {
  static let didFailStartingUpdater = Notification.Name("SPUUpdater-start-failed")
}

//MARK: - Extension HTTPHeaders
extension SparkleAutoUpdater {
  public func setHTTPHeaders(_ value: String, for key: String) {
    if updater?.httpHeaders == nil {
      // init httpHeaders dict
      updater?.httpHeaders = [key: value]
      return
    }
    updater?.httpHeaders?[key] = value
  }
}

//MARK: - Extention: Authorization
extension SparkleAutoUpdater {
  public func authorize(with token: String) {
    setHTTPHeaders("Token \(token)", for: "Authorization")
  }

}

//MARK: - Extension: GitHub Convenience
extension SparkleAutoUpdater {
  public func connectToGithub(with token: String) {
    authorize(with: token)
    setHTTPHeaders("application/octet-stream", for: "Accept")
  }
}

//MARK: - Extension: Implemention of SPUUserDriver
extension SparkleAutoUpdater: SPUUserDriver {

  public func showCanCheck(forUpdates canCheckForUpdates: Bool) {
    standardUserDriver.showCanCheck(forUpdates: canCheckForUpdates)
    self.canCheckForUpdates = canCheckForUpdates
  }

  public func show(_ request: SPUUpdatePermissionRequest, reply: @escaping (SUUpdatePermissionResponse) -> Void) {
    standardUserDriver.show(request, reply: reply)
  }

  public func showUserInitiatedUpdateCheck(completion updateCheckStatusCompletion: @escaping (SPUUserInitiatedCheckStatus) -> Void) {
    standardUserDriver.showUserInitiatedUpdateCheck(completion: updateCheckStatusCompletion)
  }

  public func dismissUserInitiatedUpdateCheck() {
    standardUserDriver.dismissUserInitiatedUpdateCheck()
  }

  public func showUpdateFound(with appcastItem: SUAppcastItem, userInitiated: Bool, reply: @escaping (SPUUpdateAlertChoice) -> Void) {
    standardUserDriver.showUpdateFound(with: appcastItem, userInitiated: userInitiated, reply: reply)
  }

  public func showDownloadedUpdateFound(with appcastItem: SUAppcastItem, userInitiated: Bool, reply: @escaping (SPUUpdateAlertChoice) -> Void) {
    standardUserDriver.showDownloadedUpdateFound(with: appcastItem, userInitiated: userInitiated, reply: reply)
  }

  public func showResumableUpdateFound(with appcastItem: SUAppcastItem, userInitiated: Bool, reply: @escaping (SPUInstallUpdateStatus) -> Void) {
    standardUserDriver.showResumableUpdateFound(with: appcastItem, userInitiated: userInitiated, reply: reply)
  }

  public func showInformationalUpdateFound(with appcastItem: SUAppcastItem, userInitiated: Bool, reply: @escaping (SPUInformationalUpdateAlertChoice) -> Void) {
    standardUserDriver.showInformationalUpdateFound(with: appcastItem, userInitiated: userInitiated, reply: reply)
  }

  public func showUpdateReleaseNotes(with downloadData: SPUDownloadData) {
    standardUserDriver.showUpdateReleaseNotes(with: downloadData)
  }

  public func showUpdateReleaseNotesFailedToDownloadWithError(_ error: Error) {
    standardUserDriver.showUpdateReleaseNotesFailedToDownloadWithError(error)
  }

  public func showUpdateNotFoundWithError(_ error: Error, acknowledgement: @escaping () -> Void) {
    standardUserDriver.showUpdateNotFoundWithError(error, acknowledgement: acknowledgement)
  }

  public func showUpdaterError(_ error: Error, acknowledgement: @escaping () -> Void) {
    standardUserDriver.showUpdaterError(error, acknowledgement: acknowledgement)
  }

  public func showDownloadInitiated(completion downloadUpdateStatusCompletion: @escaping (SPUDownloadUpdateStatus) -> Void) {
    standardUserDriver.showDownloadInitiated(completion: downloadUpdateStatusCompletion)
  }

  public func showDownloadDidReceiveExpectedContentLength(_ expectedContentLength: UInt64) {
    standardUserDriver.showDownloadDidReceiveExpectedContentLength(expectedContentLength)
  }

  public func showDownloadDidReceiveData(ofLength length: UInt64) {
    standardUserDriver.showDownloadDidReceiveData(ofLength: length)
  }

  public func showDownloadDidStartExtractingUpdate() {
    standardUserDriver.showDownloadDidStartExtractingUpdate()
  }

  public func showExtractionReceivedProgress(_ progress: Double) {
    standardUserDriver.showExtractionReceivedProgress(progress)
  }

  public func showReady(toInstallAndRelaunch installUpdateHandler: @escaping (SPUInstallUpdateStatus) -> Void) {
    standardUserDriver.showReady(toInstallAndRelaunch: installUpdateHandler)
  }

  public func showInstallingUpdate() {
    standardUserDriver.showInstallingUpdate()
  }

  public func showSendingTerminationSignal() {
    standardUserDriver.showSendingTerminationSignal()
  }

  public func showUpdateInstallationDidFinish(acknowledgement: @escaping () -> Void) {
    standardUserDriver.showUpdateInstallationDidFinish(acknowledgement: acknowledgement)
  }

  public func dismissUpdateInstallation() {
    standardUserDriver.dismissUpdateInstallation()
  }

}
