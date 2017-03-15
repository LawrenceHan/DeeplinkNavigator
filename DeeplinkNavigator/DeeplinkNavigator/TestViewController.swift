//
//  TestViewController.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 14/03/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, LHWURLNavigable {
    var initialAction: String?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience required init?(url: LHWURLConvertible,
                               values: [String: Any],
                               queries: [URLQueryItem]?,
                               userInfo: [AnyHashable: Any]?) {
        self.init()
        if let action = values["action"] as? String {
            initialAction = action
        }
        print("Received action: \(initialAction), queries: \(queries)")
    }
}
