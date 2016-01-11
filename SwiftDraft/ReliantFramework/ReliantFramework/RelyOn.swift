//
//  RelyOn.swift
//  ReliantFramework
//
//  Created by Michael Seghers on 11/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import Foundation

class ContextCache {
    static let sharedInstance:ContextCache = ContextCache()
    var cache:Dictionary<String, Any> = Dictionary()
}

public func relyOn<T:ReliantContext>(type:T.Type) -> T.ContextType {
    if let result = ContextCache.sharedInstance.cache[String(type)] {
        return result as! T.ContextType
    } else {
        let result = type.createContext()
        ContextCache.sharedInstance.cache[String(type)] = result
        return result;
    }
}