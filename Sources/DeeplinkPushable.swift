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

extension UINavigationController: DeeplinkPushable {}
extension UIViewController: DeeplinkPresentable {}
