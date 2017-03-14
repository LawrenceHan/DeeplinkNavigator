//
//  URLMatcher.swift
//  URLNavigator
//
//  Created by Sklar, Josh on 9/2/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//
// The MIT License (MIT)
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
//  LHWURLMatcher.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 14/03/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//

import Foundation

public struct LHWURLMatchComponents {
    public let pattern: String
    public let values: [String: Any]
}

open class LHWURLMatcher {
    public typealias URLValueMatcherHandler = (String) -> Any?
    private var customURLValueMatcherHandlers = [String: URLValueMatcherHandler]()
    
    open static let `default` = LHWURLMatcher()
    
    public init() {
    }
    
    open func match(
        _ url: LHWURLConvertible,
        scheme: String? = nil,
        from urlPatterns: [String]
        ) -> LHWURLMatchComponents? {
        let normalizedURLString = normalized(url, scheme: scheme).urlStringValue
        let urlPathComponents = normalizedURLString.components(separatedBy: "/")
        
        outer: for urlPattern in urlPatterns {
            // e.g. ["myapp:", "user", "<int:id>"]
            let urlPatternPathComponents = urlPattern.components(separatedBy: "/")
            let containsPathPlaceholder = urlPatternPathComponents.contains { $0.hasPrefix("<path:") }
            let containsActionPlaceholder = urlPatternPathComponents.contains { $0.hasPrefix("<action:") }
            guard containsPathPlaceholder || containsActionPlaceholder ||
                urlPatternPathComponents.count == urlPathComponents.count else {
                    continue
            }
            
            var values = [String: Any]()
            
            // e.g. ["user", "<int:id>"]
            for (i, component) in urlPatternPathComponents.enumerated() {
                guard i < urlPathComponents.count else {
                    continue outer
                }
                let info = placeholderKeyValueFrom(urlPatternPathComponent: component,
                                                        urlPathComponents: urlPathComponents,
                                                        atIndex: i)
                if let (key, value) = info {
                    values[key] = value // e.g. ["id": 123]
                    if component.hasPrefix("<path:") || component.hasPrefix("<action:") {
                        break // there's no more placeholder after <path:> or <action:>
                    }
                } else if component != urlPathComponents[i] {
                    continue outer
                }
            }
            
            return LHWURLMatchComponents(pattern: urlPattern, values: values)
        }
        
        return nil
    }
    
    open func addURLValueMatcherHandler(for valueType: String, handler: @escaping URLValueMatcherHandler) {
        customURLValueMatcherHandlers[valueType] = handler
    }
    
    /// Returns an scheme-appended `URLConvertible` if given `url` doesn't have its scheme.
    func url(withScheme scheme: String?, _ url: LHWURLConvertible) -> LHWURLConvertible {
        let urlString = url.urlStringValue
        if let scheme = scheme, !urlString.contains("://") {
            #if DEBUG
                if !urlString.hasPrefix("/") {
                    NSLog("[Warning] URL pattern doesn't have leading slash(/): '\(url)'")
                }
            #endif
            return scheme + ":/" + urlString
        } else if scheme == nil && !urlString.contains("://") {
            assertionFailure("Either matcher or URL should have scheme: '\(url)'") // assert only in debug build
        }
        
        return urlString
    }

    func normalized(_ dirtyURL: LHWURLConvertible, scheme: String? = nil) -> LHWURLConvertible {
        guard dirtyURL.urlValue != nil else {
            return dirtyURL
        }
        
        var urlString = url(withScheme: scheme, url: dirtyURL).urlStringValue
        urlString = urlString.components(separatedBy: "?")[0].components(separatedBy: "#")[0]
        urlString = replaceRegex(":/{3,}", "://", urlString)
        urlString = replaceRegex("(?<!:)/{2,}", "/", urlString)
        urlString = replaceRegex("(?<!:|:/)/+$", "", urlString)
        return urlString
    }
    
    func url(withScheme scheme: String?, url: LHWURLConvertible) -> LHWURLConvertible {
        let urlString = url.urlStringValue
        if let scheme = scheme, !urlString.contains("://") {
            #if DEBUG
                if !urlString.hasPrefix("/") {
                    NSLog("===== Warning: URL pattern doesn't have leading slash(/): '\(url)'")
                }
            #endif
            return scheme + ":/" + urlString
        } else if scheme == nil && !urlString.contains("://") {
            assertionFailure("===== Warning: either matcher or URL should have scheme: '\(url)'") // assert only in debug build
        }
        
        return urlString
    }
    
    func replaceRegex(_ pattern: String, _ repl: String, _ string: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return string }
        let range = NSMakeRange(0, string.characters.count)
        return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: repl)
    }
    
    func placeholderKeyValueFrom(
        urlPatternPathComponent component: String,
        urlPathComponents: [String],
        atIndex index: Int
        ) -> (String, Any)? {
        guard component.hasPrefix("<") && component.hasSuffix(">") else { return nil }
        
        let start = component.index(after: component.startIndex)
        let end = component.index(before: component.endIndex)
        let placeholder = component[start..<end] // e.g. "<int:id>" -> "int:id"
        
        let typeAndKey = placeholder.components(separatedBy: ":") // e.g. ["int", "id"]
        if typeAndKey.count == 0 { // e.g. component is "<>"
            return nil
        }
        if typeAndKey.count == 1 { // untyped placeholder
            return (placeholder, urlPathComponents[index])
        }
        
        var (type, key) = (typeAndKey[0], typeAndKey[1]) // e.g. ("int", "id")
        let value: Any?
        switch type {
        case "UUID": value = UUID(uuidString: urlPathComponents[index]) // e.g. 123e4567-e89b-12d3-a456-426655440000
        case "string": value = String(urlPathComponents[index]) // e.g. "123"
        case "int": value = Int(urlPathComponents[index]) // e.g. 123
        case "float": value = Float(urlPathComponents[index]) // e.g. 123.0
        case "path": value = urlPathComponents[index..<urlPathComponents.count].joined(separator: "/")
        case "action":
            value = urlPathComponents[index+1..<urlPathComponents.count].joined(separator: "/")
            key = "action"
        default:
            if let customURLValueTypeHandler = customURLValueMatcherHandlers[type] {
                value = customURLValueTypeHandler(urlPathComponents[index])
            }
            else {
                value = urlPathComponents[index]
            }
        }
        
        if let value = value {
            return (key, value)
        }
        
        return nil
    }
}
