//
//  URLNavigator
//
//  Created by Suyeol Jeon on 19/04/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

//  MIT License
//
//  Copyright (c) 2017 Lawrence
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  DeeplinkNavigation.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 2017/7/9.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import Foundation

public typealias MappingContext = Any
public typealias NavigationContext = Any

public struct DeeplinkNavigation {
    /// The URL which is used to create an instance.
    public let url: DeeplinkConvertible
    
    /// The URL pattern placeholder values by placeholder names. For example, if the URL pattern is
    /// `myapp://user/<int:id>` and the given URL is `myapp://user/123`, values will be `["id": 123]`.
    public let values: [String: Any]
    
    /// The context from mapping a view controller.
    public let mappingContext: MappingContext?
    
    /// The context from pushing or presenting a view controller.
    public let navigationContext: NavigationContext?
    
    /// Designated initializer
    public init(url: DeeplinkConvertible,
                values: [String: Any],
                mappingContext: MappingContext?,
                navigationContext: NavigationContext?) {
        self.url = url
        self.values = values
        self.mappingContext = mappingContext
        self.navigationContext = navigationContext
    }
}

