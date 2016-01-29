//
//  ReliantContext.swift
//  ReliantFramework
//
//  Created by Michael Seghers on 11/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import Foundation

public protocol ReliantContext {
    typealias ContextType
    
    static func createContext() -> ContextType
}


public protocol ReliantContextHolder {
    typealias ContextType : ReliantContext
    var context:ContextType { get }
}
