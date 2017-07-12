//
//  UIView+TopViewController.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 12/07/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Returns the current view's top most view controller.
    public var lhw_topMostViewController: UIViewController? {
        return UIViewController.lhw_topMost(of: parentViewController)
    }
    
    /// Find a UIView's parentViewController by 
    /// traverse its responder chain
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
