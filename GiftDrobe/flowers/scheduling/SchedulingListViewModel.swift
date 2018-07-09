//
//  SchedulingListViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 6/13/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SchedulingListViewModel: NSObject {

    @IBOutlet var api:SchedulingAPI!
    var scheduling_arr:[ScheduleModel]? = []
    
    func getList(completion: @escaping (Bool?) -> () ) {
        let userManger = UserDataManager()
        api.getScheduleList(userId: userManger.getUserId() , compeletion: {
            json in
            if json != nil {
                self.scheduling_arr = json?.schedule
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    func getListCount() -> Int {
        return scheduling_arr?.count ?? 0
    }
    func getListItem(indexPath: IndexPath) -> ScheduleModel {
        return (scheduling_arr![indexPath.row])
    }
    func removeItem (indexPath: IndexPath )  {
        let item = self.scheduling_arr![indexPath.row]
        scheduling_arr = scheduling_arr?.filter { $0.id != item.id }
    }
    func clearData()
    {
        scheduling_arr = []
    }
    func deleteSchedule (s_id: String, compeletion: @escaping (Bool) -> ()) {
        api.deleteSchedule(s_id: s_id, compeletion: {
            json in
            
            if json?.success == 1 {
                compeletion(true)
            } else {
                compeletion(false)
            }
            
        })
    }
}
