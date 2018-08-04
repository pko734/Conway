//
//  SecondViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(engine(notified:)), name: EngineNoticationName, object: nil)
    }
    
    @objc func engine(notified: Notification) {
        guard let userinfo = notified.userInfo, let engine = userinfo["engine"] as? Engine else { return }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

