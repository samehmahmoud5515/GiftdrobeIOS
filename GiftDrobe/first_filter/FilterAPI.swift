//
//  FilterAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/25/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class FilterAPI: NSObject {
 
    func fetchOccassionList (compeletion : @escaping (OccasionJson?) -> ())
    {
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["1" : "1"
            ], pathparam: "getOccasionsAPI.php")
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let recentModel = try JSONDecoder().decode(OccasionJson.self, from: data)
                compeletion (recentModel)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
    func fetchRelationList ( compeletion : @escaping (RelationJson?) -> ())
    {
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["gender" : "m"
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
    
    func submitFilter (age:String, from: String , to: String , occasion: String, relation : String ,
                       update_flag: String , type: String
                       ,completion : @escaping (Bool?) -> () ) {
        if !Reachability.shared.isConnectedToNetwork(){
            completion(false)
            return
        }
        let userManager = UserDataManager()
        
     var postString = "key=logic123&age=" + age + "&from=" + from + "&to=" + to + "&occasion=" + occasion + "&relation="
          postString += relation + "&update_flag=" + update_flag + "&type=" + type
        
         postString += "&user_id=" + userManager.getUserId()
         
         let url = URL(string: "https://logic-host.com/work/gift/phpFiles/filterAPI.php")!
         var request = URLRequest(url: url)
         request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
         request.httpMethod = "POST"
         
         request.httpBody = postString.data(using: .utf8)
         print (url )
         URLSession.shared.dataTask(with: request) { data, response, error in
         guard let data = data, error == nil else {
         print("error=\(String(describing: error))")
             completion(false)
             return
         }
         
         if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
         print("statusCode should be 200, but is \(httpStatus.statusCode)")
         print("response = \(String(describing: response))")
            completion(false)
         }
         
         let responseString = String(data: data, encoding: .utf8)
         print("responseString = \(String(describing: responseString))")
            completion(true)
            
         }.resume()
    }
    
    func clearFilter (completion: @escaping (Bool)->() ) {
        
        if !Reachability.shared.isConnectedToNetwork(){
            completion(false)
            return
        }
        let postString = "key=logic123&update_flag=2"
        let url = URL(string: "https://logic-host.com/work/gift/phpFiles/filterAPI.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        print (url )
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                completion(false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                completion(false)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            completion(true)
            
            }.resume()
    }
    
}

