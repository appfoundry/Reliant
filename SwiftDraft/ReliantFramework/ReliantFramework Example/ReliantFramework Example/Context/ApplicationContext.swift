//
//  ApplicationContext.swift
//  ReliantFramework Example
//
//  Created by Michael Seghers on 15/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import Foundation
import Reliant

struct ApplicationContext : ReliantContext {
//    let nameGenerator:NameGenerator = HardCodedNameGenerator()
    let nameGenerator:NameGenerator = OnlineNameGenerator()
    
    
    static func createContext() -> ApplicationContext {
        return ApplicationContext()
    }
}