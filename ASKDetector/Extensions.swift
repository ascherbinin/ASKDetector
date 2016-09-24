//
//  Extensions.swift
//  ASKDetector
//
//  Created by Андрей Щербинин on 23.09.16.
//  Copyright © 2016 AS. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    func toArray<T>(ofType: T.Type) -> [T]
    {
        var array = [T]()
        for i in 0 ..< count
        {
            if let result = self[i] as? T
            {
                array.append(result)
            }
        }
        
        return array
    }
}