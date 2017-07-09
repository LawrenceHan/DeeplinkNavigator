//
//  Titlable.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 2017/7/9.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import UIKit

public protocol Titlable {
    var identifier: String? { get }
}

extension Titlable where Self: UIViewController {
    var identifier: String? {
        return self.description
    }
}
