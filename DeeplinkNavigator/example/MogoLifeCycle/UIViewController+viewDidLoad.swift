//
//
//                        _____
//                       / ___/____  ____  ____ _
//                       \__ \/ __ \/ __ \/ __ `/
//                      ___/ / /_/ / / / / /_/ /
//                     /____/\____/_/ /_/\__, /
//                                      /____/
//
//                .-~~~~~~~~~-._       _.-~~~~~~~~~-.
//            __.'              ~.   .~              `.__
//          .'//                  \./                  \\`.
//        .'//                     |                     \\`.
//      .'// .-~"""""""~~~~-._     |     _,-~~~~"""""""~-. \\`.
//    .'//.-"                 `-.  |  .-'                 "-.\\`.
//  .'//______.============-..   \ | /   ..-============.______\\`.
//.'______________________________\|/______________________________`.
//
//
//  UIViewControllerExtensions.swift
//  DeeplinkNavigator
//
//  Created by song on 2017/7/15.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import UIKit
import ReactiveCocoa

//MARK: - 偷换系统方法啦

func swizzleMethod(_ cls: Swift.AnyClass!,_ originalSelector:Selector,_ swizzledSelector:Selector){
    DispatchQueue.once(token: NSUUID().uuidString) {
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        
        let didAddMethod: Bool = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}


extension DispatchQueue {
    private static var onceTracker = [String]()
    
    open class func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}

//MARK: - open class func initialize() Swift以后会不让使用  所以只能用这种取巧的方法啦

extension UIApplication{
    
    fileprivate static let runOne:Void = {
        UIViewController.awake()
    }()
    
    // Called before applicationDidFinishLaunching
    open override var next : UIResponder? {
        UIApplication.runOne
        return super.next
    }
}

//MARK: - 偷换 viewDidLoad方法

extension UIViewController{
   
    public static func awake(){
        swizzleMethod(self, #selector(UIViewController.loadView), #selector(UIViewController.mg_loadView))
    }
    
    func mg_loadView() {
        self.mg_loadView()
        if let lifeCycle = self as? LifeCycleable{
            self.rac_signal(for: #selector(viewDidLoad)).subscribeNext {
                [weak lifeCycle](_) in
                guard let `lifeCycle` = lifeCycle else { return }
                if let navigation = lifeCycle.navigation{
                    lifeCycle.navigationLoad(parameter: navigation.parameter, needRequest: navigation.needRequest)
                    lifeCycle.navigation = nil
                }
            }
        }
    }
    
}

