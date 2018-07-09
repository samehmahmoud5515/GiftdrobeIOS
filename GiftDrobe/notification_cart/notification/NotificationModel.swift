//
//  NotificationModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/8/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation

struct NotificationItem: Decodable {
    var id: String?
    var name: String?
    var image: String?
    var price: String?
    var date: String?
}

struct NotificationJson: Decodable {
    var gifts: [NotificationItem]?
    var success: Int?
}
