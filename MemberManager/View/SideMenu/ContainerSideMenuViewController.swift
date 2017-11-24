//
//  ContainerSideMenuViewController.swift
//  MemberManager
//
//  Created by Administrator on 11/24/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class ContainerSideMenuViewController: UIViewController {

    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewOpacity: UIView!
    var sideMenuOpen = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    
    @IBAction func handleSideMenu(_ sender: Any) {
        toggleSideMenu()
    }
    
    @objc func toggleSideMenu() {
        
        if sideMenuOpen {
            sideMenuOpen = false
            viewOpacity.isHidden = false
            leadingConstraint.priority = UILayoutPriority(rawValue: 750)
            trailingConstraint.priority = UILayoutPriority(rawValue: 250)
        } else {
            sideMenuOpen = true
            viewOpacity.isHidden = true
            leadingConstraint.priority = UILayoutPriority(rawValue: 250)
            trailingConstraint.priority = UILayoutPriority(rawValue: 750)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}
