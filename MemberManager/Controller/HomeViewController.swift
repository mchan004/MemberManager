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
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func ToggleSideMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        print("ToggleSideMenu")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        notificationCenter()
        
        
    }
    
    
    
    func setupTableView() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsMultipleSelectionDuringEditing = true
        
        //UserDefaults
//        if let data = defaults.data(forKey: "Members"), let members = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Member] {
//            Save.members = members
//        }
        
        /////////////
        //Core data//
        /////////////
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Members")
        request.returnsObjectsAsFaults = false
        
        do {
            Save.membersCoreData = try context.fetch(Members.fetchRequest())
        } catch {
            print("Error")
        }
        
        
        
    }
    
    
    
    //////////////////////
    //NotificationCenter//
    //////////////////////
    func notificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: Notification.Name.init(rawValue: "AddMember"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogout), name: NSNotification.Name("Logout"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAddMember), name: NSNotification.Name("ShowAddMember"), object: nil)
    }
    
    @objc func handleLogout() {
        defaults.removeObject(forKey: "user")
        performSegue(withIdentifier: "Logout", sender: nil)
    }
    
    @objc func showAddMember() {
        performSegue(withIdentifier: "AddMember", sender: nil)
    }
    
    
    /////////////////////
    @objc func reloadTableView(_ notification: Notification) {
        tableView.reloadData()
    }
    
}


/////////////
//TableView//
/////////////
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Save.membersCoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemberTableViewCell
        cell.member = Save.membersCoreData[indexPath.row]
        return cell
    }
    
    //////////
    //Delete//
    //////////
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let mem = Save.membersCoreData[indexPath.row]
            context.delete(mem)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            Save.membersCoreData.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
