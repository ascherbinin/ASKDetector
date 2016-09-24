//
//  StateCell.swift
//  ASKDetector
//
//  Created by Андрей Щербинин on 23.09.16.
//  Copyright © 2016 AS. All rights reserved.
//

import UIKit

class StateCell: UITableViewCell
{
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblFuel: UILabel!
    
    let dateFormatter = NSDateFormatter()

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(time:NSDate, speed: Float, fuel: Float)
    {
        let tempStr = dateFormatter.stringFromDate(time)
        let dateStr = tempStr.substringFromIndex(tempStr.endIndex.advancedBy(-8))
        lblTime.text = dateStr
        lblSpeed.text = "\(speed)"
        lblFuel.text = "\(fuel)"
    }
    
    
}
