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
    
    init(nameGenerator:NameGenerator, parentContext:TabBarControllerContext) {
        viewModel = ViewControllerViewModel(nameGenerator: nameGenerator, tabBarControllerViewModel:parentContext.viewModel)
    }
    
    static func createContext() -> (TabBarControllerContext) -> ViewControllerContext {
        return {
            return ViewControllerContext(nameGenerator: relyOn(ApplicationContext).nameGenerator, parentContext: $0)
        }
    }
}
