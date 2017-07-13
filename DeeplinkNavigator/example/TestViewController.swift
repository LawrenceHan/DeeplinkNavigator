//
//  TestViewController.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 11/07/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//

import UIKit

final class TestViewController: UIViewController, Titlable {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = identifier
        view.backgroundColor = UIColor.white
    }
}

extension TestViewController: InitNavigable {
    convenience init?(navigation: DeeplinkNavigation) {
        self.init()
    }
}
