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

extension XibViewController: InitNavigable {
    convenience init?(navigation: DeeplinkNavigation) {
        self.init()
    }
}
