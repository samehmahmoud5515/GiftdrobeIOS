//
//  CalenderListViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/30/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class CalenderListViewModel: NSObject {

    @IBOutlet var api : CalenderListAPI!
    var events : [EventModel]? = []
   
    func requestAllEvents (limit: Int , page : Int, userId: String , completion: @escaping (Bool?) -> () ) {
        api.getAllEventsFromApi(limit: String(limit) , page : String(page),user: userId , compeletion: {
            json in
            if json == nil || json?.events == nil {
                completion(false)
            }
            if json?.success == 1 {
                if let arr : [EventModel] = json?.events{
                    for g in arr {
                        self.events?.append(g)
                    }
                }
                completion(true)
            } else {
                completion(false)
            }
            
        })
    }
    
   
    
    func numberOfItemsInSection () -> Int {
        return events?.count ?? 0
    }
    
    func getEvent (indexPath: IndexPath) -> EventModel {
        return (events?[indexPath.row])!
    }
    func removeItem (indexPath: IndexPath )  {
        let item = self.events![indexPath.row]
        events = events?.filter { $0.ID != item.ID }
    }
    func deleteEvent (event: String, compeletion: @escaping (Bool) -> ()) {
        api.deleteEventAPI(event: event, compeletion: {
           json in
        
        if json?.success == 1 {
            compeletion(true)
        } else {
            compeletion(false)
        }
        
        })
    }
    func clearData()
    {
        events = []
    }
        
}
