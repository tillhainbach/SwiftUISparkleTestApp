//
//  SwiftUISparkleTestAppUITests.swift
//  SwiftUISparkleTestAppUITests
//
//  Created by Till Hainbach on 16.03.21.
//

import XCTest

class SwiftUISparkleTestAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDidDownloadUpdateSuccess() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let menuBarsQuery = app.menuBars
        menuBarsQuery.menuBarItems["SwiftUISparkleTestApp"].click()
        menuBarsQuery/*@START_MENU_TOKEN@*/.menuItems["Check for updates"]/*[[".menuBarItems[\"SwiftUISparklePrivate\"]",".menus",".menuItems[\"Check for updates\"]",".menuItems[\"menuAction:\"]",".menus.menuItems[\"Check for updates\"]"],[[[-1,2],[-1,4],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.click()
        let sudialogWindow = app/*@START_MENU_TOKEN@*/.dialogs["SUUpdateAlert"]/*[[".dialogs[\"Software Update\"]",".dialogs[\"SUUpdateAlert\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sudialogWindow/*@START_MENU_TOKEN@*/.buttons["Install Update"]/*[[".dialogs[\"Software Update\"].buttons[\"Install Update\"]",".dialogs[\"SUUpdateAlert\"].buttons[\"Install Update\"]",".buttons[\"Install Update\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        let sustatusWindow = app/*@START_MENU_TOKEN@*/.windows["SUStatus"]/*[[".windows[\"Updating SwiftUISparklePrivate\"]",".windows[\"SUStatus\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let label = sustatusWindow.staticTexts["Ready to Install"]
        let button = sustatusWindow.buttons["Install and Relaunch"]
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: label, handler: nil)
        expectation(for: exists, evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

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

}
