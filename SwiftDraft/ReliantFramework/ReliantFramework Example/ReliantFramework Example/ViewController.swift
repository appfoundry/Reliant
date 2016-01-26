//
//  ViewController.swift
//  ReliantFramework Example
//
//  Created by Michael Seghers on 15/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import UIKit
import Reliant

class ViewController: UIViewController {
    @IBOutlet var label:UILabel!
    @IBOutlet var slider:UISlider!
    
    //The ViewControllerContext is a so-called Prototype context
    //A prototype context returns a function, instead of an object
    //The returned function depends on your needs, but it will generally 
    //return an object when you call it, in this case it returns a ViewControllerContext
    let context = relyOn(ViewControllerContext)()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = context.viewModel.amount
        self.refreshName()
    }
    
    @IBAction func refreshName() {
        context.viewModel.generateName() { [weak self] (result, error) in
            if let err = error as? NSError {
                self?.label.text = err.localizedDescription
            } else {
                self?.label.text = result
            }
        }
    }
    
    @IBAction func sliderValueChanged(slider:UISlider) {
        context.viewModel.amount = slider.value
    }

}

