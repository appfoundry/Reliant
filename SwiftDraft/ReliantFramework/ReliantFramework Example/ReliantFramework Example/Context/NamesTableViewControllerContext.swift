//
//  NamesTableViewControllerContext.swift
//  ReliantFramework Example
//
//  Created by Michael Seghers on 29/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import Foundation
import Reliant

struct NamesTableViewControllerContext : ReliantContext {
    
    
    let viewModel:NameTableViewControllerModel
    
    private init(nameGenerator:NameGenerator) {
        viewModel = NameTableViewControllerModel(nameGenerator: nameGenerator)
    }
    
    static func createContext() -> () -> NamesTableViewControllerContext {
        return {
            return NamesTableViewControllerContext(nameGenerator: relyOn(ApplicationContext).nameGenerator)
        }
    }
}

