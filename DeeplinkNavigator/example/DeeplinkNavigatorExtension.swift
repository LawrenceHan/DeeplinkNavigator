//
//
//                        _____
//                       / ___/____  ____  ____ _
//                       \__ \/ __ \/ __ \/ __ `/
//                      ___/ / /_/ / / / / /_/ /
//                     /____/\____/_/ /_/\__, /
//                                      /____/
//
//                .-~~~~~~~~~-._       _.-~~~~~~~~~-.
//            __.'              ~.   .~              `.__
//          .'//                  \./                  \\`.
//        .'//                     |                     \\`.
//      .'// .-~"""""""~~~~-._     |     _,-~~~~"""""""~-. \\`.
//    .'//.-"                 `-.  |  .-'                 "-.\\`.
//  .'//______.============-..   \ | /   ..-============.______\\`.
//.'______________________________\|/______________________________`.
//
//
//  DeeplinkNavigatorExtension.swift
//  DeeplinkNavigator
//
//  Created by song on 2017/7/18.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import UIKit

public extension DeeplinkNavigator {
    
    
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
        if popTo(url, context: context, from: from, animated: animated) == nil {
            return push(url, context: context, from: from, animated: animated)
        }
        return nil
    }
    
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
        context: NavigationContext? = nil,
        from: DeeplinkPushable? = nil,
        animated: Bool = true
        ) -> UIViewController?{
        if let viewController = viewController(for: url, context: context) {
            guard let navigationController = from?.lhw_navigationController ?? UIViewController.lhw_topMost?.navigationController else { return nil }
            navigationController.popToViewController(viewController, animated: animated)
            return viewController
        }
        return nil
    }
}
