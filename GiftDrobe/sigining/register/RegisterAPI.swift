//
//  RegisterAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/10/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class RegisterAPI: NSObject {

    func fetchData(email: String, password: String,userName : String,fullName : String ,phone: String
        ,compeletion : @escaping ( ResgisterJson? ) -> () )  {
        
        let urlBuilder = URLs()
        let url_ = urlBuilder.createURLFromParameters(parameters: ["email" : email,
                                                                   "password": password , "username": userName,
                                                                   "fullname": fullName , "phone" : phone
            ], pathparam: "signupAPI.php")
        
        
        
        URLSession.shared.dataTask(with: url_)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {
                compeletion(nil)
                return}
            
            do {
                
                let registerJson = try JSONDecoder().decode(ResgisterJson.self, from: data)
                compeletion (registerJson)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
        
    }
}
