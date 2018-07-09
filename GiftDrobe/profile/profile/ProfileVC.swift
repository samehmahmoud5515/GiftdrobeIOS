//
//  ProfileVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/4/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import DropDown
import SwiftMessages


class ProfileVC: BaseViewController , UITextFieldDelegate {

    @IBOutlet var viewModel : ProfileViewModel!
    @IBOutlet weak var relationship_line: UIView!
    @IBOutlet weak var relationship_btn: UIButton!
    @IBOutlet weak var date_picker: UIDatePicker!
    @IBOutlet weak var sex_line: UIView!
    @IBOutlet weak var sex_btn: UIButton!
    @IBOutlet weak var full_name_tf: UITextField!
    @IBOutlet weak var retypePass_tf: UITextField!
    @IBOutlet weak var mail_tf: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var deletedSavedCard: UIBarButtonItem!

    
    var relationshipId: String = ""
    var genderId: String = ""
    
    @IBOutlet weak var phone_tf: UITextField!{
        didSet {
            phone_tf?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
            phone_tf?.cancelButtonTapped()
        }
    }
    @IBOutlet weak var password_tf: UITextField!
    let userManager = UserDataManager()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //saved card
        let userManager = UserDataManager()
        let tokenName = userManager.getToken_name()
        if tokenName == "" {
            deletedSavedCard.isEnabled = false
        }else {
            deletedSavedCard.isEnabled = true
        }
        
        let relation_tap = UITapGestureRecognizer(target: self, action: #selector(self.openRelationshipDialog))
        relationship_line.addGestureRecognizer(relation_tap)
        relationship_line.isUserInteractionEnabled = true

        let sex_tap = UITapGestureRecognizer(target: self, action: #selector(self.openSexDialog))
        sex_line.addGestureRecognizer(sex_tap)
        sex_line.isUserInteractionEnabled = true
        
        self.startActivityIndicator()
        viewModel.requestRelations(completion: {
            sucess in
            self.stopActivityIndicator()
        })
        viewModel.getUserData(id: userManager.getUserId() , compeletion : {
            json in
            self.stopActivityIndicator()
             DispatchQueue.main.async {
                self.full_name_tf.text = self.viewModel.getName()
                self.mail_tf.text = self.viewModel.getEmail()
                self.phone_tf.text = self.viewModel.getPhone()
                self.password_tf.text = self.viewModel.getPassword()
                self.sex_btn.setTitle(self.viewModel.getGender(), for: .normal)
                let relationship = self.viewModel.getRelationshipById()
                if relationship == "" {
                    self.relationship_btn.setTitle("Relationship", for: .normal) }
                else {
                     self.relationship_btn.setTitle(relationship, for: .normal)
                }
                self.birthDayLabel.text = "Birthday: " + self.viewModel.getDateOfBirth()
            }
        })
        
        full_name_tf.delegate = self
        mail_tf.delegate = self
        password_tf.delegate = self
        retypePass_tf.delegate = self
        phone_tf.delegate = self
    }
    @objc func doneButtonTappedForMyNumericTextField() {
        phone_tf.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == full_name_tf {
            mail_tf.becomeFirstResponder()
        } else if textField == mail_tf {
            password_tf.becomeFirstResponder()
        } else if textField == password_tf {
            retypePass_tf.becomeFirstResponder()
        } else if textField == retypePass_tf {
            phone_tf.becomeFirstResponder()
        } else if textField == phone_tf {
            phone_tf.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing (_ textField: UITextField)  {
        
        switch  textField{
      
        case retypePass_tf:
            scrollView.setContentOffset(CGPoint(x: 0 , y: 50), animated: true)
        case phone_tf:
            scrollView.setContentOffset(CGPoint(x: 0 , y: 70), animated: true)
        default:
            print("")
        }
    }
    func textFieldDidEndEditing (_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0 , y: 0), animated: true)
    }
    
    @IBAction func Sex_btn_action(_ sender: Any) {
        openSexDialog()
    }
    
    @IBAction func sex_image_action(_ sender: Any) {
        openSexDialog()
    }
    
    @IBAction func date_picker_value_changed(_ sender: Any) {
    }
    
    @IBAction func relationship_btn_action(_ sender: Any) {
        openRelationshipDialog()
    }
    
    @IBAction func relationship_image_action(_ sender: Any) {
        openRelationshipDialog()
    }
     @IBAction func deleteCardAction(_ sender: Any) {
      
        let alert = UIAlertController(title: "Alert", message: "Delete your last credit/visa saved card?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style{
            case .default:
                let userManager = UserDataManager()
                userManager.saveToken_name(token_name: "")
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
     }
  
    @IBAction func save_btn_action(_ sender: Any) {
        
        let pass = password_tf.text
        if pass != "" {
            guard let re_pass = retypePass_tf.text, re_pass == pass else  {
                self.showErrorMessage(message: "retype password isn't match password")
                return
            }
        }
        
        let mail = mail_tf.text ?? ""; let name = full_name_tf.text ?? "" ; let phone = phone_tf.text ?? ""
        if mail != "" && name != "" && phone != "" {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: date_picker.date)
        self.startActivityIndicator()
        self.viewModel.editUserData(id: userManager.getUserId() , email: mail , password: password_tf.text ?? "", username: name, phone: phone, age: dateStr, relationship: relationshipId, gender: self.genderId, compeletion: {
             success in
            
            self.stopActivityIndicator()
        })
        }else {
            showErrorMessage(message: "email, name and phone are mandatory")
        }
    }
    
    func showErrorMessage(message: String )
    {
        DispatchQueue.main.async {
            self.stopActivityIndicator()
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✘"
            view.configureContent(title: "Error", body: message, iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }
    
    @objc func openRelationshipDialog()
    {
        let dropDown = DropDown()
        dropDown.anchorView = relationship_btn
        dropDown.dataSource = viewModel.getRelationsArrString()
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.relationship_btn.setTitle(item, for: .normal)
            self.relationshipId = self.viewModel.getRelationId(position: index)
        }
        dropDown.show()
    }
    
    @objc func openSexDialog()
    {
        let dropDown = DropDown()
        dropDown.anchorView = sex_btn
        dropDown.dataSource = ["Male", "Female"]
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.sex_btn.setTitle(item, for: .normal)
            if item == "Male"{
                self.genderId = "0"
            } else {
                self.genderId = "1"
            }
        }
        
        dropDown.show()
    }
    
  
}
