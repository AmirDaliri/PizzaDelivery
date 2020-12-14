//
//  ControllerKeys.swift
//  PizzaDelivery
//
//  Created by amir on 15.12.2020.
//  Copyright © 2020 Mozio. All rights reserved.
//

import UIKit

typealias ControllerKey = String

let kControllerMap: [ ControllerKey: (classType: UIViewController.Type, title: String)] =
    [
        ControllerKeys.books.rawValue: (PizzaListVC.self, ""),
        ControllerKeys.book.rawValue: (OrderTableVC.self, ""),
        ControllerKeys.faves.rawValue: (CheckOutTableVC.self, "")
    ]

enum ControllerKeys: ControllerKey {
    case books
    case book
    case faves
}
