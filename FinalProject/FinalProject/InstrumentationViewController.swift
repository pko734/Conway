//
//  InstrumentationViewController.swift
//  FinalProject
//
//  Created by Paul Oehler on 8/2/18.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {

    @IBOutlet weak var sizeText: UITextField!
    @IBOutlet weak var speedText: UITextField!
    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var speedSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleTimer(_ sender: UISwitch) {
        Engine.sharedInstance.interval = sender.isOn ? Double(speedSlider.value) : 0.0
    }
    
    @IBAction func sliderSlid(_ sender: UISlider) {
        let interval = Double(sender.value)
        if onSwitch.isOn {
            if Engine.sharedInstance.interval != interval {
                Engine.sharedInstance.interval = interval
            }
        }
        speedText.text = String(format: "%.1f", interval)
    }
    
    @IBAction func stepperPushed(_ sender: UIStepper) {
        let value = Int(sender.value)
        Engine.sharedInstance.size = value
        Engine.sharedInstance.grid = Grid(value, value)
        sizeText.text = "\(value)"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
