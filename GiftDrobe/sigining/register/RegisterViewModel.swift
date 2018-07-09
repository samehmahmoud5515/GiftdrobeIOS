//
//  RegisterViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/10/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class RegisterViewModel: NSObject {

    @IBOutlet var api : RegisterAPI!
    var register_json : ResgisterJson?
    func fetchData(email: String, password: String, userName: String, fullName: String, phone: String,completion : @escaping ( Bool? ) -> ()) {
     
        api.fetchData(email: email, password: password, userName: userName, fullName: fullName, phone: phone, compeletion:{
            registerJson in
            self.register_json = registerJson
            if registerJson != nil {
            if registerJson?.success == 1
            {
                let userManager = UserDataManager()
                userManager.saveUserId(Id: (registerJson?.user![0].id)!)
                userManager.saveUserName(name: registerJson?.user![0].fullname ?? "")
                userManager.savePhone(phone: registerJson?.user![0].mobile ?? "")
                userManager.saveUserMail(mail: registerJson?.user![0].email ?? "" )


                completion( true)
            }
            else {
                completion( false )
            }
        }
        else {
            completion(false)
        }}
            )
    }
    
}
