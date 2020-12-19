//
//  AlertBuilder.swift
//  PizzaDelivery
//
//  Created by amir on 19.12.2020.
//  Copyright © 2020 Mozio. All rights reserved.
//

import UIKit

struct AlertBuilder {

    private var style: UIAlertController.Style = .alert
    private var title: String?
    private var message: String?
    private var actions: [UIAlertAction] = []

    func style(_ style: UIAlertController.Style) -> AlertBuilder {
        var copy = self
        copy.style = style
        return copy
    }

    func title(_ title: String) -> AlertBuilder {
        var copy = self
        copy.title = title
        return copy
    }

    func message(_ message: String) -> AlertBuilder {
        var copy = self
        copy.message = message
        return copy
    }

    func addAction(title: String,
                   style: UIAlertAction.Style,
                   callback: @escaping () -> Void) -> AlertBuilder {
        let action = UIAlertAction(title: title, style: style) { _ in
            callback()
        }
        var copy = self
        copy.actions.append(action)
        return copy
    }

    func build() -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )
        actions.forEach { alertController.addAction($0) }
        return alertController
    }
}

// MARK: - Project extensions

extension AlertBuilder {

    func show(in viewController: UIViewController) {
        let alertController = build()
        viewController.present(alertController, animated: true)
    }

    func addCancelAction(title: String,
                         callback: @escaping () -> Void = {}) -> AlertBuilder {
        return addAction(title: title, style: .cancel, callback: callback)
    }

    func addDefaultAction(title: String,
                          callback: @escaping () -> Void) -> AlertBuilder {
        return addAction(title: title, style: .default, callback: callback)
    }

    func addDestructiveAction(title: String,
                              callback: @escaping () -> Void) -> AlertBuilder {
        return addAction(title: title, style: .destructive, callback: callback)
    }
}
