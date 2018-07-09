//
//  LoginAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/10/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class LoginAPI: NSObject {
    
    
    func fetchData(name: String, password: String,compeletion : @escaping ( LoginJson? ) -> () )  {
        
        let urlBuilder = URLs()
        let url_ = urlBuilder.createURLFromParameters(parameters: ["email" : name,
                                                                   "password": password ], pathparam: "loginAPI.php")

        print(url_)
        
        URLSession.shared.dataTask(with: url_)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let loginJson = try JSONDecoder().decode(LoginJson.self, from: data)
                compeletion (loginJson)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
        
    }
    
    func googleLogin(username: String , googleid: String , email: String, compeletion: @escaping (LoginJson?) -> ())  {
        let urlBuilder = URLs()
        let url_ = urlBuilder.createURLFromParameters(parameters: ["username" : username,
                                                                   "googleid": googleid,
                                                                   "email" : email], pathparam: "signInOrUpWithGoogleAPI.php")
        URLSession.shared.dataTask(with: url_)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let loginJson = try JSONDecoder().decode(LoginJson.self, from: data)
                compeletion (loginJson)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
    func facebookLogin(username: String , faceid: String , email: String, compeletion: @escaping (LoginJson?) -> ())  {
        let urlBuilder = URLs()
        let url_ = urlBuilder.createURLFromParameters(parameters: ["username" : username,
                                                                   "fid": faceid,
                                                                   "email" : email], pathparam: "signInOrUpWithFacebookAPI.php")
        URLSession.shared.dataTask(with: url_)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let loginJson = try JSONDecoder().decode(LoginJson.self, from: data)
                compeletion (loginJson)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
}
/*
https://logic-host.com/work/gift/phpFiles/signInOrUpWithFacebookAPI.php?key=logic123&username=toka&fid=43243543653464234344532f&email=toka2@logic-designs.com*/
