//
//  ViewController.swift
//  PizzaDelivery
//
//  Created by Amir Daliri on 21.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import UIKit
import Foundation

class PizzaListVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuBarBttn: UIBarButtonItem!
    @IBOutlet weak var basketBarBttn: BadgeBarButtonItem!
    
    let PizzaListCellIdentifire = "pizzaListCollectionViewCell"
    let showOrderVCIdentifire = "showPizzaOrder"
    let showCheckOutVCIdentifire = "showCheckOutVC"

    var pizza: [PizzaElement]?
    var refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        setupView()
        checkBasket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkBasket()
    }
    
    // MARK: - Setup View Methode
    
    func setupView() {
        self.navigationController?.navigationBar.transparentNavigationBar()
        self.navigationController?.navigationBar.tintColor = UIColor.mainRed
        self.menuBarBttn.image = #imageLiteral(resourceName: "ic-menu").withRenderingMode(.alwaysOriginal)
        self.basketBarBttn.image = #imageLiteral(resourceName: "ic-bascket").withRenderingMode(.alwaysOriginal)
        self.collectionView.alwaysBounceVertical = true
        self.setupPullToRefresh()
        self.getData()
    }
    
    
    // MARK: - Check Bascket Methode
    
    func checkBasket() {
        guard let pizza = Helpers.getPizza(), pizza.count > 0 else {return}
        self.basketBarBttn.badgeNumber = pizza.count
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        
        if segue.identifier == showOrderVCIdentifire {
            
            if let row = sender {
                let indexPathRow = row as! Int
                let vc = segue.destination as! OrderTableVC
                guard let singlePizza = self.pizza?[indexPathRow] else { return }
                let halfPrice = singlePizza.price / 2
                vc.pizzaName = singlePizza.name
                vc.fullPrice = String(singlePizza.price)
                vc.halfPrice = String(halfPrice)
            }
            
        } else if segue.identifier == showCheckOutVCIdentifire {
            
            guard let pizza = Helpers.getPizza() else { return }
            let vc: CheckOutTableVC = segue.destination as! CheckOutTableVC
            vc.reloadBasket = true
            vc.pizza = pizza
            
        } else {
            
            guard let infoVC = segue.destination as? InfoVC else { return }
            infoVC.customBlurEffectStyle = .dark
            infoVC.customAnimationDuration = TimeInterval(0.5)
            infoVC.customInitialScaleAmmount = CGFloat(Double(0.7))
            
        }
    }
    
    // MARK: - Refresh Methode
    
    func setupPullToRefresh() {
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [.foregroundColor: UIColor.mainRed])
        refreshControl.tintColor = UIColor.mainRed
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }

    // MARK: - Api Methode
    
    func getData() {
        self.view.showLoadSpin()
        if !Reachability.connectedToNetwork() {
            Helpers.alertWithTitle(self, title: nil, message: Strings.connectionError)
            return
        }
        AppRequest.sharedInstants.getPizza { (pizza, err) in
            OperationQueue.main.addOperation ({
                self.pizza = pizza
                self.collectionView.reloadData()
                self.view.hideLoadingSpin()
            })
        }
    }
   
    // MARK: - Action Methode
    
    @objc func refresh(sender: AnyObject) {
        getData()
        checkBasket()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl.endRefreshing()
            self.view.setNeedsDisplay()
        }
    }

    @IBAction func basketBarBBtnTapped(_ sender: Any) {
        guard let pizza = Helpers.getPizza(), pizza.count > 0 else {
            Helpers.alertWithTitle(self, title: "Sorry!", message: Strings.orderBasketAlertMessage)
            return
        }
        xprint(pizza)
        self.performSegue(withIdentifier: showCheckOutVCIdentifire, sender: self)
    }
    
}

// MARK: - UICollectionView DataSource & Delegate Methode

extension PizzaListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pizza?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PizzaListCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: PizzaListCellIdentifire, for: indexPath as IndexPath) as? PizzaListCollectionViewCell)!
        
        guard let singlePizza = self.pizza?[indexPath.row] else { return cell }
        cell.config(pizza: singlePizza)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pizza = Helpers.getPizza(), pizza.count == 2 else {
            self.performSegue(withIdentifier: showOrderVCIdentifire, sender: indexPath.row)
            return
        }
        Helpers.alertWithTitle(self, title: "Sorry!", message: Strings.orderLimiteMessage)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout Methode

extension PizzaListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columnNumber = Int(collectionView.bounds.width / 160)
        
        
        let width = (collectionView.bounds.width / CGFloat(columnNumber)) - 10
        return CGSize(width: width, height: 255)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
