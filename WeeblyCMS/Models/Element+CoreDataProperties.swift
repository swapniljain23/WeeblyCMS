//
//  Element+CoreDataProperties.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 10/2/17.
//  Copyright © 2017 Weebly. All rights reserved.
//
//

import Foundation
import CoreData


extension Element {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Element> {
        return NSFetchRequest<Element>(entityName: "Element")
    }

    @NSManaged public var elementDescription: String?
    @NSManaged public var elementName: String?
    @NSManaged public var elementOrder: Int16
    @NSManaged public var elementImage: NSData?
    @NSManaged public var elementType: String?
    @NSManaged public var page: Page?

}
