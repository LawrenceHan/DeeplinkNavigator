//
//  AppDelegate.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 13/03/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Navigator.scheme = "navigator"
        Navigator.map("/StoryboardNavigable", StoryboardViewController.self, context: "I am a StoryboardViewController")
        Navigator.map("/XibNavigable", XibViewController.self, context: "I am a XibViewController")
        Navigator.map("/InitNavigable", InitViewController.self, context: "I am a InitViewController")
        Navigator.map("navigator://<path>") { (url, values) -> Bool in
            return Navigator.push(url) != nil
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if Navigator.open(url) {
            return true
        }
        return false
    }
}

