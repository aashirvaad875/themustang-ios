//
//  TableBookingTableViewCell.swift
//  themustang
//
//  Created by Ashik Chalise on 8/29/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit

class TableBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var bookingStatusLabel: UILabel!
    @IBOutlet weak var bookingName: UILabel!
    @IBOutlet weak var bookingDescribtion: UILabel!
    @IBOutlet weak var bookingDate: UILabel!
    @IBOutlet weak var bookingStatus: UILabel!
    @IBOutlet weak var nameHolder: UILabel!
    @IBOutlet weak var nameHolderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bookingStatusLabel.layer.cornerRadius = 12
        bookingStatusLabel.clipsToBounds = true
        
       nameHolderView.layer.cornerRadius = 30
  

        
        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
