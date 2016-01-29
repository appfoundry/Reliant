//
//  ViewControllerViewModel.swift
//  ReliantFramework Example
//
//  Created by Michael Seghers on 15/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import Foundation


class ViewControllerViewModel {
    
    private let nameGenerator:NameGenerator
    private let tabBarControllerViewModel:TabBarControllerViewModel
    
    init(nameGenerator:NameGenerator, tabBarControllerViewModel:TabBarControllerViewModel) {
        self.nameGenerator = nameGenerator
        self.tabBarControllerViewModel = tabBarControllerViewModel
    }
    
    func generateName(callback:(String?, ErrorType?) -> ()) -> () {
        callback("Loading name...", nil)
        return self.nameGenerator.generateName() { [weak self] in
            callback($0.map { return ((self?.tabBarControllerViewModel.name ?? "Unknown") + " says hi to " + $0) }, $1)
        }
    }
}