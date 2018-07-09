//
//  SchedulingAPI.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/2/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SchedulingAPI: NSObject {
    
    func setScheduleToApi (message: String ,userId: String ,forWhom : String, repeatPeriod: String , dateevent: String,
                                compeletion : @escaping (String?) -> ()){
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["card" : message ,"user_id" : userId, "forWhom":forWhom , "repeatPeriod":
            repeatPeriod , "dateevent" : dateevent]
            , pathparam: "scheduleAPI.php")
        
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            
            guard let data = data else {return}
            
            
            do {
                
                let model = try JSONDecoder().decode(SchedulingJson.self, from: data)
                if model.success == 1 {
                    compeletion (model.id)
                } else {
                    compeletion (nil) }
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
    func getScheduleList (userId: String , compeletion: @escaping (ScheduleJson?) -> ()) {
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }
        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["user_id" : userId ]
            , pathparam: "getScheduleAPI.php")
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
                let model = try JSONDecoder().decode(ScheduleJson.self, from: data)
                compeletion (model)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
    
    func deleteSchedule(s_id: String,compeletion: @escaping(ScheduleDeletionJson?)->()) {
        if !Reachability.shared.isConnectedToNetwork(){
            compeletion(nil)
            return
        }

        let urlBuilder = URLs()
        let url = urlBuilder.createURLFromParameters(parameters: ["id" : s_id]
            , pathparam: "deleteScheduleAPI.php")
        URLSession.shared.dataTask(with: url)
        {  (data, response , error) in
            
            if error != nil
            {
                compeletion(nil)
                return
            }
            guard let data = data else {return}
            do {
                let model = try JSONDecoder().decode(ScheduleDeletionJson.self, from: data)
                compeletion (model)
            }catch let jsonErr {
                print ("Error serializing json ", jsonErr)
                compeletion(nil)
            }
            
            }.resume()
    }
}


struct SchedulingJson : Decodable {
    var success : Int?
    var id: String?
 }



