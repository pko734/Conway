//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

let SimulationSavedNotification = Notification.Name(rawValue: "SimulationSavedDisplayed")
let SimResetNotificationName = Notification.Name(rawValue: "SimulationReset")

class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate, UITextFieldDelegate {
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var configNameText: UITextField!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configNameText.text = ""
        configNameText.placeholder = "Give me a name!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.dataSource = self
        Engine.sharedInstance.delegate = self
        configNameText.delegate = self
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(engine(notified:)), name: GridEditorPublishNotification, object: nil)
        if let gridSize = restoredGridSize, let config = restoredConfig {
            Engine.sharedInstance.size = gridSize
            var grid = Grid(gridSize, gridSize)
            config.contents?.forEach {
                grid[$0[0], $0[1]] = .alive
            }
            Engine.sharedInstance.grid = grid
            configNameText.text = config.title
            gridView.setNeedsDisplay()
        }
    }
    
    @objc func engine(notified: Notification) {
        guard let userinfo = notified.userInfo, let engine = userinfo["engine"] as? Engine else { return }
        Engine.sharedInstance.size = engine.size
        Engine.sharedInstance.grid = engine.grid
    }

    @IBAction func step(_ sender: UIButton) {
        _ = Engine.sharedInstance.step()
    }
    
    @IBAction func reset(_ sender: UIButton) {
        Engine.sharedInstance.grid = Grid(Engine.sharedInstance.size, Engine.sharedInstance.size)
        let nc = NotificationCenter.default
        nc.post(name: SimResetNotificationName, object: nil, userInfo: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        if configNameText.text!.isEmpty {
            let alert = UIAlertController(title: "Alert", message: "Please supply a name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let configuration = Configuration(title: configNameText.text, contents: getActiveGridPositions())
        let recode = try! JSONEncoder().encode(configuration)
        let defaults = UserDefaults.standard
        defaults.set(recode, forKey: "simulationConfiguration")
        defaults.set(Engine.sharedInstance.size, forKey: "gridSize")
        let nc = NotificationCenter.default
        let info = ["configuration": configuration]
        nc.post(name: SimulationSavedNotification, object: nil, userInfo: info)
    }
    
    func getActiveGridPositions() -> [[Int]]? {
        return Engine.sharedInstance.grid.living.map {
            [$0.row, $0.col]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

