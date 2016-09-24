//
//  ObjectNetworkService.swift
//  ASKDetector
//
//  Created by Андрей Щербинин on 23.09.16.
//  Copyright © 2016 AS. All rights reserved.
//

import Foundation


class ObjectsNetworkService
{
    var server:Server!
    var objectDb: ObjectsDBService!
    
    init(server: Server, objectDB: ObjectsDBService)
    {
        self.server = server
        self.objectDb = objectDB
    }
    
    
    func receiveDict(dict: String,
                     action: successDBAction,
                     error: errorDBAction)
    {
        server!.requestDict(dict, action:
            { (objectsArray) -> Void in
                let arr = NSMutableArray()
                if let objects = objectsArray["objects"] as? NSArray
                {
                    for i in 0 ..< objects.count
                    {
                        let item = objects.objectAtIndex(i) as! NSDictionary
                        let object = ObjectItem();
                        object.id = item["id"] as? String
                        object.name = item["name"] as? String
                        object.model = item["model"] as? String
                        object.type = Int((item["type"] as? String)!)
                        object.enterprise = item["enterprise"] as? String
                        if let stateDict = item ["state"] as? NSDictionary
                        {
                            object.state = stateDict["state"] as? String
                            object.st_time = stateDict["st_time"] as? String
                            object.ld = stateDict["ld"] as? String
                            object.sat = stateDict["sat"] as? String
                        }
                        self.objectDb.writeObject(object)
                        arr.addObject(object)
                    }
                    action(arr)
                }
                
            })
        { (errorResult) -> Void in
            error(errorResult)
        }
    }
    
    func receiveStates(objectsArr: [ObjectItem],
                       objects: String,
                       fuel: String,
                       action: successActionReceive,
                       error: errorDBAction)
    {
        server!.requestState(objects, fuel: fuel,
                             action:
            { (statesArray) -> Void in
                if let objects = statesArray["objects"] as? NSArray
                {
                    for i in 0 ..< objects.count
                    {
                        let item = objects.objectAtIndex(i) as! NSDictionary
                        let tempId = item["id"] as? String
                        if let i = objectsArr.indexOf({$0.id == tempId})
                        {
                            let stateObj = StateItem();
                            stateObj.speed = Float((item["speed"] as? String)!)
                            stateObj.fuel = Float(item["fuel"] as? String ?? "0.0")
                            stateObj.stateNum = item["statenum"] as? String
                            stateObj.lat = item["lat"] as? String
                            stateObj.lon = item["lon"] as? String
                            stateObj.course = Float(item["course"] as? String ?? "0.0")
                            objectsArr[i].speed = stateObj.speed
                            objectsArr[i].fuel = stateObj.fuel
                            objectsArr[i].stateNum = stateObj.stateNum
                            objectsArr[i].lat = stateObj.lat
                            objectsArr[i].lon = stateObj.lon
                            objectsArr[i].course = stateObj.course
                            self.objectDb.writeState(stateObj, autoID: tempId!, time: NSDate())
                        }
                    }
                    action()
                }
                
            })
        { (errorResult) -> Void in
            error(errorResult)
        }
    }
    
}