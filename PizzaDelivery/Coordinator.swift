//
//  Coordinator.swift
//  PizzaDelivery
//
//  Created by amir on 15.12.2020.
//  Copyright © 2020 Mozio. All rights reserved.
//

import UIKit

enum ControllerFlowType {
    case navigation
    case present
}

class Coordinator {
    static let shared: Coordinator = Coordinator()
    
    // MARK: - Properties
    private(set) var previousControllerKey: ControllerKey?
    private(set) var currentControllerKey: ControllerKey? {
        willSet {
            previousControllerKey = NavigationManager.shared.topViewController()?.controllerKey ?? currentControllerKey
        }
    }
    private var waitingControllerKeys: [ControllerKey]?
    private var waitingControllerFlowType: ControllerFlowType = ControllerFlowType.navigation
    private var waitingData: Any?
    
    private init() {}
    
    // MARK: - Navigation
    func requestNavigation(_ controllerKey: ControllerKeys, data: Any? = nil, animated: Bool = true) {
        requestNavigation(controllerKey.rawValue, data: data, animated: animated)
    }
    
    func requestNavigation(_ controllerKey: ControllerKey, data: Any? = nil, animated: Bool = true) {
        NavigationManager.shared.navigateToController(controllerKey, animated: animated, data: data as AnyObject?)
        self.currentControllerKey = controllerKey
    }
    
    func requestPresent(_ controllerKey: ControllerKeys, data: Any? = nil, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {
        requestPresent(controllerKey.rawValue, data: data, animated: animated, modalPresentationStyle: modalPresentationStyle)
    }
    
    func requestPresent(_ controllerKey: ControllerKey, data: Any? = nil, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {
        NavigationManager.shared.presentController(controllerKey,
                                                   animationType: animated ? .moveIn : .none,
                                                   animationDirection: .fromTop,
                                                   data: data,
                                                   modalPresentationStyle: modalPresentationStyle)
        self.currentControllerKey = controllerKey
    }
    
    func displayPrevious(_ data: Any? = nil, animated: Bool = true) {
        NavigationManager.shared.closeTopController(animated, data: data)
    }
    
    // MARK: - Starter App
    func initializeApp(isLogout: Bool = false, fetchContent: Bool = true) {
        if #available(iOS 13.0, *) {
            /*
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate
            else {
                return
            }
            let window = UIWindow(windowScene: windowScene)
            let controller = ControllerFactory.viewController(ControllerKeys.books.rawValue, data: nil)
            let navController = ControllerFactory.navigationController(controller!)
            window.rootViewController = navController
            sceneDelegate.window = window
            window.makeKeyAndVisible()
            */
        } else {
            // Fallback on earlier versions
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let controller = ControllerFactory.viewController(ControllerKeys.books.rawValue, data: nil)
                let navController = ControllerFactory.navigationController(controller!)
                appDelegate.window?.rootViewController?.dismiss(animated: false, completion: nil)
                appDelegate.window?.rootViewController = navController
                appDelegate.window?.makeKeyAndVisible()
                UIApplication.shared.beginIgnoringInteractionEvents()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    
    // MARK: - Close the App
    func applicationSuspend() {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        Thread.sleep(forTimeInterval: 2.0)
        exit(0)
    }
}
