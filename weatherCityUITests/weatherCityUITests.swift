//
//  weatherCityUITests.swift
//  weatherCityUITests
//
//  Created by Elliot Cunningham on 26/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//

import XCTest
import Alamofire
import Moya
import ObjectMapper

// please before run Test remove all City present in collectionView, if you are in a simulator place a braekPoint and and active localization on London

// please run Test in Simulator for set localization on London.

class weatherCityUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        
        app.launch()
        
        continueAfterFailure = false
        
        UserDefaults.standard.set(false, forKey: "kNeedReloadData")
        UserDefaults.standard.synchronize()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testContainACollectionView() {
        let collectionView = app.collectionViews["cityCollectionViewID"]
        XCTAssertNotNil(collectionView)
    }
    
    func testShowModalAddIfClickOnAddButton() {
        app.navigationBars["Weather City"].buttons["Add"].twoFingerTap()
        let modal = app.otherElements["AddModalAccessID"].exists
        
        XCTAssertTrue(modal)
    }
    
    func testOpenDetailWeatherViewOnTapACollectionViewCell() {
        
        XCUIApplication().collectionViews/*@START_MENU_TOKEN@*/.staticTexts["London"]/*[[".cells.staticTexts[\"London\"]",".staticTexts[\"London\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.twoFingerTap()
        
        let detailView = app.otherElements["DetailWeatherViewID"]
        
        XCTAssert(detailView.exists)
    }
    
    func testDetailWeatherViewIsNotPresentAfterCloseIt() {
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["London"]/*[[".cells.staticTexts[\"London\"]",".staticTexts[\"London\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.twoFingerTap()
        app/*@START_MENU_TOKEN@*/.buttons["Fermer"]/*[[".otherElements[\"DetailWeatherViewID\"].buttons[\"Fermer\"]",".buttons[\"Fermer\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.twoFingerTap()
        
        let detailView = app.otherElements["DetailWeatherViewID"]
        
        XCTAssertFalse(detailView.exists)
    }
    
    func testNbOfCellAfterDelleteCityFromDetailWeatherView() {
        
        let nbOfRow = app.cells.count
        
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["London"]/*[[".cells.staticTexts[\"London\"]",".staticTexts[\"London\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.twoFingerTap()
        app/*@START_MENU_TOKEN@*/.buttons["Supprimer"]/*[[".otherElements[\"DetailWeatherViewID\"].buttons[\"Supprimer\"]",".buttons[\"Supprimer\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.twoFingerTap()
        
        let newNbOfRow = app.cells.count
        
        _ = app.waitForExistence(timeout: 10)
        
        XCTAssertFalse(nbOfRow == newNbOfRow)
        
        XCTAssertTrue(nbOfRow == newNbOfRow + 1)
    }
    
    func testNbOfCellAfterCreateNewCity() {
        let nbRow = app.cells.count
        
        app.navigationBars["Weather City"].buttons["Add"].twoFingerTap()
        let textField = app.textFields["AddCityTextFieldId"]
        textField.tap()
        textField.typeText("Madrid")
        app.buttons["AddCityValidateButtonID"].twoFingerTap()
        
        _ = app.waitForExistence(timeout: 10)
        
        let newNbRow = app.cells.count
        
        XCTAssertFalse(nbRow == newNbRow)
        XCTAssertTrue(nbRow == newNbRow - 1)
    }
    
    func testIfNoWeatherForCityCellShowAActivityView() {
        let app = XCUIApplication()
        app.navigationBars["Weather City"].buttons["Add"].twoFingerTap()
        let textField = app.textFields["AddCityTextFieldId"]
        textField.tap()
        textField.typeText("Toronto")
        app/*@START_MENU_TOKEN@*/.buttons["AddCityValidateButtonID"]/*[[".otherElements[\"AddModalAccessID\"]",".buttons[\"Valider\"]",".buttons[\"AddCityValidateButtonID\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.twoFingerTap()
        
        _ = app.waitForExistence(timeout: 5)
        
        let isPresent = (app.activityIndicators.count >= 1)
        
        XCTAssertTrue(isPresent)
    }
    
    func testCloseAddModalAfterTouchOutSide() {
        
        let app = XCUIApplication()
        app.navigationBars["Weather City"].buttons["Add"].twoFingerTap()
        app/*@START_MENU_TOKEN@*/.buttons["AddModelCloseButtonID"]/*[[".otherElements[\"AddModalAccessID\"].buttons[\"AddModelCloseButtonID\"]",".buttons[\"AddModelCloseButtonID\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let modal = app.otherElements["AddModalAccessID"]
        
        XCTAssertFalse(modal.exists)
    }
    
}
