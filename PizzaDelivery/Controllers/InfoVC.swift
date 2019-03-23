//
//  InfoVC.swift
//  PizzaDelivery
//
//  Created by Amir Daliri on 22.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import UIKit
import MessageUI

class InfoVC: UIViewController {
    
    
    @IBOutlet weak var popupContentContainerView: UIView!
    
    var customBlurEffectStyle: UIBlurEffect.Style!
    var customInitialScaleAmmount: CGFloat!
    var customAnimationDuration: TimeInterval!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return customBlurEffectStyle == .dark ? .lightContent : .default
    }
    
    // MARK: - Actio Methode
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBOutlet weak var dismissButton: UIButton! {
        didSet {
            dismissButton.layer.cornerRadius = dismissButton.frame.height/2
        }
    }
    
    @IBOutlet weak var popupMainView: UIView! {
        didSet {
            popupMainView.layer.cornerRadius = 10
        }
    }
    
    @IBAction func twitterBttn(_ sender: Any) {
        guard let url = URL(string: "https://twitter.com/daliri1369") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func linkedinBttn(_ sender: Any) {
        guard let url = URL(string: "https://www.linkedin.com/in/amir-daliri-560697119/") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func githubBttn(_ sender: Any) {
        guard let url = URL(string: "https://github.com/AmirDaliri") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func mailBttn(_ sender: Any) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["daliri.amir1369@gmail.com"])
        composeVC.setSubject("Hello Mr Daliri")
        composeVC.setMessageBody("This mail is from PizzaDelivery application.", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
}

// MARK: - MIBlurPopupDelegate

extension InfoVC: BlurPopupDelegate {
    
    var popupView: UIView {
        return popupContentContainerView ?? UIView()
    }
    
    var blurEffectStyle: UIBlurEffect.Style {
        return customBlurEffectStyle
    }
    
    var initialScaleAmmount: CGFloat {
        return customInitialScaleAmmount
    }
    
    var animationDuration: TimeInterval {
        return customAnimationDuration
    }
    
}

extension InfoVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

