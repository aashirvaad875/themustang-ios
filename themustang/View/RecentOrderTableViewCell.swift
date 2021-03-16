//
//  RecentOrderTableViewCell.swift
//  themustang
//
//  Created by Ashik Chalise on 8/29/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit

class RecentOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var recentImage: UIImageView!
    @IBOutlet weak var recentOrderName: UILabel!
    @IBOutlet weak var recentOrderTime: UILabel!
    @IBOutlet weak var recentOrderPrice: UILabel!
    @IBOutlet weak var recentOrderAddress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        recentImage.layer.cornerRadius = 30;
        clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
