//  MIT License
//
//  Copyright (c) 2017 Lawrence
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
    /// - returns: A Bool value indicated success or failure
    @discardableResult
    public func popTo(
        _ url: DeeplinkConvertible,
        from: DeeplinkPushable? = nil,
        animated: Bool = true
        ) -> [UIViewController]? {
        if let urlMatchComponents = DeeplinkMatcher.default.match(url, scheme: self.scheme, from: Array(self.urlMap.keys)) {
            guard let item = self.urlMap[urlMatchComponents.pattern] else { return nil }
            guard let navigationController = from?.lhw_navigationController ?? UIViewController.lhw_topMost?.navigationController else { return nil }
            for viewController in navigationController.viewControllers.reversed() {
                if viewController.isKind(of: item.navigable as! UIViewController.Type) {
                    return navigationController.popToViewController(viewController, animated: true)
                }
            }
        }
        return nil
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
        from: DeeplinkPushable? = nil,
        animated: Bool = true
        ) -> UIViewController? {
        if popTo(url, from: from, animated: animated) == nil {
            return push(url, context: context, from: from, animated: animated)
        }
        return nil
    }
}
