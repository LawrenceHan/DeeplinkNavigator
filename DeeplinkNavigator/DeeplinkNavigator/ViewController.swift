//
//  ViewController.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 13/03/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let URL = "mg://userdetail/?action=mg/userdetail/pullrefresh&action=mg/userdetail/update"
        let URL = "mg://userdetail/action:/mg/userdetail/pulltorefresh/"
        print("Navigator: Push \(URL)")
        Navigator.push(URL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

