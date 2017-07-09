// The MIT License (MIT)
//
// Copyright (c) 2016 Suyeol Jeon (xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//  LHWURLNavigable.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 14/03/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//

import UIKit

/// A type that can be initialized with URLs and values.
///
/// - seealso: `LHWURLNavigator`
public protocol LHWURLNavigable {
    /// Creates an instance with specified LHWNavigation and returns it. Returns `nil` if the LHWNavigation
    /// and the values are not met the condition to create an instance.
    ///
    /// For example, to validate whether a value of `id` is an `Int`:
    ///
    ///     convenience init?(navigation: LHWNavigation) {
    ///       guard let id = navigation.values["id"] as? Int else {
    ///         return nil
    ///       }
    ///       self.init(id: id)
    ///     }
    ///
    /// Do not call this initializer directly. It is recommended to use with `URLNavigator`.
    ///
    /// - parameter navigation: The navigation information that contains url, values and context.
    init?(navigation: LHWNavigation)
    
    
    /// Creates an instance with specified LHWNavigation and returns it. Returns `nil` if the LHWNavigation
    /// and the values are not met the condition to create an instance.
    ///
    /// - Returns: A UIViewController from a Storyboard
    static func viewControllerFromStoryBoard(navigation: LHWNavigation) -> UIViewController?
    
    /// Creates an instance with specified LHWNavigation and returns it. Returns `nil` if the LHWNavigation
    /// and the values are not met the condition to create an instance.
    ///
    /// - Returns: A UIViewController from an Xib
    static func viewControllerFromXib(navigation: LHWNavigation) -> UIViewController?
}

public extension LHWURLNavigable {
    init?(navigation: LHWNavigation) {
        return nil
    }
    
    static func viewControllerFromStoryBoard(navigation: LHWNavigation) -> UIViewController? {
        return nil
    }
    
    static func viewControllerFromXib(navigation: LHWNavigation) -> UIViewController? {
        return nil
    }
}

public protocol StoryboardNavigable: LHWURLNavigable {
    static func viewControllerFromStoryBoard(navigation: LHWNavigation) -> UIViewController?
}

public protocol XibNavigable: LHWURLNavigable {
    static func viewControllerFromXib(navigation: LHWNavigation) -> UIViewController?
}

public protocol InitNavigable: LHWURLNavigable {
    init?(navigation: LHWNavigation)
}
