//
//  ViewController.swift
//  Assignment3
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gridView: GridView!
    
    @IBAction func clear(_ sender: Any) {
        gridView.grid = Grid(gridView.size, gridView.size)
    }
    @IBAction func step(_ sender: Any) {
        gridView.grid = gridView.grid.next()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

