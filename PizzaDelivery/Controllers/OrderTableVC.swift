//
//  OrderTableVC.swift
//  PizzaDelivery
//
//  Created by Amir Daliri on 22.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import UIKit

class OrderTableVC: UITableViewController {

    @IBOutlet weak var pizzaImageView: UIImageView!
    @IBOutlet weak var pizzaNameLabel: UILabel!
    
    @IBOutlet weak var fullPizzaView: UIView!
    @IBOutlet weak var fullPizzaIcon: SpringImageView!
    @IBOutlet weak var fullPizzaLabel: UILabel!
    @IBOutlet weak var fullPizzaSlicceLabel: UILabel!
    @IBOutlet weak var fullPizzaPriceLabel: UILabel!
    @IBOutlet weak var fullPizzaCheckIcon: UIImageView!
    
    @IBOutlet weak var halfPizzaView: UIView!
    @IBOutlet weak var halfPizzaIcon: SpringImageView!
    @IBOutlet weak var halfPizzaLabel: UILabel!
    @IBOutlet weak var halfPizzaSlicceLabel: UILabel!
    @IBOutlet weak var halfPizzaPriceLabel: UILabel!
    @IBOutlet weak var halfPizzaCheckIcon: UIImageView!

    @IBOutlet weak var decriptionTextView: UITextView!
    @IBOutlet weak var orderBttn: UIButton!
    
    let showCheckOutVCIdentifire = "showCheckOutVC"
    
    var pizzaName: String?
    var fullPrice: String?
    var halfPrice: String?
    var isFullSelected = true
    
    var dic: [(pizza: String, price: String)] = []
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        setupView()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showCheckOutVCIdentifire {
            let vc: CheckOutTableVC = segue.destination as! CheckOutTableVC
            if isFullSelected {
                vc.price = self.fullPrice
                vc.isFullSelected = true
            } else {
                vc.price = self.halfPrice
                vc.isFullSelected = false
            }
            vc.pizzaImage = self.pizzaImageView.image
            vc.pizzaName = self.pizzaName
        }
    }

    // MARK: - Setp View Methode
    
    func setupView() {
        let backgroundImage = UIImage(named: "dark-back.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        self.tableView.tableFooterView = UIView()
        self.pizzaNameLabel.text = self.pizzaName
        self.pizzaImageView.image = ArrayConstants.pizzaImages.randomElement()!
        
        self.fullPizzaView.applyCardStyle()
        self.halfPizzaView.applyCardStyle()
        
        let fullPizzaGesture = UITapGestureRecognizer(target: self, action: #selector(self.applyFullPizza(_:)))
        self.fullPizzaView.addGestureRecognizer(fullPizzaGesture)
        self.fullPizzaView.isUserInteractionEnabled = true
        
        let halfPizzaGesture = UITapGestureRecognizer(target: self, action: #selector(self.applyHalfPizza(_:)))
        self.halfPizzaView.addGestureRecognizer(halfPizzaGesture)
        self.halfPizzaView.isUserInteractionEnabled = true
        
        self.fullPizzaPriceLabel.text = self.fullPrice
        self.halfPizzaPriceLabel.text = self.halfPrice
        
        self.decriptionTextView.applyBorderTextView()
        self.orderBttn.applyCornerBttn()
    }
    
    // MARK: - Action Methode
    
    @IBAction func orderBttnTapped(_ sender: Any) {
        guard let pizza = Helpers.getPizza() else {return}
        switch pizza.count {
        case 0:
            if !self.isFullSelected {
                Helpers.showAlertWithAction(vc: self, Strings.halfOrderTitle, Strings.halfOrderMessage, rightBttnTitle: "continue", rightAction: { (rightAction) in
                    OperationQueue.main.addOperation ({
                        self.saveOrder(name: self.pizzaName!, price: self.fullPrice!, size: "Full")
                        self.performSegue(withIdentifier: self.showCheckOutVCIdentifire, sender: self)
                    })
                }, leftBttnTitle: "new order") { (leftAction) in
                    OperationQueue.main.addOperation ({
                        self.saveOrder(name: self.pizzaName!, price: self.halfPrice!, size: "Half")
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            } else {
                self.performSegue(withIdentifier: showCheckOutVCIdentifire, sender: self)
            }
        case 1:
            if !self.isFullSelected {
                self.saveOrder(name: self.pizzaName!, price: self.fullPrice!, size: "Full")
            } else {
                Helpers.removePizza()
            }
            self.performSegue(withIdentifier: showCheckOutVCIdentifire, sender: self)
        default:
            return
        }
    }
    
    @objc func applyFullPizza(_ sender: UITapGestureRecognizer) {
        fullPizzaSelected()
        self.isFullSelected = true
    }
    
    @objc func applyHalfPizza(_ sender: UITapGestureRecognizer) {
        halfPizzaSelected()
        self.isFullSelected = false
    }
    
    func fullPizzaSelected() {
        fullPizzaIcon.image = #imageLiteral(resourceName: "pizzaSelected")
        fullPizzaIcon.animation = "morph"
        fullPizzaIcon.duration = 2.0
        fullPizzaIcon.autostart = true
        fullPizzaIcon.animate()
        fullPizzaCheckIcon.isHidden = false
        fullPizzaLabel.textColor = UIColor.black
        fullPizzaSlicceLabel.textColor = UIColor.black
        fullPizzaPriceLabel.textColor = UIColor.priceGreen
        
        halfPizzaIcon.image = #imageLiteral(resourceName: "pizzaUnselected")
        halfPizzaCheckIcon.isHidden = true
        halfPizzaLabel.textColor = UIColor.mainGray
        halfPizzaSlicceLabel.textColor = UIColor.mainGray
        halfPizzaPriceLabel.textColor = UIColor.mainGray
        
    }
    
    func halfPizzaSelected() {
        halfPizzaIcon.image = #imageLiteral(resourceName: "pizzaSelected")
        halfPizzaIcon.animation = "morph"
        halfPizzaIcon.duration = 2.0
        halfPizzaIcon.autostart = true
        halfPizzaIcon.animate()
        halfPizzaCheckIcon.isHidden = false
        halfPizzaLabel.textColor = UIColor.black
        halfPizzaSlicceLabel.textColor = UIColor.black
        halfPizzaPriceLabel.textColor = UIColor.priceGreen
        
        fullPizzaIcon.image = #imageLiteral(resourceName: "pizzaUnselected")
        fullPizzaCheckIcon.isHidden = true
        fullPizzaLabel.textColor = UIColor.mainGray
        fullPizzaSlicceLabel.textColor = UIColor.mainGray
        fullPizzaPriceLabel.textColor = UIColor.mainGray
    }
    
    // MARK: - Save Order Methode
    
    func saveOrder(name: String, price: String, size: String) {
        let pizza = PizzaElement(name: name, price: Double(price)!, size: size)
        Helpers.savePizza(pizza: pizza)
    }
    
}
