//
//  Extensions.swift
//  PizzaDelivery
//
//  Created by Amir Daliri on 22.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UINavigationBar Methode

extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
    func disTransparentNavigationBar() {
        self.isTranslucent = false
    }
    
}

// MARK: - UIView Methode

extension UIView {
    @discardableResult
    func applyCardStyle() -> UIView {
        let layer = self.layer
        layer.masksToBounds = false
        layer.cornerRadius = 8.0
        layer.shadowOpacity = 4.45
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor.white.cgColor
        return self
    }
    
    @discardableResult
    func applyBorderTextView() -> UIView {
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.cornerRadius = 8
        layer.borderColor = UIColor.mainGray.cgColor
        return self
    }
    
    @discardableResult
    func applyCornerBttn() -> UIView {
        layer.masksToBounds = false
        layer.cornerRadius = 16.0
        layer.shadowOpacity = 8.45
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor.white.cgColor
        return self
    }
}
