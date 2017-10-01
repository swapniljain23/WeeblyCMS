//
//  Page+CoreDataProperties.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 9/30/17.
//  Copyright © 2017 Weebly. All rights reserved.
//
//

import Foundation
import CoreData


extension Page {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page> {
        return NSFetchRequest<Page>(entityName: "Page")
    }

    @NSManaged public var pageOrder: Int16
    @NSManaged public var pageName: String
    @NSManaged public var site: Website?

}
