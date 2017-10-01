//
//  Page+CoreDataProperties.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 10/1/17.
//  Copyright © 2017 Weebly. All rights reserved.
//
//

import Foundation
import CoreData


extension Page {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page> {
        return NSFetchRequest<Page>(entityName: "Page")
    }

    @NSManaged public var pageName: String
    @NSManaged public var pageOrder: Int16
    @NSManaged public var site: Website?
    @NSManaged public var elements: NSSet?

}

// MARK: Generated accessors for elements
extension Page {

    @objc(addElementsObject:)
    @NSManaged public func addToElements(_ value: Element)

    @objc(removeElementsObject:)
    @NSManaged public func removeFromElements(_ value: Element)

    @objc(addElements:)
    @NSManaged public func addToElements(_ values: NSSet)

    @objc(removeElements:)
    @NSManaged public func removeFromElements(_ values: NSSet)

}
