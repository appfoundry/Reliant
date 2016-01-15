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
    
    var amount:Float {
        didSet {
            print("amount property changed from \(oldValue) to \(self.amount) on \(unsafeAddressOf(self))")
        }
    }
    
    init(nameGenerator:NameGenerator) {
        self.nameGenerator = nameGenerator
        self.amount = Float(arc4random_uniform(100))
    }
    
    func generateName(callback:(String) -> ()) -> () {
        callback("Loading name...")
        return self.nameGenerator.generateName(callback)
    }
}