//
//  TabBarControllerContext.swift
//  ReliantFramework Example
//
//  Created by Michael Seghers on 27/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import Foundation
import Reliant

struct TabBarControllerContext : ReliantContext {
    static func createContext() -> () -> TabBarControllerContext {
        return {
            return TabBarControllerContext()
        }
    }
    
    let viewModel = TabBarControllerViewModel()
}
