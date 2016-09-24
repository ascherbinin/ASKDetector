//
//  ObjectCell.swift
//  ASKDetector
//
//  Created by Андрей Щербинин on 21.09.16.
//  Copyright © 2016 AS. All rights reserved.
//

import UIKit

class ObjectCell: UITableViewCell
{
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblStateNum: UILabel!
    @IBOutlet weak var lblFuel: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(object: ObjectItem)
    {
        lblModel.text = object.name;
        lblSpeed.text = "\(object.speed!)";
        lblPosition.text = "\(object.lon!):\(object.lat!)";
        lblStateNum.text = object.stateNum;
        lblFuel.text = "\(object.fuel!)";
        
    }
    
}
