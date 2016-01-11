//
//  GreeterAndWaver.swift
//  ReliantFramework
//
//  Created by Michael Seghers on 11/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import Foundation

protocol Greeter {
    func greet(name:String) -> String
}

protocol Waver {
    func wave(reason:String) -> String
}

struct BothWorlds : Greeter, Waver {
    let prefix:String
    
    init(prefix:String) {
        self.prefix = prefix
    }
    
    func greet(name: String) -> String {
        return "\(prefix) \(name)"
    }
    
    func wave(reason: String) -> String {
        return "Waving \(reason)"
    }
}
