//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate {
    @IBOutlet weak var gridView: GridView!
    
    func engine(didUpdate: Engine) {
        gridView.size = didUpdate.size
        gridView.setNeedsDisplay()
    }
    
    var size:Int {
        get { return Engine.sharedInstance.size }
        set { Engine.sharedInstance.size = newValue }
    }
    
    subscript(pos: GridPosition) -> CellState {
        get { return Engine.sharedInstance.grid[pos.row, pos.col] }
        set { Engine.sharedInstance.grid[pos.row, pos.col] = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.dataSource = self
        Engine.sharedInstance.delegate = self
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(engine(notified:)), name: GridEditorDisplayedNotification, object: nil)
    }
    
    @objc func engine(notified: Notification) {
        guard let userinfo = notified.userInfo, let engine = userinfo["engine"] as? Engine else { return }
        Engine.sharedInstance.size = engine.size
        Engine.sharedInstance.grid = engine.grid
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

