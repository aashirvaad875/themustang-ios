//
//  TimeLineOrderCell.swift
//  themustang
//
//  Created by Ashik Chalise on 9/12/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit

class TimeLineOrderCell: UITableViewCell {

    @IBOutlet weak var orderTimelineImage: UIImageView!
    @IBOutlet weak var orderTimelineName: UILabel!
    @IBOutlet weak var orderTimeLineDate: UILabel!
    @IBOutlet weak var orderTimeLinePrice: UILabel!
    @IBOutlet weak var orderTimeLineAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        orderTimelineImage.layer.cornerRadius = 30;
        clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
