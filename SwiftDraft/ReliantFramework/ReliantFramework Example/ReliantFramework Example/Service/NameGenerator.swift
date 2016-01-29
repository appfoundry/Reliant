//
//  NameGenerator.swift
//  ReliantFramework Example
//
//  Created by Michael Seghers on 15/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import Foundation

protocol NameGenerator {
    func generateName(callback:(String?, ErrorType?) -> ()) -> ()
    func generateNumberOfNames(number:UInt, callback: ([String]?, ErrorType?) -> ())
}