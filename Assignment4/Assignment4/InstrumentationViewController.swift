//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {

    @IBOutlet weak var sizeText: UITextField!
    
    @IBOutlet weak var sizeStepper: UIStepper!
    
    @IBOutlet weak var periodText: UITextField!
    
    @IBOutlet weak var refreshSlider: UISlider!
    
    @IBOutlet weak var refreshOn: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func switchPushed(_ sender: UISwitch) {
        if sender.isOn {
            StandardEngine.sharedInstance.refreshRate = Double(refreshSlider.value)
        } else {
            StandardEngine.sharedInstance.refreshRate = 0
        }
    }
    
    @IBAction func sliderSlid(_ sender: UISlider) {
        let interval = Double(sender.value)
        if refreshOn.isOn {
            if StandardEngine.sharedInstance.refreshRate != interval {
                StandardEngine.sharedInstance.refreshRate = interval
            }
        }
        periodText.text = String(format: "%.1f", interval)
    }
    
    @IBAction func stepperPushed(_ sender: UIStepper) {
        let value = Int(sender.value)
        StandardEngine.sharedInstance.rows = value
        StandardEngine.sharedInstance.cols = value
        StandardEngine.sharedInstance.grid = Grid(value, value)
        sizeText.text = "\(value)"
    }

    
}

