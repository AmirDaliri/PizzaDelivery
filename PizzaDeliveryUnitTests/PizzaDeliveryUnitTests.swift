//
//  PizzaDeliveryUnitTests.swift
//  PizzaDeliveryUnitTests
//
//  Created by Amir Daliri on 23.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import XCTest
@testable import PizzaDelivery

class PizzaDeliveryUnitTests: XCTestCase {

    let appRequest = AppRequest()
    let pizza = PizzaElement(name: "pepperoni", price: 10.0, size: "Full")

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testParsResponse() {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "jsonResponse", ofType: "txt") {
            if let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) {
                let decoder = JSONDecoder()
                let jsonData = try? decoder.decode(Pizza.self, from: data)
                //*****************************************************************
                // its fail, because i put size value in pizza class. this value is optional  and always return null before than user set the any order.
                //XCTAssertNil(jsonData, "should not be nil")
                //*****************************************************************
                XCTAssertGreaterThan(jsonData!.count, 0, "should have values")
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testgetPizza() {
        let exp = expectation(description: "server fetch")

        appRequest.getPizza { (pizza, error) in
            XCTAssertTrue(pizza!.count > 0, "items should not be empty")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            xprint(error?.localizedDescription as Any)
        }
    }
    
    func testSaveSingleOrder() {
        Helpers.savePizza(pizza: self.pizza)
        if let savedOrder = Helpers.getPizza() {
            XCTAssertNotNil(savedOrder, "should not be nil")
            XCTAssertGreaterThan(savedOrder.count, 0, "should have values")
            Helpers.removePizza()
        } else {
            XCTFail()
        }
    }
    
    func testSaveTwoOrder() {
        Helpers.savePizza(pizza: self.pizza)
        let secondOrder = PizzaElement(name: "ccheese", price: 10.0, size: "Half")
        Helpers.savePizza(pizza: secondOrder)
        if let savedOrder = Helpers.getPizza() {
            XCTAssertNotNil(savedOrder, "should not be nil")
            XCTAssertGreaterThan(savedOrder.count, 1, "should more than one values")
            Helpers.removePizza()
        } else {
            XCTFail()
        }
    }

    func testPerformanceExample() {
        // This is a performance app request test case.
        self.measure {
            
            let exp = expectation(description: "server fetch")

            appRequest.getPizza({ (pizza, error) in
                exp.fulfill()
            })
            
            waitForExpectations(timeout: 10.0, handler: { (error) in
                xprint (error?.localizedDescription as Any)
            })
            
        }
    }

}
