//
//  ConfigurationTableViewController.swift
//  FinalProject
//
//  Created by Paul Oehler on 8/2/18.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

class ConfigurationTableViewController: UITableViewController {

    var fetcher = Fetcher()
    var configurations: [Configuration]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(addConfig(notified:)), name: AddConfigNotificationName, object: nil)
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func addConfig(notified: Notification) {
        //guard let userinfo = notified.userInfo, let size = userinfo["size"] as? Int else { return }
        let configuration = Configuration(title: "[new config]", contents: nil)
        configurations.append(configuration)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchData() {
        guard let url = URL(string: ConfigurationURL) else { return }
        fetcher.fetch(url: url) { (response) in
            let op = BlockOperation {
                switch response {
                case .success(let data):
                    do {
                        self.configurations = try JSONDecoder().decode([Configuration].self, from: data)
                        self.tableView.reloadData()
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let msg):
                    print("\(msg)")
                }
            }
            OperationQueue.main.addOperation(op)
        }
    }
    
    @IBAction func fetchButton(_ sender: UIButton) {
        fetchData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (configurations ?? []).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Configuration", for: indexPath)

        cell.textLabel?.text = configurations[indexPath.row].title ?? "Mystery"

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let destination = segue.destination as? GridEditorViewController else { return }
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        destination.configuration = configurations[indexPath.row]
        destination.updateClosure = { (configuration) in
            self.configurations[indexPath.row] = configuration
            self.tableView.reloadData()
        }
        destination.deleteClosure = { () in
            self.configurations.remove(at: indexPath.row);
            self.tableView.reloadData()
        }
    }

}
