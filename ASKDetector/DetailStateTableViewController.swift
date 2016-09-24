//
//  DetailStateTableViewController.swift
//  ASKDetector
//
//  Created by Андрей Щербинин on 23.09.16.
//  Copyright © 2016 AS. All rights reserved.
//

import UIKit
import Charts

class DetailStateTableViewController: UITableViewController
{
    
    @IBOutlet weak var vwChart: BarChartView!
    
    var autoID: String!;
    private var objectFacade: ObjectsFacade!
    var stateArray = [StateHistoryObject]()
    var stateTimes = [String]();
    
        let dateFormatter = NSDateFormatter()
    
    convenience init()
    {
        self.init(nibName: "DetailStateTableViewController", bundle: NSBundle.mainBundle())
    }
    
    convenience init(objectFacade: ObjectsFacade, id: String)
    {
        self.init()
        self.title = loc("Детали");
        self.autoID = id
        self.objectFacade = objectFacade
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "StateCell", bundle: nil), forCellReuseIdentifier: "StateCell")
        vwChart.noDataText = "Получение данных"
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        stateArray = objectFacade.readStates(autoID)
        for item in stateArray
        {
            let tempStr = dateFormatter.stringFromDate(item.dt)
            let dateStr = tempStr.substringFromIndex(tempStr.endIndex.advancedBy(-8))
            stateTimes.append(dateStr)
        }
        self.tableView.reloadData()
        setChart(stateArray)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return stateArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("StateCell", forIndexPath: indexPath) as? StateCell
        let state = stateArray[indexPath.row]
        cell?.setup(state.dt, speed: Float(state.speed), fuel: Float(state.fuel))
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 44;
    }
    
    func setChart(dataPoints: [StateHistoryObject])
    {
        
        var dataEntries: [BarChartDataEntry] = []
        var reverseArray = dataPoints.reverse() as [StateHistoryObject]
        for i in 0..<dataPoints.count
        {
            let dataEntry = BarChartDataEntry(value: reverseArray[i].speed, xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Динамика скорости")
        let chartData = BarChartData(xVals: stateTimes, dataSet: chartDataSet)
        vwChart.data = chartData
        vwChart.xAxis.drawLabelsEnabled = false
        vwChart.descriptionText = ""
        vwChart.xAxis.drawGridLinesEnabled = false
        vwChart.animate(xAxisDuration: 0, yAxisDuration: 2.0)
    }


}
