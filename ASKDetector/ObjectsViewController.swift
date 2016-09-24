//
//  ObjectsViewController.swift
//  ASKDetector
//
//  Created by Андрей Щербинин on 21.09.16.
//  Copyright © 2016 AS. All rights reserved.
//

import UIKit

class ObjectsViewController: UITableViewController
{
    private var server: Server?
    private var objectsArray: [ObjectItem]!
    private var objectFacade: ObjectsFacade!
    private var timer: NSTimer!
    private var canUpdate = false
    // MARK: - initial

    convenience init()
    {
        self.init(nibName: "ObjectsViewController", bundle: NSBundle.mainBundle())
    }

    convenience init(objectFacade: ObjectsFacade)
    {
        self.init()
        self.title = loc("OBJECTS");
        self.objectFacade = objectFacade
        objectsArray = [ObjectItem]()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "ObjectCell", bundle: nil), forCellReuseIdentifier: "ObjectCell")

        objectFacade.getDict("objects",
            action: { (arr) in
                self.objectsArray = arr as? [ObjectItem]
                self.getStates()
            },
            error:
                { (error) -> Void in
                    print(error.userInfo)
        })

        self.title = loc("OBJECTS");
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(ObjectsViewController.getStates), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return objectsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ObjectCell", forIndexPath: indexPath) as? ObjectCell
        let object = objectsArray[indexPath.row]
        cell?.setup(object)
//         Configure the cell...

        return cell!
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 120;
    }

    func getStates()
    {
        self.objectFacade.receiveState(self.objectsArray,
            objects: "all",
            fuel: "true",
            action: {
                self.tableView.reloadData()
        }) { (errorResult) in
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let id = objectsArray[indexPath.row].id
        let dVC = DetailStateTableViewController(objectFacade: objectFacade, id: id!)
        self.navigationController?.pushViewController(dVC, animated: true)
    }
}
