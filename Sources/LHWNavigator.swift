// The MIT License (MIT)
//
// Copyright (c) 2016 Suyeol Jeon (xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//  LHWNavigator.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 14/03/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//

import UIKit

public typealias _LHWURLConvertible = LHWURLConvertible

open class LHWURLNavigator {
    public typealias LHWURLConvertible = _LHWURLConvertible
    public typealias LHWURLOpenHandler = (_ url: LHWURLConvertible, _ values: [String: Any]) -> Bool
    
    private(set) var urlMap = [String: LHWURLNavigable.Type]()
    private(set) var urlOpenHandlers = [String: LHWURLOpenHandler]()
    
    open var scheme: String? {
        didSet {
            if let scheme = self.scheme, scheme.contains("://") {
                self.scheme = scheme.components(separatedBy: "://")[0]
            }
        }
    }
    
    open static let `default` = LHWURLNavigator()
    
    public init(){
    }
    
    open func map(_ urlPattern: LHWURLConvertible, _ navigable: LHWURLNavigable.Type) {
        let URLString = LHWURLMatcher.default.normalized(urlPattern, scheme: scheme).urlStringValue
        urlMap[URLString] = navigable
    }
    
    open func map(_ urlPattern: LHWURLConvertible, _ handler: @escaping LHWURLOpenHandler) {
        let URLString = LHWURLMatcher.default.normalized(urlPattern, scheme: self.scheme).urlStringValue
        self.urlOpenHandlers[URLString] = handler
    }
    
    open func viewController(for url: LHWURLConvertible,
                             queries: [URLQueryItem]? = nil,
                             userInfo: [AnyHashable: Any]? = nil) -> UIViewController? {
        if let urlMatchComponents = LHWURLMatcher.default.match(url, scheme: scheme, from: Array(urlMap.keys)) {
            let navigable = urlMap[urlMatchComponents.pattern]
            return navigable?.init(url: url, values: urlMatchComponents.values, queries: queries, userInfo: userInfo) as? UIViewController
        }
        return nil
    }
    
    @discardableResult
    open func push(
        _ url: LHWURLConvertible,
        userInfo: [AnyHashable: Any]? = nil,
        from: UINavigationController? = nil,
        animated: Bool = true
        ) -> UIViewController? {
        guard let viewController = viewController(for: url, queries: url.queryItems, userInfo: userInfo) else {
            return nil
        }
        return push(viewController, from: from, animated: animated)
    }
    
    @discardableResult
    open func push(
        _ viewController: UIViewController,
        from: UINavigationController? = nil,
        animated: Bool = true
        ) -> UIViewController? {
        guard let navigationController = from ?? UIViewController.lhw_topMost?.navigationController else {
            return nil
        }
        navigationController.pushViewController(viewController, animated: animated)
        return viewController
    }
    
    @discardableResult
    open func present(
        _ url: LHWURLConvertible,
        userInfo: [AnyHashable: Any]? = nil,
        wrap: Bool = false,
        from: UIViewController? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
        ) -> UIViewController? {
        guard let viewController = viewController(for: url, userInfo: userInfo) else { return nil }
        return present(viewController, wrap: wrap, from: from, animated: animated, completion: completion)
    }
    
    @discardableResult
    open func present(
        _ viewController: UIViewController,
        wrap: Bool = false,
        from: UIViewController? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
        ) -> UIViewController? {
        guard let fromViewController = from ?? UIViewController.lhw_topMost else { return nil }
        if wrap {
            let navigationController = UINavigationController(rootViewController: viewController)
            fromViewController.present(navigationController, animated: animated, completion: nil)
        } else {
            fromViewController.present(viewController, animated: animated, completion: nil)
        }
        return viewController
    }
    
    @discardableResult
    open func open(_ url: LHWURLConvertible) -> Bool {
        let urlOpenHandlersKeys = Array(urlOpenHandlers.keys)
        if let urlMatchComponents = LHWURLMatcher.default.match(url, scheme: scheme, from: urlOpenHandlersKeys) {
            let handler = urlOpenHandlers[urlMatchComponents.pattern]
            if handler?(url, urlMatchComponents.values) == true {
                return true
            }
        }
        return false
    }
}

public extension LHWURLNavigator {
    public func urlMapKeys() -> [String] {
        return Array(urlMap.keys)
    }
    
    public func urlOpenHandlersKeys() -> [String] {
        return Array(urlOpenHandlers.keys)
    }
}

// MARK: - Default Navigator
public let Navigator = LHWURLNavigator.default
