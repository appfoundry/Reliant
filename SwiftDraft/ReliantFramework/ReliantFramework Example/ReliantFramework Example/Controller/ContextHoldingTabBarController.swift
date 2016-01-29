//
//  ContextHoldingTabBarController.swift
//  ReliantFramework Example
//
//  Created by Michael Seghers on 27/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import UIKit
import Reliant

protocol NameReceiver {
    func receiveName(name:String)
}

class ContextHoldingTabBarController: UITabBarController, ReliantContextHolder, NameReceiver {
    let context = relyOn(TabBarControllerContext)()
        
    func receiveName(name: String) {
        self.title = name
        context.viewModel.name = name
    }
}
