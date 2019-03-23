//
//  SuccessVC.swift
//  PizzaDelivery
//
//  Created by Amir Daliri on 23.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import UIKit

class SuccessVC: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalBillLabel: UILabel!
    @IBOutlet weak var homeBttn: UIButton!
    
    var price: String?
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        homeBttn.applyCornerBttn()
        self.dateLabel.text = Helpers.getCurrentDate()
        self.totalBillLabel.text = self.price
    }

    // MARK: - Action Methode
    
    @IBAction func homeBttnTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pizzaListVC") as! PizzaListVC
        let nav  = UINavigationController(rootViewController: vc)
        Helpers.removePizza()
        self.present(nav, animated: true, completion: nil)
    }
}
