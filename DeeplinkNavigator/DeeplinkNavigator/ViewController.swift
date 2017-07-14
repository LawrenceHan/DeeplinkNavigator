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
        Navigator.scheme = "mg"
        Navigator.map("/alert", self.alert)
//        let URL = "/userdetail/action:/mg/userdetail/pulltorefresh/?uid=4&mid=6"
//        let URL = "/alert?title=Hi&message=Hello World"
//        print("Navigator: Push \(URL)")
//        Navigator.open(URL)
        
        let button: UIButton = UIButton(type: .system)
        button.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
        button.setTitle("Show Alert", for: .normal)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        view.addSubview(button)
    }

    func showAlert() {
//        let URL = "mg://alert?title=Hi&message=Hello World"
        let URL = "mg://userdetail/action:/mg/userdetail/pulltorefresh/?uid=111"
//        let URL = "mogo://host/path?title={\"head\":{\"code\":\"10000\"}}"
//        let json = URL.queryParameters["title"]!
//        let data = json.data(using: .utf8)!
//        let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
//        print("Navigator: Push \(URL)")
        Navigator.push(URL)
//        Navigator.open(URL)
    }
    
    func alert(URL: LHWURLConvertible, values: [String: Any]) -> Bool {
        let title = URL.queryParameters["title"]
        let message = URL.queryParameters["message"]
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        Navigator.present(alertController)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

