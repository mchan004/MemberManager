//
//  SideMenuTableViewController.swift
//  MemberManager
//
//  Created by Administrator on 11/24/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        
        switch indexPath.row {
        case 0: NotificationCenter.default.post(name: NSNotification.Name("Logout"), object: nil)
        case 1: NotificationCenter.default.post(name: NSNotification.Name("ShowAddMember"), object: nil)
        default: break
        }
    }
}
