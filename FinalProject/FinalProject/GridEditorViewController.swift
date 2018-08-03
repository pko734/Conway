//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Paul Oehler on 8/2/18.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

typealias GridEditorUpdateClosure = (Configuration) -> Void

class GridEditorViewController: UIViewController, GridViewDataSource, EngineDelegate {
    var configuration: Configuration!
    var updateClosure: GridEditorUpdateClosure?
    var engine: Engine = Engine()
    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var nameTextField: UITextField!
 
    var size:Int {
        get { return engine.size }
        set { engine.size = newValue }
    }
    
    subscript(pos: GridPosition) -> CellState {
        get { return engine.grid[pos.row, pos.col] }
        set { engine.grid[pos.row, pos.col] = newValue }
    }

    func engine(didUpdate: Engine) {
        gridView.size = didUpdate.size
        gridView.setNeedsDisplay()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.dataSource = self
        engine.delegate = self
        nameTextField.text = configuration?.title
        let maxSize = (configuration?.contents?.flatMap { $0 }.reduce(Int.min) { max($0, $1) }) ?? 10
        engine.size = maxSize * 2
        engine.grid = Grid(maxSize * 2, maxSize * 2)
        configuration?.contents?.forEach {
            engine.grid[$0[0], $0[1]] = .alive
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let newTitle = nameTextField.text else { return }
        let newConfig = Configuration(title: newTitle, contents: getActiveGridPositions())
        let tmp = getActiveGridPositions()
        updateClosure?(newConfig)
    }
    
    func getActiveGridPositions() -> [[Int]]? {
        return engine.grid.living.map {
            [$0.row, $0.col]
        }
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
