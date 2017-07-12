//
//  DeeplinkNavigator+PushOrPopTo.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 11/07/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//

import UIKit

public extension DeeplinkNavigator {
    
    /// Try to pop to a viewController if it's exist in UINavigationController's stack already,
    /// return false if cannot find related viewController.
    ///
    /// - parameter url: The URL to find view controllers.
    /// - parameter from: The navigation controller which is used to push a view controller. Use application's top-most
    ///     view controller if `nil` is specified. `nil` by default.
    /// - parameter animated: Whether animates view controller transition or not. `true` by default.
    ///
    /// - returns: The pushed view controller. Returns `nil` if there's no matching view controller or failed to push
    ///            a view controller.
    /// - Returns: A Bool value indicated success or failure
    @discardableResult
    public func popTo(
        _ url: DeeplinkConvertible,
        context: NavigationContext? = nil,
        from: UINavigationController? = nil,
        animated: Bool = true
        ) -> Bool {
        if let urlMatchComponents = DeeplinkMatcher.default.match(url, scheme: self.scheme, from: Array(self.urlMap.keys)) {
            guard let item = self.urlMap[urlMatchComponents.pattern] else { return false }
            guard let navigationController = from ?? UIViewController.lhw_topMost?.navigationController else { return false }
            for viewController in navigationController.viewControllers.reversed() {
                if viewController.isKind(of: item.navigable as! UIViewController.Type) {
                    navigationController.popToViewController(viewController, animated: true)
                    return true
                }
            }
        }
        return false
    }
    
    
    /// Try to pop to a viewController if it's exist in UINavigationController's stack already,
    /// if not, push a new viewController then.
    ///
    /// - parameter url: The URL to find view controllers.
    /// - parameter from: The navigation controller which is used to push a view controller. Use application's top-most
    ///     view controller if `nil` is specified. `nil` by default.
    /// - parameter animated: Whether animates view controller transition or not. `true` by default.
    ///
    /// - returns: The pushed view controller. Returns `nil` if there's no matching view controller or failed to push
    ///            a view controller.
    @discardableResult
    public func pushOrPopTo(
        _ url: DeeplinkConvertible,
        context: NavigationContext? = nil,
        from: UINavigationController? = nil,
        animated: Bool = true
        ) -> UIViewController? {
        if popTo(url, context: context, from: from, animated: animated) == false {
            return push(url, context: context, from: from, animated: animated)
        }
        return nil
    }
}
