//
//  LoginViewController.swift
//  MemberManager
//
//  Created by Administrator on 11/20/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    let defaults = UserDefaults.standard
    
    @IBAction func handleLogin(_ sender: Any) {
        let user = textUserName.text!
        let passwd = textPassword.text!
        if user.count < 4 || user.count > 10 {
            self.showAlert(title: "Username phải từ 4-10 kí tự!", message: nil)
            return
        }
        
        if passwd.count < 4 || passwd.count > 10 {
            self.showAlert(title: "Password phải từ 4-10 kí tự!", message: nil)
            return
        }
        
        
        defaults.set(user, forKey: "user")
        performSegue(withIdentifier: "login", sender: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.object(forKey: "user") != nil {
            performSegue(withIdentifier: "login", sender: nil)
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Let me check again", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
}

