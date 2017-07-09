//
//  ViewController.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 13/03/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//

import UIKit

final class StoryboardViewController: UIViewController, Titlable {
    override func viewDidLoad() {
        title = identifier
        view.backgroundColor = UIColor.red
    }
}

extension StoryboardViewController: StoryboardNavigable {
    static func viewControllerFromStoryBoard(navigation: LHWNavigation) -> UIViewController? {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: String(describing: self))
        return vc
    }
}
