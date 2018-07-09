//
//  SiginingVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/20/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import SwiftMessages
import NVActivityIndicatorView
import GoogleSignIn
import Google
import FBSDKLoginKit
import FBSDKCoreKit

class LoginVC: BaseViewController  , GIDSignInUIDelegate ,GIDSignInDelegate , UITextFieldDelegate{
   
 
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var login_btn: UIButton!
    
    @IBOutlet weak var mail_textField: UITextField!
    
    @IBOutlet weak var pass_textField: UITextField!
    
    @IBOutlet var viewModel: LoginViewModel!
    let fb_login = FBSDKLoginButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        mail_textField.addPaddingLeftIcon( #imageLiteral(resourceName: "mail"), padding: CGFloat(8))
        pass_textField.addPaddingLeftIcon( #imageLiteral(resourceName: "re_password"), padding: CGFloat(8))

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
      
        
       /* fb_login.readPermissions = ["public_profile","email"]
        fb_login.delegate = self
        fb_login.center = self.view.center
        self.view.addSubview(fb_login)*/
        
        mail_textField.delegate = self
        pass_textField.delegate = self
        
      
  
    }
    
   

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == mail_textField {
            pass_textField.becomeFirstResponder()
        } else if textField == pass_textField {
            textField.resignFirstResponder()
            self.login_action()
        }
        return true
    }
    
     func textFieldDidBeginEditing (_ textField: UITextField)  {
        if textField == pass_textField {
            scrollView.setContentOffset(CGPoint(x: 0 , y: 150), animated: true)
        }else {
            scrollView.setContentOffset(CGPoint(x: 0 , y: 150), animated: true)
        }
     }
    func textFieldDidEndEditing (_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0 , y: 0), animated: true)
    }
   
   
    @IBAction func face_login_btn(_ sender: Any) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }else {
                    self.loginFailed(msg: "Failed to get email permession")
                }
            }
        }
    }
    
    func getFBUserData(){
        self.startActivityIndicator()
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,name,email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result!)
                    let loginResults = result as! NSDictionary
                    let facebookID = loginResults["id"] as! String
                    var name = loginResults["name"] as! String
                    name = name.replacingOccurrences(of: " ", with: "%20")
                    let email = loginResults["email"] as! String
                    let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
                    
                   
                    self.viewModel.faceLogin(username: name, faceid: facebookID, email: email, image :pictureURL
                        , completion: { login_sucess in
                            if login_sucess == true{
                                self.loginSuccessfully()
                            }
                            else {
                                self.loginFailed()
                            }
                    })
                } else {
                    self.loginFailed(msg: String(describing: error))
                }
            })
        }
    }
    
    
    @IBAction func google_signIn_btn_action(_ sender: Any) {
          GIDSignIn.sharedInstance().signIn()
    }
    

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil
        {
            print (error)
            return
        }
        self.startActivityIndicator()
        let userName = user.profile.name.replacingOccurrences(of: " ", with: "%20")
        var pic : String = ""
        if user.profile.hasImage
        {
            pic = user.profile.imageURL(withDimension: 100).absoluteString
        }
        viewModel.googleLogin(username: userName, googleid: user.userID, email: user.profile.email, image:pic
            , completion: {login_sucess in
                if login_sucess == true{
                    self.loginSuccessfully()
                }
                else {
                    self.loginFailed()
                }
        })
    }
    
   
    
    @IBAction func login_btn_action(_ sender: Any) {
        
        self.login_action()
    }
    
    func login_action () {
        guard let mail = mail_textField.text , !mail.isEmpty else {
            self.loginFailed(msg: "please enter mail address")
            return
        }
        guard let pass = pass_textField.text , !pass.isEmpty else {
            self.loginFailed(msg: "please enter password")
            return
        }
        self.startActivityIndicator()
        viewModel.login(name: mail, password: pass, completion: {login_sucess in
            if login_sucess == true
            {
                self.loginSuccessfully()
                
            }
            else {
                self.loginFailed()
            }
        })
        
    }
    
    func navigateToFiler()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FirstFilterSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "GenderVC_nav") 
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func loginSuccessfully(){
        DispatchQueue.main.async {
            self.stopActivityIndicator()
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.success)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✔"
            view.configureContent(title: "Sucessfull", body: "Login Successfully", iconText: iconText)
            SwiftMessages.show(view: view)
            
            self.navigateToFiler()
        }
    }
    
    func loginFailed(msg: String = "either the username or password is wrong")
    {
        DispatchQueue.main.async {
            self.stopActivityIndicator()
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            SwiftMessages.defaultConfig.presentationStyle = .bottom
            view.button?.isHidden = true
            let iconText = "✘"
            view.configureContent(title: "Error", body: msg, iconText: iconText)
            SwiftMessages.show(view: view)
        }
    }
   

}




