//
//  Strings.swift
//  PizzaDelivery
//
//  Created by Amir Daliri on 21.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import Foundation
import UIKit

struct Strings {
    static let mainUrl = "http://static.mozio.com/mobile/tests/pizzas.json"
    static let connectionError = "There was a problem connecting to the server. please try later!"
    static let halfOrderTitle = "Dear Customer"
    static let halfOrderMessage = "you chose half, still you can order a half other pizza. "
    static let orderBasketAlertMessage = "You have not any order for show"
    static let orderLimiteMessage = "Dear Customer you can't choose more than one full pizza. please check order basket!"
}

struct ArrayConstants {
    static let pizzaImages = [#imageLiteral(resourceName: "pizz1"), #imageLiteral(resourceName: "pizz5"), #imageLiteral(resourceName: "pizz2"), #imageLiteral(resourceName: "pizz3"), #imageLiteral(resourceName: "pizz6"), #imageLiteral(resourceName: "pizz4"),#imageLiteral(resourceName: "pizz7"), #imageLiteral(resourceName: "pizz8")]
}
