//
//  LeaderBoardVC.swift
//  Blastroid
//
//  Created by Ranjith R D on 19/04/18.
//  Copyright © 2018 Ranjith R Dixit. All rights reserved.
//

import UIKit
import SpriteKit
import VCBoss

class LeaderBoardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableRefreshControl: UIRefreshControl = {
        let tableRefreshControl = UIRefreshControl()
        tableRefreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                      for: UIControlEvents.valueChanged)
        return tableRefreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getData(nil, false)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    @IBAction func back(_ sender: Any) {
        pauseVC.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        gameVC.gscene.scene?.view?.isPaused = false
        gameVC.gscene.continueGame()
        do {
            try pauseVC.vcboss.dismiss(self, animated: true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.refreshControl = tableRefreshControl
        getData(self, true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedLeaders().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LeaderCell
        var l = Leader()
        if indexPath.row >= sortedLeaders().count {
            l = sortedLeaders()[indexPath.row - 1]
        } else {
            l = sortedLeaders()[indexPath.row]
        }
        cell.nameLabel.text = l.name
        cell.scoreLabel.text = String(l.score)
        return cell
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

