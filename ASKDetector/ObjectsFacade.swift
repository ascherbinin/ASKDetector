//
//  ObjectsFacade.swift
//  ASKDetector
//
//  Created by Андрей Щербинин on 23.09.16.
//  Copyright © 2016 AS. All rights reserved.
//

import Foundation
import RealmSwift

class ObjectsFacade
{
    var objectsNs:ObjectsNetworkService!
    var objectDb: ObjectsDBService!
    
    init(objectsNs: ObjectsNetworkService, objectDB: ObjectsDBService)
    {
        self.objectsNs = objectsNs
        self.objectDb = objectDB
    }

    func readStates(id: String) -> [StateHistoryObject]
    {
        return objectDb.readObjectStates(id).toArray(StateHistoryObject) as [StateHistoryObject]
    }
    
    func getDict(dict: String,
        action: successDBAction,
        error: errorDBAction)
    {
        objectsNs.receiveDict(dict,
            action:
                { (arr) in
                    action(arr)
            }, error: { (errorResult) in
                    print (errorResult)
        })
    }
    
    func receiveState(arr: [ObjectItem],
                      objects: String,
                      fuel: String,
                      action: successActionReceive,
                      error: errorDBAction)
    {
        objectsNs.receiveStates(arr,
            objects: objects,
            fuel: fuel,
            action:
                {
                    action()
            },
            error: { (errorResult) in
                print (errorResult)
        })
    }
}