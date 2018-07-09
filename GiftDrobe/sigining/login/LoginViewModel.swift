//
//  LoginViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/10/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class LoginViewModel: NSObject {

    @IBOutlet var api: LoginAPI!
    var login_json : LoginJson?
    func login(name: String, password: String,completion : @escaping ( Bool? ) -> ())  {

        api.fetchData(name : name , password: password,compeletion:
          {
            loginJson in
            self.login_json = loginJson
            if loginJson != nil {
            if loginJson?.success == 1
            {
              
                let userManager = UserDataManager()
                userManager.saveUserId(Id: (loginJson?.user![0].id)!)
                userManager.saveUserName(name :loginJson?.user![0].fullname ?? "")
                userManager.savePhone(phone: loginJson?.user![0].mobile ?? "")
                userManager.saveUserMail(mail: loginJson?.user![0].email ?? "" )

                completion(true)
            }
            else {
                completion(false)
                }}
            else {
                completion(false)
            }
        })
        }
    
    func googleLogin(username: String , googleid: String , email: String,image:String ,completion : @escaping (Bool?) -> ())  {
        api.googleLogin(username: username, googleid: googleid, email: email, compeletion: { loginJson in
          
            if loginJson != nil {
            if loginJson?.success == 1
            {
                
                let userManager = UserDataManager()
                userManager.saveUserId(Id: (loginJson?.user![0].id)!)
                userManager.saveUserName(name :username)
                userManager.saveUserImage(image: image)
                userManager.saveUserMail(mail: email  )


                completion(true)
            }
            else {
                completion(false)
            }
            }else {
                completion(false)
            }
        })
    }
    
    func faceLogin(username: String , faceid: String , email: String,image : String, completion : @escaping (Bool?) -> ())  {
        api.facebookLogin(username: username, faceid: faceid, email: email, compeletion: { loginJson in
            
            if loginJson != nil {
                if loginJson?.success == 1
                {
                    
                    let userManager = UserDataManager()
                    userManager.saveUserId(Id: (loginJson?.user![0].id)!)
                    userManager.saveUserImage(image: image)
                    userManager.saveUserName(name :username)
                    userManager.saveUserMail(mail: email  )

                    completion(true)
                }
                else {
                    completion(false)
                }
            }else {
                completion(false)
            }
        })
    }
}



