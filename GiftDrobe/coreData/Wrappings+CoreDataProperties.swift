//
//  Wrappings+CoreDataProperties.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/7/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//
//

import Foundation
import CoreData


extension Wrappings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wrappings> {
        return NSFetchRequest<Wrappings>(entityName: "Wrappings")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var image: String?
    @NSManaged public var id: String?
    @NSManaged public var giftId: String?
    @NSManaged public var generatedGiftId: String?
}
