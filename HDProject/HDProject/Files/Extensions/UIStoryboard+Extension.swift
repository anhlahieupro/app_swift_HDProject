//
//  UIStoryboard+Extension.swift
//  HDProject
//
//  Created by Hieu Dinh on 4/18/20.
//  Copyright © 2020 Hieu Dinh. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    func instantiate<T: UIViewController>(_ Type: T.Type,
                                          withIdentifier identifier: String = T.className) -> T? {
        return instantiateViewController(withIdentifier: identifier) as? T
    }
}
