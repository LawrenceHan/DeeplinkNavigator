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
//  Navigationparamterable.swift
//  DeeplinkNavigator
//
//  Created by song on 2017/7/17.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import UIKit

let MGPageRequestKey = "needRequestForPage"

//MARK: - get parameter and needRequest

protocol Navigationparamterable {
    
    /*! 传的参数 */
    var parameter : [String : Any]? { get }
    
    /*! 单独字段判断是否需要刷新 */
    var needRequest : Bool { get }
}

extension DeeplinkNavigation : Navigationparamterable {
    
    var needRequest: Bool {
        get {
            return requestValue()
        }
    }
    
    var parameter: [String : Any]? {
        get {
            return param()
        }
    }
    
    fileprivate func requestValue() -> Bool {
        
        var requestValue : Bool = true
        
        if let requestString = url.queryParameters[MGPageRequestKey]
        {
            
            requestValue = (requestString as NSString).boolValue
        }
        
        if let request = navigationContext as? NSNumber
        {
            requestValue = request.boolValue
        }
        else if let dict = navigationContext as? [String : Any] ,
            let request = dict[MGPageRequestKey] as? NSNumber
        {
            requestValue = request.boolValue
        }
        
        return requestValue
    }
    
    fileprivate func param() -> [String:Any]? {
        
        var param : [String:Any] = url.queryParameters
        
        if let dict = navigationContext as? [String : Any]
        {
            for (key, value) in dict {
                param[key] = value
            }
        }
        
        if param.keys.contains(MGPageRequestKey) {
            param.removeValue(forKey: MGPageRequestKey)
        }
        
        return param
    }
    
}
