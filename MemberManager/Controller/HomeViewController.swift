//
//  HomeViewController.swift
//  MemberManager
//
//  Created by Administrator on 11/20/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let defaults = UserDefaults.standard
    
    @IBAction func handleLogout(_ sender: Any) {
        defaults.removeObject(forKey: "user")
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
//        if defaults.object(forKey: "Members") != nil {
////            Save.members = defaults.object(forKey: "Members") as! [Member]
//
//        }
        
        if let data = defaults.data(forKey: "Members"), let members = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Member] {
            Save.members = members
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: Notification.Name.init(rawValue: "AddMember"), object: nil)
    }
    
    @objc func reloadTableView(_ notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
}




extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Save.members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemberTableViewCell
        cell.member = Save.members[indexPath.row]
        return cell
    }
    
    
}
