//
//  HomeViewController.swift
//  MemberManager
//
//  Created by Administrator on 11/20/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit
import CoreData

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
        
        //UserDefaults
//        if let data = defaults.data(forKey: "Members"), let members = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Member] {
//            Save.members = members
//        }
        
        //Core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Members")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name"), let age = result.value(forKey: "age"), let sex = result.value(forKey: "sex"), let detail = result.value(forKey: "detail") {
                        let m = Member(name: name as! String, age: age as! Int, sex: sex as! String, detail: detail as! String)
                        Save.members.append(m)
                    }
                }
            }
        } catch {
            print("Error")
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
