//
//  SecondViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    var aliveCount = 0
    var emptyCount = 0
    var bornCount = 0
    var diedCount = 0
    var gridSize = 0

    @IBOutlet weak var alive: UITextField!
    @IBOutlet weak var empty: UITextField!
    @IBOutlet weak var born: UITextField!
    @IBOutlet weak var died: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(engine(notified:)), name: EngineNoticationName, object: nil)
        nc.addObserver(self, selector: #selector(simReset(notified:)), name: SimResetNotificationName, object: nil)
    }
    
    @objc func engine(notified: Notification) {
        guard let userinfo = notified.userInfo, let engine = userinfo["engine"] as? Engine else { return }
        if(gridSize != engine.size) {
            resetMyStats()
        } else {
            aliveCount += engine.grid.alive.count
            emptyCount += engine.grid.empty.count
            bornCount += engine.grid.born.count
            diedCount += engine.grid.died.count
        }
        gridSize = engine.size
        redrawMyStats()
    }

    @objc func simReset(notified: Notification) {
        resetMyStats()
        redrawMyStats()
    }
        @IBAction func resetStats(_ sender: UIButton) {
        resetMyStats()
        redrawMyStats()
    }
    
    func resetMyStats() {
        aliveCount = 0
        emptyCount = 0
        bornCount = 0
        diedCount = 0
    }
    
    func redrawMyStats() {
        alive.text = "\(aliveCount)"
        empty.text = "\(emptyCount)"
        born.text = "\(bornCount)"
        died.text = "\(diedCount)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

