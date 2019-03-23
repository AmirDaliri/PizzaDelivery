//
//  PizzaDeliveryUITests.swift
//  PizzaDeliveryUITests
//
//  Created by Amir Daliri on 23.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import XCTest

class PizzaDeliveryUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
    }

    func testIntroEnter() {
        XCUIApplication().buttons["START ORDER"].tap()
    }

    func testRefreshControll() {
        XCUIApplication().buttons["START ORDER"].tap()
        XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element.swipeDown()
    }
    
    func testMenuShowDissmiss() {
        XCUIApplication().buttons["START ORDER"].tap()
        let app = XCUIApplication()
        let menuButton = app.navigationBars["PizzaDelivery.PizzaListVC"].buttons["Menu"]
        menuButton.tap()
        app.buttons["Dismiss"].tap()
    }
    
    func testAddOrder() {
        let app = XCUIApplication()
        app.buttons["START ORDER"].tap()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["ORDER NOW"]/*[[".cells.buttons[\"ORDER NOW\"]",".buttons[\"ORDER NOW\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery2.cells.staticTexts["Mozzarella"].swipeUp()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["CHECK OUT"]/*[[".cells.buttons[\"CHECK OUT\"]",".buttons[\"CHECK OUT\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["HOME"].tap()
    }
}
