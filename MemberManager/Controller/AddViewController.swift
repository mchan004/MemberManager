//
//  AddViewController.swift
//  MemberManager
//
//  Created by Administrator on 11/20/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDetail: UITextView!
    @IBOutlet weak var textSex: UITextField!
    @IBOutlet weak var textAge: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var viewPickerView: UIView!
    @IBOutlet weak var viewTextF: UIView!
    
    @IBOutlet weak var heightViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var select: Bool = true
    var dataPickerView: [String] = []
    var members: [Member] = []
    
    @IBAction func handleOkPickerView(_ sender: Any) {
        viewPickerView.isHidden = true
        
        let row = pickerView.selectedRow(inComponent: 0)
        let selected = dataPickerView[row]
        
        if select {
            textSex.text = selected
        } else {
            textAge.text = selected
        }
        
    }
    
    @IBAction func handleCancelPickerView(_ sender: Any) {
        viewPickerView.isHidden = true
    }
    
    
    @IBAction func handleAdd(_ sender: Any) {
        let name = textName.text!
        let detail = textDetail.text!
        if name.count < 4 || name.count > 20 {
            self.showAlert(title: "Tên phải từ 4-20 kí tự!", message: nil)
            return
        }
        
        if detail.count < 4 || detail.count > 100 {
            self.showAlert(title: "Giới thiệu phải từ 4-100 kí tự!", message: nil)
            return
        }
        
        
        let sex = textSex.text!
        guard let age = Int(textAge.text!) else {
            return
        }
        
        
        let member = Member(name: name, age: age, sex: sex, detail: detail)
        Save.members.append(member)
        
        let defaults = UserDefaults.standard
        let encodeData = NSKeyedArchiver.archivedData(withRootObject: Save.members)
        defaults.set(encodeData, forKey: "Members")
        NotificationCenter.default.post(name: Notification.Name.init("AddMember"), object: nil)
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupKeyboard()
    }
    
    func setupView() {
        textDetail.layer.cornerRadius = 6
        textDetail.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textDetail.layer.borderWidth = 1
        
        viewPickerView.isHidden = true
    }
    
    ////////////
    //Keyboard//
    ////////////
    func setupKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        viewTextF.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            heightViewConstraint.constant += keyboardHeight
        }
        
//        let bottomOffset = CGPoint(x: 0, y: scrollView.bounds.size.height - scrollView.contentSize.height)
//        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            heightViewConstraint.constant -= keyboardHeight
        }
        
    }
    /////////////////////
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Let me check again", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

//////////////
//PickerView//
//////////////
extension AddViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPickerView.count
        
    }
    
}

extension AddViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPickerView[row]
        
    }
    

}

/////////////
//TextField//
/////////////
extension AddViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewPickerView.isHidden = false
        dismissKeyboard()
        if textField == textAge {
            select = false
            dataPickerView = []
            for i in 11...60 {
                dataPickerView.append(String(i))
            }
        } else {
            select = true
            dataPickerView = ["Famale", "Male"]
        }
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
        
    }
    

}
