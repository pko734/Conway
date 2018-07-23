
import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var alive: UITextField!
    @IBOutlet weak var empty: UITextField!
    @IBOutlet weak var born: UITextField!
    @IBOutlet weak var died: UITextField!
    
    var aliveCount = 0
    var emptyCount = 0
    var bornCount = 0
    var diedCount = 0
    var gridSize = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(engine(notified:)), name: EngineNoticationName, object: nil)
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
    
    @objc func engine(notified: Notification) {
        guard let userinfo = notified.userInfo, let engine = userinfo["engine"] as? EngineProtocol else { return }
        if(gridSize != engine.cols) {
            resetMyStats()
        } else {
            aliveCount += engine.grid.alive.count
            emptyCount += engine.grid.empty.count
            bornCount += engine.grid.born.count
            diedCount += engine.grid.died.count
        }
        gridSize = engine.cols
        redrawMyStats()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

