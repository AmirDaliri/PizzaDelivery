//
//  Pizza.swift
//  PizzaDelivery
//
//  Created by Amir Daliri on 21.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import Foundation


typealias Pizza = [PizzaElement]

struct PizzaElement: Codable {
    let name: String
    let price: Double
    let size: String?
    
    init(name: String, price: Double, size: String) {
        self.name = name
        self.price = price
        self.size = size
    }
}
