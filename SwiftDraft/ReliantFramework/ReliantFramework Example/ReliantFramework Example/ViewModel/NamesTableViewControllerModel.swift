//
//  NamesTableViewControllerModel.swift
//  ReliantFramework Example
//
//  Created by Michael Seghers on 29/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import Foundation

class NameTableViewControllerModel {
    private let nameGenerator:NameGenerator
    var generatedNames:[String]? = nil
    
    init(nameGenerator:NameGenerator) {
        self.nameGenerator = nameGenerator
    }
    
    func generateNames(callback:([String]?, ErrorType?) -> ()) -> () {
        return self.nameGenerator.generateNumberOfNames(25) { [weak self] (names, error) in
            self?.generatedNames = names;
            callback(names, error)
        }
    }
}