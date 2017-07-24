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
        if let viewController = reloadViewController(url: url, context: context, from: from) {
            guard let navigationController = from?.lhw_navigationController ?? UIViewController.lhw_topMost?.navigationController else { return nil }
            navigationController.popToViewController(viewController, animated: true)
            return viewController
        }
        return nil
    }
    
    @discardableResult
    public func reloadTo(
        _ url: DeeplinkConvertible,
        context: NavigationContext? = nil,
        from: DeeplinkPushable? = nil
        ) -> UIViewController? {
        return reloadViewController(url: url, context: context , from: from)
    }
    
    fileprivate func reloadViewController(url: DeeplinkConvertible,
                                       context: NavigationContext? = nil,
                                       from: DeeplinkPushable? = nil) -> UIViewController?{
        if let urlMatchComponents = DeeplinkMatcher.default.match(url, scheme: self.scheme, from: Array(self.urlMap.keys)) {
            guard let item = self.urlMap[urlMatchComponents.pattern] else { return nil }
            guard let vcType = item.navigable as? UIViewController.Type else { return nil }
            guard let navigationController = from?.lhw_navigationController ?? UIViewController.lhw_topMost?.navigationController else { return nil }
            if let viewController = navigationController.viewControllers.reversed().first(where: { (vc) -> Bool in
                return vc.classForCoder == vcType
            }) {
                if let lifeCycle = viewController as? LifeCycleable{
                    let navigation = DeeplinkNavigation(
                        url: url,
                        values: urlMatchComponents.values,
                        mappingContext: item.mappingContext,
                        navigationContext: context
                    )
                    lifeCycle.navigationLoad(parameter: navigation.parameter, needRequest: navigation.needRequest)
                }
                return viewController
            }
        }
        return nil
    }
}
