//
//  UINavigationController+Ex.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/4/27.
//

import UIKit

extension UINavigationController{
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
