//
//  StateHistoryObject.swift
//  ASKDetector
//
//  Created by Андрей Щербинин on 23.09.16.
//  Copyright © 2016 AS. All rights reserved.
//

import Foundation
import RealmSwift

class StateHistoryObject: Object
{
    dynamic var id          = ""
    dynamic var speed       = 0.0
    dynamic var fuel        = 0.0
    dynamic var course      = 0.0
    dynamic var lon         = ""
    dynamic var lat         = ""
    dynamic var autoID      = ""
    dynamic var dt          = NSDate()
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
    
    convenience init(id: String,
                     speed: Float,
                     fuel: Float,
                     course: Float,
                     lon: String,
                     lat: String,
                     autoID: String,
                     time: NSDate)
    {
        self.init()
        self.id = NSUUID().UUIDString
        self.speed = Double(speed)
        self.fuel = Double(fuel)
        self.course = Double(course)
        self.lon = lon
        self.lat = lat
        self.autoID = autoID
        self.dt = time
    }

}
