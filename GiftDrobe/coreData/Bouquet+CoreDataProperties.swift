//
//  Bouquet+CoreDataProperties.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/8/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//
//

import Foundation
import CoreData


extension Bouquet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bouquet> {
        return NSFetchRequest<Bouquet>(entityName: "Bouquet")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var image: String?
    @NSManaged public var message: String?
    @NSManaged public var card_message_id: String?
    @NSManaged public var schedule_id: String?
    @NSManaged public var generatedId: String?
}
