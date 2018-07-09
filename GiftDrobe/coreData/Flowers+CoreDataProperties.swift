//
//  Flowers+CoreDataProperties.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/8/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//
//

import Foundation
import CoreData


extension Flowers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flowers> {
        return NSFetchRequest<Flowers>(entityName: "Flowers")
    }

    @NSManaged public var id: String?
    @NSManaged public var type: String?
    @NSManaged public var quantity: String?
    @NSManaged public var message: String?
    @NSManaged public var card_message_id: String?
    @NSManaged public var color_id: String?
    @NSManaged public var schedule_id: String?
    @NSManaged public var bouquetId: String?

    
}
