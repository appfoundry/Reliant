//
//  ReliantFrameworkTests.swift
//  ReliantFrameworkTests
//
//  Created by Michael Seghers on 11/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import XCTest
@testable import Reliant


struct PrototypedContext : ReliantContext {
    private let bothWorlds:BothWorlds
    
    let waver:Waver
    let greeter:Greeter
    
    init(prefix:String) {
        ReliantFrameworkTestsHelper.sharedInsance.markInitCalled()
        bothWorlds = BothWorlds(prefix:prefix)
        waver = bothWorlds
        greeter = bothWorlds
    }
    
    static func createContext() -> (String) -> (PrototypedContext) {
        return {
            return PrototypedContext(prefix: $0)
        }
    }
}

struct GreeterNeeding {
    private let greeter:Greeter
    
    init(greeter:Greeter) {
        self.greeter = greeter
    }
    
    func decorateGreeting() -> String {
        return "Oh! \(greeter.greet("Needy"))"
    }
}

struct ContextNeedingContext : ReliantContext {
    private let otherContext = relyOn(SimpleValueContext)
    let needy:GreeterNeeding;
    
    init() {
        needy = GreeterNeeding(greeter: otherContext.greeter)
    }
    
    static func createContext() -> ContextNeedingContext {
        return ContextNeedingContext()
    }
}





class ReliantFrameworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        ReliantFrameworkTestsHelper.sharedInsance.reset()
        ContextCache.sharedInstance.cache = Dictionary()
    }
    
    func testRelyOnReturnsSameInsanceEveryTimeForReferenceTypes() {
        let context = relyOn(SimpleReferenceContext)
        let otherContext = relyOn(SimpleReferenceContext)
        XCTAssertTrue(context === otherContext, "Rely on didn't terurn the same instance!");
    }
    
    func testRelyOnReturnDoesntCallInitMoreThenOnceForValueTypes() {
        _ = relyOn(SimpleValueContext)
        _ = relyOn(SimpleValueContext)
        XCTAssertEqual(ReliantFrameworkTestsHelper.sharedInsance.initCalled, 1);
    }
    
    func testCanRelyOnOtherContextInOtherContext() {
        let needed = relyOn(ContextNeedingContext)
        XCTAssertEqual(needed.needy.decorateGreeting(), "Oh! Hello Needy")
    }
    
    
        
}
