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
    
    let context = relyOn(ViewControllerContext)()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = context.viewModel.amount
        self.refreshName()
    }
    
    @IBAction func refreshName() {
        context.viewModel.generateName() { [weak self] in
            self?.label.text = $0
        }
    }
    
    @IBAction func sliderValueChanged(slider:UISlider) {
        context.viewModel.amount = slider.value
    }

}

