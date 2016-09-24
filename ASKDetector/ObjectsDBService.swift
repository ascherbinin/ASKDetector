//
//  ObjectcsDBService.swift
//  ASKDetector
//
//  Created by Андрей Щербинин on 23.09.16.
//  Copyright © 2016 AS. All rights reserved.
//

import Foundation
import RealmSwift

typealias successDBAction = (NSArray) -> Void
typealias successActionReceive = () -> Void
typealias errorDBAction = (NSError) -> Void

class ObjectsDBService
{
    var realm: Realm!
    
    init(realm: Realm)
    {
        self.realm = realm
    }
    
    func writeObject(object : ObjectItem)
    {
        let autoObject = AutoObject(object: object)
        try! realm.write {
            realm.add(autoObject, update: true)
        }
    }
    
    func writeState(stateItem: StateItem,
                    autoID: String,
                    time: NSDate)
    {
        let stateHistoryObject = StateHistoryObject(id: "",
                                                 speed: stateItem.speed!,
                                                 fuel: stateItem.fuel!,
                                                 course: stateItem.course!,
                                                 lon: stateItem.lon!,
                                                 lat: stateItem.lat!,
                                                 autoID: autoID,
                                                 time: NSDate())
        try! realm.write {
            realm.add(stateHistoryObject, update: true)
        }
    }
    
    func readObjects() -> Results<AutoObject>
    {
        let autoObject = realm.objects(AutoObject.self)
        return autoObject
    }
    
    func readObjectStates(id: String) -> Results<StateHistoryObject>
    {
        let predicate = NSPredicate(format: "autoID = %@ AND dt >= %@", id, NSDate().dateByAddingTimeInterval(-600))
        let objectStates = realm.objects(StateHistoryObject.self).filter(predicate).sorted("dt", ascending: false)
        return objectStates
    }
}