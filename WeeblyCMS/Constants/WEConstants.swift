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

enum ElementType{
    case text
    case image
    case video
    case spacer
    case map
}