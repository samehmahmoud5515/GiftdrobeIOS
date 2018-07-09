//
//  SchedulingListModel.swift
//  GiftDrobe
//
//  Created by Logic Designs on 6/13/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import Foundation

struct ScheduleModel: Decodable {
    var id: String?
    var forWhom: String?
    var repeatPeriod: String?
    var today: String?
    var month: String?
    var day: String?
}

struct ScheduleJson : Decodable {
    var success: Int
    var schedule: [ScheduleModel]?
}

struct ScheduleDeletionJson: Decodable {
    var success: Int
}
