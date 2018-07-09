//
//  CalenderListAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/30/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class CalenderListAPI: NSObject {

    func getAllEventsFromApi (limit: String, page: String ,user: String , compeletion : @escaping (CalenderJson?) -> ()){
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        var url :URL
        if page != "" || limit != "" {
             url = urlBuilder.createURLFromParameters(parameters: ["user" : user , "page":page , "limit": limit]
            , pathparam: "getAllevents.php")
        }else {
             url = urlBuilder.createURLFromParameters(parameters: ["user" : user ]
                , pathparam: "getAllevents.php")
        }
        print(url)
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                compeletion(nil)
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let model = try JSONDecoder().decode(CalenderJson.self, from: data)
                compeletion (model)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
    func deleteEventAPI (event : String, compeletion: @escaping (DeleteJson?) -> () ){
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["id" : event ]
            , pathparam: "deleteEventsAPI.php")
        print(url)
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            guard let data = data else {return}
            do {
                let model = try JSONDecoder().decode(DeleteJson.self, from: data)
                compeletion (model)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            }.resume()
    }
    
}

