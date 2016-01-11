//
//  ReliantFrameworkTestsHelper.swift
//  ReliantFramework
//
//  Created by Michael Seghers on 11/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import Foundation

class ReliantFrameworkTestsHelper {
    static let sharedInsance = ReliantFrameworkTestsHelper()
    
    var initCalled:Int = 0;
    
    func reset() {
        initCalled = 0;
    }
    
    func markInitCalled() {
        initCalled++
    }
}