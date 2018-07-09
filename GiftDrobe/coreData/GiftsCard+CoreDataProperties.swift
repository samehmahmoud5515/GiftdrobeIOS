//
//  GiftsCard+CoreDataProperties.swift
//  GiftDrobe
//
//  Created by Logic Designs on 7/2/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//
//

import Foundation
import CoreData


extension GiftsCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GiftsCard> {
        return NSFetchRequest<GiftsCard>(entityName: "GiftsCard")
    }

    @NSManaged public var giftId: String?
    @NSManaged public var giftGeneratedId: String?
    @NSManaged public var id: String?
    @NSManaged public var message: String?

}
