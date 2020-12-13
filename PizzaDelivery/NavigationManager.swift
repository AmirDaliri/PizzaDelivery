//
//  NavigationManager.swift
//  PizzaDelivery
//
//  Created by amir on 13.12.2020.
//  Copyright © 2020 Mozio. All rights reserved.
//

import UIKit

enum AnimationDirection {
    case fromBottom
    case fromTop
    case fromLeft
    case fromRight
}

enum AnimationType {
    case push
    case reveal
    case fade
    case moveIn
    case none
}

protocol NavigableContainer {
    func activeViewController() -> UIViewController
}

typealias CompletionBlock = () -> Void

class NavigationManager {
    
    static let shared = NavigationManager()
    
    // MARK: - Properties
    private static let kAnimationDuration: Double = 0.5
    private var dictControllers: [ControllerKey: AnyClass] = [ControllerKey: AnyClass]()
    private var lastTransition: CATransition?
    private var comingFromCenterButtonAction = false
    
    init() {
        for item in Array(kControllerMap.keys) {
            dictControllers[item] = kControllerMap[item]!.classType
        }
    }
    
    /*
     func registerViewController(_ controllerClass: AnyClass, controllerKey: ControllerKey) {
     dictControllers[controllerKey] = controllerClass
     }
     
     func registeredViewConrollers() -> NSDictionary {
     return NSDictionary(dictionary: dictControllers)
     }
     */
    
    // MARK: - Top VC Method
    func topViewController() -> UIViewController? {
        guard let rootController = (UIApplication.shared.windows.first?.rootViewController) else { return nil }
        return topViewController(rootController)
    }
    
    private func topViewController(_ rootViewController: UIViewController) -> UIViewController {
        if rootViewController is UITabBarController {
            let tabBarController = (rootViewController as? UITabBarController)!
            return self.topViewController(tabBarController.selectedViewController!)
        } else if rootViewController is UINavigationController {
            let navigationController = (rootViewController as? UINavigationController)!
            if let viewController = navigationController.visibleViewController {
                return self.topViewController(viewController)
            } else {
                return rootViewController
            }
        } else if rootViewController is UIPageViewController {
            let pageViewController = (rootViewController as? UIPageViewController)!
            return self.topViewController((pageViewController.viewControllers?.last!)!)
        } else if rootViewController.presentedViewController != nil {
            return self.topViewController(rootViewController.presentedViewController!)
        } else if let navigableController = rootViewController as? NavigableContainer {
            return self.topViewController(navigableController.activeViewController())
        } else {
            return rootViewController
        }
    }
    
    func closeTopController(_ animated: Bool, data: Any?, completion: CompletionBlock? = nil) {
        let topViewController = self.topViewController()
        if topViewController?.isModal() ?? false {
            if let safeData = data {
                topViewController?.presentingViewController?.data = safeData
            }
            if lastTransition != nil {
                let containerView = topViewController?.view.window
                containerView?.backgroundColor = UIColor.clear
                containerView?.layer.add(closeTransition(), forKey: nil)
            }
            topViewController?.dismiss(animated: animated, completion: {
                self.lastTransition = nil
                completion?()
            })
        } else if let navigationController = topViewController?.navigationController {
            if navigationController.viewControllers.count > 2 {
                let index = navigationController.viewControllers.firstIndex(of: topViewController!)
                let controller = navigationController.viewControllers[index!]
                if let safeData = data {
                    controller.data = safeData
                }
            }
            navigationController.popViewController(animated: true) {
                completion?()
            }
        }
    }
    
    func dismissTopController(_ type: AnimationType,
                              direction: AnimationDirection,
                              data: Any?) {
        let topViewController = self.topViewController()
        if topViewController?.presentingViewController == nil {
            return
        }
        if let safeData = data {
            topViewController?.presentingViewController?.data = safeData
        }
        let transition = self.transition(type, animationDirection: direction)
        if transition != nil {
            let containerView: UIView = (topViewController?.view.window)!
            containerView.backgroundColor = UIColor.clear
            containerView.layer.add(transition!, forKey: nil)
        }
        topViewController?.dismiss(animated: false, completion: {
            self.lastTransition = transition
        })
    }
    
    private func closeTopVC(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        if viewController.presentingViewController != nil {
            viewController.dismiss(animated: true) {
                if let topVC = self.topViewController() {
                    self.closeTopVC(topVC, completion: completion)
                }
            }
            return
        } else if viewController.navigationController != nil && viewController.navigationController?.viewControllers.count ?? 0 > 1 {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                if let topVC = self.topViewController() {
                    self.closeTopVC(topVC, completion: completion)
                }
            }
            viewController.navigationController?.popToRootViewController(animated: true)
            CATransaction.commit()
            return
        }
        completion?()
    }
    
    func backToController(_ controllerKey: ControllerKeys, completion: (() -> Void)? = nil) {
        let topVC = NavigationManager.shared.topViewController()
        if topVC?.controllerKey != controllerKey.rawValue {
            let poppedVC = topVC?.navigationController?.popViewController(animated: true)
            if poppedVC == nil {
                topVC?.dismiss(animated: true, completion: {
                    self.backToController(controllerKey)
                })
            } else {
                self.backToController(controllerKey)
            }
        }
    }
    
    func popToMain(completion: (() -> Void)? = nil) {
        if let topVC = topViewController() {
            closeTopVC(topVC, completion: completion)
        } else {
            completion?()
        }
    }
    
    func dismissTopController () {
        let topVC = NavigationManager.shared.topViewController()
        topVC?.dismiss(animated: true, completion: nil)
    }
    
    func popViewController () {
        let topVC = NavigationManager.shared.topViewController()
        topVC?.navigationController?.popViewController(animated: true)
    }
    
    func popToRootNavigationVC() {
        let topVC = NavigationManager.shared.topViewController()
        topVC?.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Push Method
    func navigateToController(_ controllerKey: ControllerKey, animated: Bool, data: Any?) {
        let topViewController = self.topViewController()
        guard let controllerClass = self.dictControllers[controllerKey] else {
            return
        }
        if let navigationController = topViewController?.navigationController {
            let isNavigate = navigateFromNavigationController(controllerClass,
                                                              navigationController: navigationController,
                                                              data: data,
                                                              controllerKey: controllerKey,
                                                              animated: animated)
            if isNavigate {
                return
            }
        }
        if let pageViewController = topViewController?.parent as? UIPageViewController {
            let isNavigate = navigateFromPageController(controllerClass,
                                                        pageViewController: pageViewController,
                                                        data: data)
            if isNavigate {
                return
            }
        }
        if let topController = topViewController {
            _ = navigateFromPresentedController(controllerClass,
                                                topViewController: topController,
                                                data: data,
                                                controllerKey: controllerKey,
                                                animated: animated)
        }
    }
    
    private func navigateFromNavigationController(_ controllerClass: AnyClass,
                                                  navigationController: UINavigationController,
                                                  data: Any?,
                                                  controllerKey: ControllerKey,
                                                  animated: Bool) -> Bool {
        
        if navigatePopFromNavigationController(controllerClass,
                                               navigationController: navigationController,
                                               data: data,
                                               controllerKey: controllerKey,
                                               animated: animated) {
            return true
        }
        
        if let navContParent = navigationController.navigationController {
            if navigatePopFromNavigationController(controllerClass,
                                                   navigationController: navContParent,
                                                   data: data,
                                                   controllerKey: controllerKey,
                                                   animated: animated) {
                return true
            }
        }
        if let controller = ControllerFactory.viewController(controllerKey, data: data) {
            navigationController.pushViewController(controller, animated: animated)
            return true
        }
        return false
    }
    
    private func navigatePopFromNavigationController(_ controllerClass: AnyClass,
                                                     navigationController: UINavigationController,
                                                     data: Any?,
                                                     controllerKey: ControllerKey,
                                                     animated: Bool) -> Bool {
        for childCont in navigationController.viewControllers {
            if childCont.isMember(of: controllerClass) {
                if let navTopController = navigationController.topViewController {
                    let topContClass: AnyClass? = navTopController.classForCoder
                    let sameClass = (topContClass?.isSubclass(of: childCont.classForCoder))!
                    let currentIndex = navigationController.viewControllers.firstIndex(of: childCont)
                    if sameClass &&
                        (currentIndex == navigationController.viewControllers.count - 2 ||
                            currentIndex == navigationController.viewControllers.count - 1) {
                        continue
                    }
                    childCont.forcedByNavigationManager = true
                    if let nData = data {
                        childCont.data = nData
                    }
                    navigationController.popToViewController(childCont, animated: animated)
                    return true
                }
            }
        }
        return false
    }
    
    private func navigateFromPageController(_ controllerClass: AnyClass,
                                            pageViewController: UIPageViewController,
                                            data: Any?) -> Bool {
        if pageViewController.isKind(of: UIPageViewController.classForCoder()) {
            var direction: UIPageViewController.NavigationDirection = UIPageViewController.NavigationDirection.forward
            let dataSource = pageViewController.dataSource
            var found: Bool = false
            var newVC = pageViewController.viewControllers?.last
            while true {
                if let nNewVC = newVC {
                    newVC = dataSource?.pageViewController(pageViewController, viewControllerAfter: nNewVC)
                    if newVC!.isMember(of: controllerClass) {
                        direction = UIPageViewController.NavigationDirection.forward
                        found = true
                        break
                    }
                } else {
                    break
                }
            }
            if !found {
                newVC = pageViewController.viewControllers?.last
                while true {
                    if let nNewVC = newVC {
                        newVC = dataSource?.pageViewController(pageViewController, viewControllerAfter: nNewVC)
                        if type(of: newVC) == controllerClass.self {
                            direction = UIPageViewController.NavigationDirection.reverse
                            break
                        }
                    } else {
                        break
                    }
                }
            }
            if let nVC = newVC {
                if let safeData = data {
                    nVC.data = safeData
                }
                pageViewController.setViewControllers([nVC], direction: direction, animated: true, completion: { (_) in
                })
            }
            return true
        }
        return false
    }
    
    private func navigateFromPresentedController(_ controllerClass: AnyClass,
                                                 topViewController: UIViewController,
                                                 data: Any?,
                                                 controllerKey: ControllerKey,
                                                 animated: Bool) -> Bool {
        var control = false
        if let presentingController = topViewController.presentingViewController {
            if presentingController.isMember(of: controllerClass) {
                control = true
            }
        }
        if control {
            self.closeTopController(animated, data: data)
        } else {
            if let controller = ControllerFactory.viewController(controllerKey, data: data) {
                controller.forcedByNavigationManager = true
                topViewController.present(controller, animated: animated, completion: { self.lastTransition = nil })
                return true
            }
        }
        return false
    }
    
    // MARK: - Present Method
    func presentController(_ controllerKey: ControllerKey,
                           animationType: AnimationType, animationDirection: AnimationDirection, data: Any?, modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {
        
        let topViewController = self.topViewController()
        
        if let controller = ControllerFactory.viewController(controllerKey, data: data) {
            let navController = ControllerFactory.navigationController(controller)
            navController.modalPresentationStyle = modalPresentationStyle
            topViewController?.present(navController, animated: true, completion: nil)
            return
        }
    }
    
    // MARK: - Close Transition
    private func closeTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = NavigationManager.kAnimationDuration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = convertToCATransitionType((lastTransition?.type).map { $0.rawValue } ?? CATransitionType.push.rawValue)
        transition.subtype = CATransitionSubtype.fromRight
        
        if let subType = convertFromOptionalCATransitionSubtype(lastTransition?.subtype) {
            switch subType {
            case convertFromCATransitionSubtype(CATransitionSubtype.fromTop):
                transition.subtype = CATransitionSubtype.fromBottom
            case convertFromCATransitionSubtype(CATransitionSubtype.fromLeft):
                transition.subtype = CATransitionSubtype.fromRight
            case convertFromCATransitionSubtype(CATransitionSubtype.fromRight):
                transition.subtype = CATransitionSubtype.fromLeft
            case convertFromCATransitionSubtype(CATransitionSubtype.fromBottom):
                transition.subtype = CATransitionSubtype.fromTop
            default:
                break
            }
        }
        return transition
    }
    
    // MARK: - CATransition Method
    private func transition(_ animationType: AnimationType, animationDirection: AnimationDirection) -> CATransition? {
        if animationType != AnimationType.none {
            let transition = CATransition()
            transition.duration = NavigationManager.kAnimationDuration
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            
            switch animationType {
            case .push:
                transition.type = CATransitionType.push
            case .reveal:
                transition.type = CATransitionType.reveal
            case .moveIn:
                transition.type = CATransitionType.moveIn
            case .fade:
                transition.type = CATransitionType.fade
            default:
                break
            }
            
            switch animationDirection {
            case .fromTop:
                transition.subtype = CATransitionSubtype.fromTop
            case .fromLeft:
                transition.subtype = CATransitionSubtype.fromLeft
            case .fromRight:
                transition.subtype = CATransitionSubtype.fromRight
            case .fromBottom:
                transition.subtype = CATransitionSubtype.fromBottom
            }
            
            return transition
        }
        
        return nil
    }
    
    // MARK: - Open Safari
    func navigateToSafari(url: String) {
        DispatchQueue.main.async {
            if let url  = URL(string: url), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToCATransitionType(_ input: String) -> CATransitionType {
    return CATransitionType(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromOptionalCATransitionSubtype(_ input: CATransitionSubtype?) -> String? {
    guard let input = input else { return nil }
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromCATransitionSubtype(_ input: CATransitionSubtype) -> String {
    return input.rawValue
}
