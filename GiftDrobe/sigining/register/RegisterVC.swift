//
//  RegisterVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/21/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import SwiftMessages
import NVActivityIndicatorView


class RegisterVC: BaseViewController  , UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!

    
    @IBOutlet var viewModel : RegisterViewModel!
    
    @IBOutlet weak var full_name_tf: UITextField!
    
    @IBOutlet weak var mail_tf: UITextField!
    
    
    @IBOutlet weak var username_tf: UITextField!
    
    @IBOutlet weak var pass_tf: UITextField!
    
    @IBOutlet weak var re_pass_tf: UITextField!
    
    @IBOutlet weak var phone_tv: UITextField! {
        didSet {
            phone_tv?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
            phone_tv?.cancelButtonTapped()
        }
    }
    
    
    @IBOutlet weak var register_btn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        full_name_tf.addPaddingLeftIcon( #imageLiteral(resourceName: "full_name"), padding: CGFloat(8))
        mail_tf.addPaddingLeftIcon( #imageLiteral(resourceName: "mail"), padding: CGFloat(8))
        username_tf.addPaddingLeftIcon( #imageLiteral(resourceName: "username"), padding: CGFloat(8))
        pass_tf.addPaddingLeftIcon( #imageLiteral(resourceName: "password_2"), padding: CGFloat(8))
        re_pass_tf.addPaddingLeftIcon( #imageLiteral(resourceName: "re_password"), padding: CGFloat(8))
        phone_tv.addPaddingLeftIcon( #imageLiteral(resourceName: "phone"), padding: CGFloat(8))
        
        full_name_tf.delegate = self
        mail_tf.delegate = self
        username_tf.delegate = self
        pass_tf.delegate = self
        re_pass_tf.delegate = self
        phone_tv.delegate = self
    }
 
    @objc func doneButtonTappedForMyNumericTextField() {
        phone_tv.resignFirstResponder()
        self.register_action()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == full_name_tf {
            mail_tf.becomeFirstResponder()
        } else if textField == mail_tf {
            username_tf.becomeFirstResponder()
        } else if textField == username_tf {
            pass_tf.becomeFirstResponder()
        } else if textField == pass_tf {
            re_pass_tf.becomeFirstResponder()
        } else if textField == re_pass_tf {
            phone_tv.becomeFirstResponder()
        }else if textField == phone_tv {
            textField.resignFirstResponder()
            self.register_action()
        }
        return true
    }
    
    func textFieldDidBeginEditing (_ textField: UITextField)  {
       
        switch  textField{
            case full_name_tf:
                scrollView.setContentOffset(CGPoint(x: 0 , y: 100), animated: true)
            case mail_tf:
                scrollView.setContentOffset(CGPoint(x: 0 , y: 150), animated: true)
            case username_tf:
                scrollView.setContentOffset(CGPoint(x: 0 , y: 200), animated: true)
            case pass_tf:
                scrollView.setContentOffset(CGPoint(x: 0 , y: 250), animated: true)
            case re_pass_tf:
                scrollView.setContentOffset(CGPoint(x: 0 , y: 300), animated: true)
            case phone_tv:
                scrollView.setContentOffset(CGPoint(x: 0 , y: 450), animated: true)
            default:
                scrollView.setContentOffset(CGPoint(x: 0 , y: 450), animated: true)
            }
    }
    func textFieldDidEndEditing (_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0 , y: 0), animated: true)
    }
  

    @IBAction func register_btn_action(_ sender: Any) {
        self.register_action()
    }
    
    func register_action () {
        guard let mail = mail_tf.text , !mail.isEmpty else  {
            self.registerFailed(msg: "Please enter mail address")
            return
        }
        if self.isValidEmail(testStr: mail) == false {
            self.registerFailed(msg: "not valid mail address")
            return
        }
        guard var u_name = username_tf.text , !u_name.isEmpty else {
            self.registerFailed(msg: "Please enter username")
            return
        }
        guard var f_name = full_name_tf.text , !f_name.isEmpty else {
            self.registerFailed(msg: "Please enter fullname")
            return
        }
        guard let phone = phone_tv.text , !phone.isEmpty else {
            self.registerFailed(msg: "Please enter phone")
            return
        }
        if phone.count != 11 {
            self.registerFailed(msg: "Phone must equal 11 numbers")
            return
        }
        guard let pass = pass_tf.text , !pass.isEmpty else {
            self.registerFailed(msg: "Please enter password")
            return
        }
        if pass.range(of:" ") != nil {
            self.registerFailed(msg: "password can't contain spaces")
            return
        }
        guard let rePass = re_pass_tf.text , pass == rePass else {
            self.registerFailed(msg: "Password doesn't match")
            return
        }
        u_name = u_name.replacingOccurrences(of: " ", with: "%20")
        f_name = f_name.replacingOccurrences(of: " ", with: "%20")
        
        
        self.startActivityIndicator()
        viewModel.fetchData(email: mail , password: pass, userName: u_name
            , fullName: f_name, phone: phone ,completion:  { (register_sucess) in
                
                
                if register_sucess == true {
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        let view = MessageView.viewFromNib(layout: .cardView)
                        view.configureTheme(.success)
                        view.configureDropShadow()
                        SwiftMessages.defaultConfig.presentationStyle = .bottom
                        view.button?.isHidden = true
                        let iconText = "✔"
                        view.configureContent(title: "Sucessfull", body: "Register Successfully", iconText: iconText)
                        SwiftMessages.show(view: view)
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "FirstFilterSB", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "GenderVC_nav")
                        self.present(newViewController, animated: true, completion: nil)
                    }
                    
                }
                else {
                    self.registerFailed()
                }
        })
    }
    
    func registerFailed (msg: String = "either the phone or mail is duplicate") {
        DispatchQueue.main.async {
            self.stopActivityIndicator()
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✘"
            view.configureContent(title: "Error", body: msg , iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}
