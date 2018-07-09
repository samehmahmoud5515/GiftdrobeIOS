//
//  NotificationViewModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/8/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class NotificationViewModel: NSObject {

    @IBOutlet var api: NotificationAPI!
    var notifications: [NotificationItem]?
    
    func requestData (limit: String , page: String , compeletion: @escaping (Bool?) -> () ) {
        api.fetchNotificatioData(limit: limit , page: page, compeletion: {
            json in
            if json == nil || json?.gifts == nil {
                compeletion(false)
            }
            if json?.success == 1 {
                self.notifications = json?.gifts
                compeletion(true)
            } else {
                compeletion(false)
            }
        })
    }
    
    func numberOfItemsInSection () -> Int {
        return notifications?.count ?? 0
    }
    
    func getNotification(indexPath: IndexPath) -> NotificationItem {
        return notifications![indexPath.row]
    }
    
}
