//
//  CheckOutTableVC.swift
//  PizzaDelivery
//
//  Created by Amir Daliri on 22.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import UIKit

class CheckOutTableVC: UITableViewController {

    @IBOutlet weak var pizzaImageView: SpringImageView!
    @IBOutlet weak var secondPizzaImageView: SpringImageView!
    @IBOutlet weak var pizzaNameLabel: UILabel!
    
    @IBOutlet weak var fullPizzaView: UIView!
    @IBOutlet weak var fullPizzaIcon: SpringImageView!
    @IBOutlet weak var fullPizzaLabel: UILabel!
    @IBOutlet weak var fullPizzaSlicceLabel: UILabel!
    @IBOutlet weak var fullPizzaPriceLabel: UILabel!

    @IBOutlet weak var halfPizzaView: UIView!
    @IBOutlet weak var halfPizzaIcon: SpringImageView!
    @IBOutlet weak var halfPizzaLabel: UILabel!
    @IBOutlet weak var halfPizzaSlicceLabel: UILabel!
    @IBOutlet weak var halfPizzaPriceLabel: UILabel!
    
    @IBOutlet weak var orderBttn: UIButton!
    
    @IBOutlet weak var pizzaLabel: UILabel!
    @IBOutlet weak var pizzaPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var secondOrderStack: UIStackView!
    @IBOutlet weak var secondOrderPizzaName: UILabel!
    @IBOutlet weak var secondOrderPriceName: UILabel!
    @IBOutlet weak var secondOrderSeprator: UIImageView!
    
    let showSucccessVCIdentifire = "showSucccessVC"
    
    var price: String?
    var pizzaName: String?
    var pizzaImage: UIImage?
    var isFullSelected: Bool?
    var reloadBasket = false

    var pizza: Pizza?
    var finallPrice: String?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        setupView()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSucccessVCIdentifire {
            let vc: SuccessVC = segue.destination as! SuccessVC
            vc.price = self.finallPrice
        }
    }
    
    // MARK: - Setp View Methode
    
    func setupView() {
        
        let backgroundImage = #imageLiteral(resourceName: "dark-back")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        self.tableView.tableFooterView = UIView()
        
        self.orderBttn.applyCornerBttn()
        self.fullPizzaView.applyCardStyle()
        
        if !self.reloadBasket {
            self.fullPizzaPriceLabel.text = "$" + (self.price ?? "-")
            self.pizzaNameLabel.text = self.pizzaName
            self.pizzaPriceLabel.text = "$" + (self.price ?? "-")
            self.pizzaLabel.text = self.pizzaName
            self.totalPriceLabel.text = "$" + String(self.calucateTotalPrice())
            
            guard let isFullSelected = self.isFullSelected, !isFullSelected else { return  }
            self.fullPizzaSlicceLabel.text = "(4 Slices)"
            self.sizeLabel.text = "Half"
            self.fullPizzaLabel.text = "Half"
            
        } else {
            guard let pizza = Helpers.getPizza() else {return}
            self.loadBasket(pizza: pizza)
        }

        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func animatePizzaImage() {
        
        pizzaImageView.image = ArrayConstants.pizzaImages.randomElement()!
        pizzaImageView.animation = "fadeInRight"
        pizzaImageView.duration = 2.0
        pizzaImageView.autostart = true
        pizzaImageView.animate()
        
        secondPizzaImageView.image = ArrayConstants.pizzaImages.randomElement()!
        secondPizzaImageView.animation = "fadeInLeft"
        secondPizzaImageView.duration = 2.0
        secondPizzaImageView.autostart = true
        secondPizzaImageView.animate()
    }
    
    // MARK: - Reload Basket Methode
    
    func loadBasket(pizza: Pizza) {
            switch pizza.count {
                
            case 1:
                let firstPizza = pizza[0]
                self.fullPizzaPriceLabel.text = "$" + String(firstPizza.price)
                self.pizzaNameLabel.text = firstPizza.name
                self.pizzaPriceLabel.text = "$" + String(firstPizza.price)
                self.pizzaLabel.text = firstPizza.name
                self.price = String(firstPizza.price)
                self.totalPriceLabel.text = "$" + String(self.calucateTotalPrice())
                self.finallPrice = "$" + String(self.calucateTotalPrice())
                if firstPizza.size == "Half" {
                    self.fullPizzaSlicceLabel.text = "(4 Slices)"
                    self.fullPizzaLabel.text = firstPizza.size
                }

            case 2:
                animatePizzaImage()
                
                let firstPizza = pizza[0]
                self.fullPizzaPriceLabel.text = "$" + String(firstPizza.price)
                self.fullPizzaSlicceLabel.text = "(4 Slices)"
                self.pizzaNameLabel.text = firstPizza.name
                self.pizzaPriceLabel.text = "$" + String(firstPizza.price)
                self.pizzaLabel.text = firstPizza.name
                self.price = String(firstPizza.price)
                if firstPizza.size == "Half" {
                    self.fullPizzaSlicceLabel.text = "(4 Slices)"
                    self.fullPizzaLabel.text = firstPizza.size
                }
                
                let secondOrder = pizza[1]
                self.halfPizzaView.applyCardStyle()
                self.halfPizzaView.isHidden = false
                self.secondOrderStack.isHidden = false
                self.secondOrderSeprator.isHidden = false
                self.secondPizzaImageView.isHidden = false
                self.fullPizzaLabel.text = "Half"
                self.halfPizzaPriceLabel.text = "$" + String(secondOrder.price)
                self.secondOrderPizzaName.text = secondOrder.name
                self.secondOrderPriceName.text = "$" + String(secondOrder.price)
                if secondOrder.size == "Half" {
                    self.halfPizzaSlicceLabel.text = "(4 Slices)"
                    self.halfPizzaLabel.text = firstPizza.size
                }
                
                self.pizzaNameLabel.text = firstPizza.name + " & " + secondOrder.name
                self.totalPriceLabel.text = "$" + String(self.calucateTotalPrice() + secondOrder.price)
                self.finallPrice = "$" + String(self.calucateTotalPrice() + secondOrder.price)
            default: return
                
            }
    }
    
    // MARK: - Calucate Methode
    
    func calucateTotalPrice() -> Double {
        guard let price = self.price else { return 0 }
        let IntPrice = Double(price)!
        let total = IntPrice + 8.0
        return total
    }
    
    // MARK: - Action Methode
    
    @IBAction func checkOutBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: showSucccessVCIdentifire, sender: self)
    }
    

}
