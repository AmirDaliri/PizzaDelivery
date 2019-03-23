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

        let appRequest = AppRequest()
        appRequest.getPizza { (pizza, error) in
            XCTAssertTrue(pizza!.count > 0, "items should not be empty")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            xprint(error?.localizedDescription as Any)
        }
    }

    func testPerformanceExample() {
        self.measure { }
    }

}
