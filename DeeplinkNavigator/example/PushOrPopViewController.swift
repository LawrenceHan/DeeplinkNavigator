//
//  PushOrPopViewController.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 11/07/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//

import UIKit

final class PushOrPopViewController: UIViewController {
    enum VCColor: String {
        case red = "/StoryboardNavigable"
        case green = "/XibNavigable"
        case blue = "/InitNavigable"
        case test = "/test"
        case none = "/PushOrPop"
    }
    
    var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        for i in 0..<5 {
            let button = UIButton(type: .roundedRect)
            button.frame = CGRect(x: (screenSize.width-100.0)/2, y: 64.0+CGFloat(i)*(20+44)+20, width: 100.0, height: 44.0)
            button.tag = i
            button.addTarget(self, action: #selector(popTo), for: .touchUpInside)
            switch i {
            case 0:
                button.setTitle("pop to red", for: .normal)
            case 1:
                button.setTitle("pop to green", for: .normal)
            case 2:
                button.setTitle("pop to blue", for: .normal)
            case 3:
                button.setTitle("pop to self", for: .normal)
            case 4:
                button.setTitle("push new vc", for: .normal)
            default:
                button.setTitle("pop to self", for: .normal)
            }
            view.addSubview(button)
        }
    }
    
    @objc func popTo(_ sender: UIButton) {
        let color: VCColor
        switch sender.tag {
        case 0:
            color = .red
        case 1:
            color = .green
        case 2:
            color = .blue
        case 3:
            color = .none
        case 4:
            color = .test
        default:
            color = .none
        }
        Navigator.pushOrPopTo(color.rawValue)
    }
}

extension PushOrPopViewController: InitNavigable {
    convenience init?(navigation: DeeplinkNavigation) {
        self.init()
    }
}
