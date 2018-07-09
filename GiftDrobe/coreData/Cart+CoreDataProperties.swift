//
//  Cart+CoreDataProperties.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/1/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var image: String?
     @NSManaged public var type: String?
    @NSManaged public var wrappingCount: String?
    @NSManaged public var generatedId: String?

}
