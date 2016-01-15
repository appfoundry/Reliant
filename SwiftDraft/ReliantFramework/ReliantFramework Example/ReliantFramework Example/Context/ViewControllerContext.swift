//
//  ViewControllerContext.swift
//  ReliantFramework Example
//
//  Created by Michael Seghers on 15/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import Foundation
import Reliant

struct ViewControllerContext : ReliantContext {
    let viewModel:ViewControllerViewModel
    
    init(nameGenerator:NameGenerator) {
        viewModel = ViewControllerViewModel(nameGenerator: nameGenerator)
    }
    
    static func createContext() -> () -> ViewControllerContext {
        return {
            return ViewControllerContext(nameGenerator: relyOn(ApplicationContext).nameGenerator)
        }
    }
}
