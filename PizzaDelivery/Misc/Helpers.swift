//
//  Helpers.swift
//  PizzaDelivery
//
//  Created by Amir Daliri on 22.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import UIKit
import Foundation

class Helpers {
    
    // MARK: - encod decod pizza object Methode
    
    static func savePizza(pizza: PizzaElement) {
        let encoder = JSONEncoder()
        var pizzaArray = Pizza()
        
        guard let pizz = self.getPizza(), pizz.count == 1 else {
            pizzaArray.append(pizza)
            if let encoded = try? encoder.encode(pizzaArray) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "SavedPizza")
                defaults.synchronize()
            }
            return
        }
        
        pizzaArray = [pizza, pizz[0]]
        
        if let encoded = try? encoder.encode(pizzaArray) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedPizza")
            defaults.synchronize()
        }
    }
    
    static func getPizza() -> Pizza? {
        var pizza = Pizza()
        let defaults = UserDefaults.standard
        
        if let savedPizza = defaults.object(forKey: "SavedPizza") as? Data {
            
            let decoder = JSONDecoder()
            if let loadedPizza = try? decoder.decode(Pizza.self, from: savedPizza) {
                pizza = loadedPizza
            }
            
        }
        
        return pizza
    }
    
    static func removePizza() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "SavedPizza")
    }

    
    // MARK: - UI Helpers
    
    
    static var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    static func showAlertWithAction(vc: UIViewController, _ title: String?, _ message: String?, rightBttnTitle: String, rightAction: ((UIAlertAction) -> Swift.Void)?, leftBttnTitle: String, leftAction: ((UIAlertAction) -> Swift.Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: leftBttnTitle, style: .default, handler: leftAction))
        alertController.addAction(UIAlertAction(title: rightBttnTitle, style: .default, handler: rightAction))
        vc.present(alertController, animated: true, completion: nil)
    }

    
    static func alertWithTitle(_ viewController: UIViewController, title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion:nil)
    }
    
    
    // MARK: - date Methode
    
    static func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        let result = formatter.string(from: date)
        return result
    }
}


// TODO: Fix Response Log

var xprintIndex = 0

enum XprintType: String {
    case error = "🚑"
    case warning = "⚠️"
    case info = "ℹ️"
    case debug = "🔨"
}

func xprint(_ items: Any..., type: XprintType = .info, file: String = #file, line: Int = #line) {
    
    let fileUrl = URL(string: file)
    let filename = fileUrl?.lastPathComponent ?? ""
    
    print("---[\(type.rawValue) \(xprintIndex).𝙓𝙋𝙍𝙄𝙉𝙏 @ \(filename):\(line) \(type.rawValue)]---")
    for item in items {
        print(item)
    }
    print(String(repeating: "-", count: 66))
    xprintIndex += 1
}
