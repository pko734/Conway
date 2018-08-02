//
//  SecondViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate, GridViewDataSource {
    var size:Int {
        get { return StandardEngine.sharedInstance.size }
        set { StandardEngine.sharedInstance.size = newValue }
    }
    
    subscript(pos: Position) -> CellState {
        get { return StandardEngine.sharedInstance.grid[pos] }
        set { StandardEngine.sharedInstance.grid[pos] = newValue }
    }

    @IBOutlet weak var gridView: GridView!
    
    @IBAction func step(_ sender: Any) {
        _ = StandardEngine.sharedInstance.step()
    }
    
    func engineDidUpdate(engine: EngineProtocol) {
        self.gridView.size = engine.cols
        self.gridView.setNeedsDisplay()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        StandardEngine.sharedInstance.delegate = self
        gridView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

