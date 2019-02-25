//
//  WEConstants.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 10/1/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

import UIKit

protocol WERefreshWebsite: AnyObject {
    func refreshMyWebsite()
}

protocol WERefreshPage: AnyObject {
    func refreshMyPage()
}

enum eElementType: String {
    case text = "text"
    case image = "image"
    case video = "video"
    case spacer = "spacer"
    case map = "map"
}

enum eOperationType {
    case create
    case edit
    case delete
}
