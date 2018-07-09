//
//  AddEventAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/26/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class AddEventAPI: NSObject {

    func addNewEventApi (userId: String,date: String ,relation: String ,occasion :String, compeletion : @escaping (InsertEventJson?) -> ()){
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["user_id" : userId , "event_date" : date
            , "occasion" : occasion , "relation" : relation]
            , pathparam: "insertEventAPI.php")
        print("url", url)
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let model = try JSONDecoder().decode(InsertEventJson.self, from: data)
                print ("model", model)

                compeletion (model)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
    func updateEventApi (eventId: String, date: String ,relation: String ,occasion :String, compeletion : @escaping (InsertEventJson?) -> ()){
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["id" : eventId , "event_date" : date
            , "occasion" : occasion , "relation" : relation]
            , pathparam: "updateEventAPI.php")
        print ("url", url)
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let model = try JSONDecoder().decode(InsertEventJson.self, from: data)
                print ("model", model)
                
                compeletion (model)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
    
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
    
}

