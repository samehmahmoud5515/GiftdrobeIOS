//
//  ProfileAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/1/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class ProfileAPI: NSObject {

    func getUserDataFromAPI (id:String,compeletion: @escaping (UserProfileJson?)-> () ) {
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["id" : id
            ], pathparam: "userProfileAPI.php")
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let model = try JSONDecoder().decode(UserProfileJson.self, from: data)
                compeletion (model)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
    func fetchRelationList ( compeletion : @escaping (RelationJson?) -> ())
    {
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["1" : "1"
            ], pathparam: "getRelationsAPI.php")
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let recentModel = try JSONDecoder().decode(RelationJson.self, from: data)
                compeletion (recentModel)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
    func editUserDataFromAPI (id:String,email: String ,password: String ,username: String , phone: String ,age: String
        ,relationship: String , gender: String
        ,compeletion: @escaping (UserProfileJson?)-> () ) {
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["id" : id , "email": email, "password": password,
                                                                  "username":username,"phone" :phone ,"age": age ,
                                                                  "relationship": relationship, "gender": gender
            ], pathparam: "editProfileAPI.php")
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let model = try JSONDecoder().decode(UserProfileJson.self, from: data)
                compeletion (model)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
}


