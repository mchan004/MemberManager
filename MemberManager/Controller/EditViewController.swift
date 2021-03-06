//
//  AddViewController.swift
//  MemberManager
//
//  Created by Administrator on 11/24/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDetail: UITextView!
    @IBOutlet weak var textSex: UITextField!
    @IBOutlet weak var textAge: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var viewPickerView: UIView!
    @IBOutlet weak var viewTextF: UIView!
    @IBOutlet weak var imageAvatar: UIImageView!
    
    var select: Bool = true
    var dataPickerView: [String] = []
    var members: [Member] = []
    var isTextView: Bool = false
    var idSelected: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDataView()
        
        setupKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeAvatar(_:)), name: NSNotification.Name("SelectedImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeAvatarFromCamera(_:)), name: NSNotification.Name("TakedPhoto"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    func setupView() {
        textDetail.layer.cornerRadius = 6
        textDetail.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textDetail.layer.borderWidth = 1
        
        viewPickerView.isHidden = true
        
        imageAvatar.clipsToBounds = true
        imageAvatar.layer.borderWidth = 1
        imageAvatar.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        imageAvatar.layer.cornerRadius = imageAvatar.frame.size.width / 2
        
    }
    
    /////////Function////////////
    @objc func keyboardWillHide(_ notification: Notification) {
        
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Let me check again", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupDataView() {
        idSelected = UserDefaults.standard.object(forKey: "tableviewSelected") as! Int
        textName.text = Save.membersCoreData[idSelected].name
        textAge.text = String(Save.membersCoreData[idSelected].age)
        textSex.text = Save.membersCoreData[idSelected].sex
        textDetail.text = Save.membersCoreData[idSelected].detail
        
        if let imageData = Save.membersCoreData[idSelected].avatar {
            if let image = UIImage(data:imageData) {
                imageAvatar.image = image
            }
        }
    }
    
    @objc func changeAvatar(_ notification: Notification) {
        if let id = notification.object as? Int {
            imageAvatar.image = ImageStatic.arrayImage[id]
        }
        
    }
    
    @objc func changeAvatarFromCamera(_ notification: Notification) {
        if let img = notification.object as? UIImage {
            imageAvatar.image = img
        }
        
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
        viewPickerView.isHidden = true
        view.endEditing(true)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        viewPickerView.isHidden = true
        if !isTextView {
            return
        }
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let viewHeight = view.frame.size.height
            let viewWidth = view.frame.size.width
            
            
            let keyboardY = viewHeight - keyboardHeight
            
            let textDetailY = textDetail.frame.origin.y
            
            if view.frame.origin.y >= 0 {
                //Checking if the text is really hidden behind the keyboard
                if textDetailY > keyboardY - 70 {
                    UIView.animate(withDuration: 1, animations: {
                        self.view.frame = CGRect(x: 0, y: 0 - (textDetailY - (keyboardY - 70)), width: viewWidth, height: viewHeight)
                    })
                }
            }
            isTextView = false
        }
    }
    
    //////////
    //Action//
    //////////
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
    
    @IBAction func handleTouchDownAge(_ sender: Any) {
        viewPickerView.isHidden = false
        view.endEditing(true)
        select = false
        dataPickerView = []
        for i in 11...60 {
            dataPickerView.append(String(i))
        }
        pickerView.reloadAllComponents()
    }
    
    @IBAction func handleTouchDownSex(_ sender: Any) {
        viewPickerView.isHidden = false
        view.endEditing(true)
        select = true
        dataPickerView = ["Famale", "Male"]
        pickerView.reloadAllComponents()
    }
    
    @IBAction func handleSave(_ sender: Any) {
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
        
        guard let age = Int(textAge.text!) else {
            return
        }
        
        if age < 5 || age > 100 {
            self.showAlert(title: "Nhap tuoi sai!", message: nil)
            return
        }
        
        if textAge.text! == "" {
            self.showAlert(title: "Nhap gioi tinh!", message: nil)
            return
        }
        
        let sex = textSex.text!
        
        //        //Userdefaults
        //        let defaults = UserDefaults.standard
        //        let encodeData = NSKeyedArchiver.archivedData(withRootObject: Save.members)
        //        defaults.set(encodeData, forKey: "Members")
        
        //Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        Save.membersCoreData[idSelected].age = Int16(age)
        Save.membersCoreData[idSelected].detail = detail
        Save.membersCoreData[idSelected].sex = sex
        Save.membersCoreData[idSelected].name = name
        Save.membersCoreData[idSelected].avatar = nil
        
        if let img = imageAvatar.image {
            Save.membersCoreData[idSelected].avatar = UIImagePNGRepresentation(img)
        }
        
        do {
            try context.save()
            print(123)
        } catch  {
            
        }
        
        
        NotificationCenter.default.post(name: Notification.Name.init("AddMember"), object: nil)
        _ = navigationController?.popViewController(animated: true)
    }
    
}



//////////////
//PickerView//
//////////////
extension EditViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPickerView.count
        
    }
    
}

extension EditViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPickerView[row]
    }
}

/////////////
//TextField//
/////////////
extension EditViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

extension EditViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        isTextView = true
        return true
    }
}

