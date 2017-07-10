//
//  XibViewController.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 2017/7/9.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import UIKit

final class XibViewController: UIViewController, Titlable {
    override func viewDidLoad() {
        title = identifier
    }
}

extension XibViewController: XibNavigable {
    static func viewControllerFromXib(navigation: DeeplinkNavigation) -> UIViewController? {
        print(navigation)
        let vc = XibViewController(nibName: String(describing: self), bundle: nil)
        return vc
    }
}
