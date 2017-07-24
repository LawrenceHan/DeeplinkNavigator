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
//  LifeCycleable.swift
//  DeeplinkNavigator
//
//  Created by song on 2017/7/15.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import UIKit

//MARK: - Init方法初始化 InitLifeCycleable可以接在ViewController的头上

protocol InitLifeCycleable : LifeCycleable, InitNavigable{
    
}

//MARK: - Xib方法初始化 XibLifeCycleable可以接在ViewController的头上 如果使用默认初始化必须保证Identifier为类名

protocol XibLifeCycleable : LifeCycleable, XibNavigable{
    
}

//MARK: - Storyboard方法初始化 StoryboardLifeCycleable可以接在ViewController的头上 
          //如果使用默认初始化必须保证Identifier为类名.而且只能是在Main-Storyboard上

public protocol StoryboardLifeCycleable : LifeCycleable, StoryboardNavigable{
    
     static func viewControllerFromStoryBoard(navigation: DeeplinkNavigation) -> UIViewController?
}

extension InitLifeCycleable  where Self : UIViewController {
    
    init?(navigation: DeeplinkNavigation) {
        self.init()
        self.navigation = navigation
    }
}

extension XibLifeCycleable  where Self : UIViewController {
    
    static func viewControllerFromXib(navigation: DeeplinkNavigation) -> UIViewController?{
        let vc = self.init(nibName: String(describing: self), bundle: nil)
        vc.navigation = navigation
        return  vc
    }
}

extension StoryboardLifeCycleable  where Self : UIViewController {
    
    public static func viewControllerFromStoryBoard(navigation: DeeplinkNavigation) -> UIViewController?{

        let sb = UIStoryboard(name: "RenterStoryBoard", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: String(describing: self)) as? Self{
            vc.navigation = navigation
            return  vc
        }
        
        return nil
    }
}

//MARK: - 内部使用加了生命周期 外界不用调用

public protocol LifeCycleable : class {
    
    var navigation:DeeplinkNavigation?{ get set }
    
    /*! 会在ViewController中调用super.viewDidLoad()时调用 */
    func navigationLoad(parameter: [String: Any]?,needRequest:Bool)
}

private var navigationKey: Void?

extension LifeCycleable {
    
    public var navigation:DeeplinkNavigation?{
        get{
            return objc_getAssociatedObject(self, &navigationKey) as? DeeplinkNavigation
        }
        set(newValue){
            objc_setAssociatedObject(self, &navigationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

