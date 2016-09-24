//
//  Object.swift
//  ASKDetector
//
//  Created by Андрей Щербинин on 23.09.16.
//  Copyright © 2016 AS. All rights reserved.
//

import Foundation
import RealmSwift

class AutoObject: Object
{
    dynamic var id          = ""
    dynamic var name        = ""
    dynamic var model       = ""
    dynamic var type        = 0
    dynamic var enterprise  = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String,
                     name: String,
                     model: String,
                     type: Int,
                     enterprise: String)
    {
        self.init()
        self.id = id
        self.name = name
        self.model = model
        self.type = type
        self.enterprise = enterprise
    }
    
    convenience init(object: ObjectItem)
    {
        self.init(id: object.id!,
                  name: object.name!,
                  model: object.model!,
                  type: object.type!,
                  enterprise: object.enterprise!)
    }

}
