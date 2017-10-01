//
//  Website+CoreDataProperties.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 10/1/17.
//  Copyright © 2017 Weebly. All rights reserved.
//
//

import Foundation
import CoreData


extension Website {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Website> {
        return NSFetchRequest<Website>(entityName: "Website")
    }

    @NSManaged public var websiteName: String
    @NSManaged public var pages: NSSet?

}

// MARK: Generated accessors for pages
extension Website {

    @objc(addPagesObject:)
    @NSManaged public func addToPages(_ value: Page)

    @objc(removePagesObject:)
    @NSManaged public func removeFromPages(_ value: Page)

    @objc(addPages:)
    @NSManaged public func addToPages(_ values: NSSet)

    @objc(removePages:)
    @NSManaged public func removeFromPages(_ values: NSSet)

}
