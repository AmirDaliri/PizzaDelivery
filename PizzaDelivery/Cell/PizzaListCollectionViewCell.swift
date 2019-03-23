//
//  PizzaListCollectionViewCell.swift
//  PizzaDelivery
//
//  Created by Amir Daliri on 22.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import UIKit

class PizzaListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var pizzaImageView: SpringImageView!
    @IBOutlet weak var pizzaNameLabel: UILabel!
    @IBOutlet weak var halfPriceLabel: UILabel!
    @IBOutlet weak var fullPriceLabel: UILabel!
    
    // MARK: - Config Cell Methode
    
    func config(pizza: PizzaElement)  {
        let halfPrice = pizza.price / 2
        backView.applyCardStyle()
        pizzaImageView.image = ArrayConstants.pizzaImages.randomElement()!
        pizzaNameLabel.text = pizza.name
        fullPriceLabel.text = "$" + String(pizza.price)
        halfPriceLabel.text = "$" + String(halfPrice)
    }
    
}
