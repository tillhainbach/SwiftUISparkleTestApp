//
//  SwiftUISparkleTestAppUITests.swift
//  SwiftUISparkleTestAppUITests
//
//  Created by Till Hainbach on 16.03.21.
//

import XCTest

class SwiftUISparkleTestAppUITests: XCTestCase {
    
    let keychainService = "GitHub - https://api.github.com"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPromptsForPermission() {
        let app = XCUIApplication()
        app.launch()
        
        sleep(5)
        app.terminate()

        let newapp = XCUIApplication()
        newapp.launch()
        
        let prompt = app.staticTexts["Check for updates automatically?"]
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: prompt, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDidDownloadUpdateSuccess() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let enterGithubKeychainNameTextField = app.textFields["Enter Keychain Service"]
        enterGithubKeychainNameTextField.click()
        enterGithubKeychainNameTextField.typeText(keychainService)
        
        let authorizeUpdaterButton = app.buttons["Get Token"]
        authorizeUpdaterButton.click()
        
        let menuBarsQuery = app.menuBars
        menuBarsQuery.menuBarItems["SwiftUISparkleTestApp"].click()
        menuBarsQuery.menuItems["Check for updates"].click()
        let sudialogWindow = app.dialogs["SUUpdateAlert"]
        sudialogWindow.buttons["Install Update"].click()
        
        let sustatusWindow = app.windows["SUStatus"]
        
        let label = sustatusWindow.staticTexts["Ready to Install"]
        let button = sustatusWindow.buttons["Install and Relaunch"]
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: label, handler: nil)
        expectation(for: exists, evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

    }
    
}
