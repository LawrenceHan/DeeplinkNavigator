//
//  LHWNavigation.swift
//  URLNavigator
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

//
//  LHWNavigation.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 2017/7/9.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import Foundation

public typealias MappingContext = Any
public typealias NavigationContext = Any

public struct LHWNavigation {
    /// The URL which is used to create an instance.
    public let url: LHWURLConvertible
    
    /// The URL pattern placeholder values by placeholder names. For example, if the URL pattern is
    /// `myapp://user/<int:id>` and the given URL is `myapp://user/123`, values will be `["id": 123]`.
    public let values: [String: Any]
    
    /// The context from mapping a view controller.
    public let mappingContext: MappingContext?
    
    /// The context from pushing or presenting a view controller.
    public let navigationContext: NavigationContext?
}

