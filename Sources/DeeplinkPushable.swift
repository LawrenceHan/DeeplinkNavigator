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
//  DeeplinkPushable.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 12/07/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//

import UIKit

/// A type which able to push a viewController
public protocol DeeplinkPushable {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

/// A type which able to present a viewController
public protocol DeeplinkPresentable {
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)?)
}

extension UIView: DeeplinkPushable, DeeplinkPresentable {
    public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        lhw_navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        lhw_parentViewController?.present(viewController, animated: animated, completion: completion)
    }
}

extension UINavigationController: DeeplinkPushable {}
extension UIViewController: DeeplinkPresentable {}
