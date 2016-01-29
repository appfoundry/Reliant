//
//  ViewController.swift
//  ReliantFramework Example
//
//  Created by Michael Seghers on 15/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import UIKit
import Reliant

class NameViewController: UIViewController {
    @IBOutlet var label:UILabel!
    
    //The ViewControllerContext is a so-called Prototype context
    //A prototype context returns a function, instead of an object
    //The returned function depends on your needs, but it will generally 
    //return an object when you call it, in this case it returns a ViewControllerContext
    var context:ViewControllerContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadContext(self.parentViewController)
    }
    
    func loadData() {
        self.refreshName()
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        self.loadContext(parent)
    }
    
    @IBAction func refreshName() {
        context?.viewModel.generateName() { [weak self] (result, error) in
            if let err = error as? NSError {
                self?.label.text = err.localizedDescription
            } else {
                self?.label.text = result
            }
        }
    }
    
    private func loadContext(parent:UIViewController?) {
        if context == nil {
            context = (tabBarController as? ContextHoldingTabBarController).map {
                return relyOn(ViewControllerContext)($0.context)
            }
            self.loadData()
        }
    }
}

