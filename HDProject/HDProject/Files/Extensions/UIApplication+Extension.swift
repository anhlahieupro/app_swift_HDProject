//
//  UIApplication+Extension.swift
//  HDProject
//
//  Created by Hieu Dinh on 5/10/20.
//  Copyright © 2020 Hieu Dinh. All rights reserved.
//

import UIKit

public extension UIApplication {
    func getTopViewController(base: UIViewController? = nil) -> UIViewController? {
        let base = base ?? UIApplication.shared.keyWindow?.rootViewController
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
