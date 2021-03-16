//
//  TimeLineBookingCell.swift
//  themustang
//
//  Created by Ashik Chalise on 9/18/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit

class TimeLineBookingCell: UITableViewCell {

    @IBOutlet weak var shortName: UILabel!
    @IBOutlet weak var nameHolder: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        status.layer.cornerRadius = 12
        status.clipsToBounds = true
        nameHolder.layer.cornerRadius = 30;
        clipsToBounds = true
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
