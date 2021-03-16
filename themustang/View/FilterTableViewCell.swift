//
//  FilterTableViewCell.swift
//  themustang
//
//  Created by Ashik Chalise on 10/2/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderAddress: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        orderImage.layer.cornerRadius = 30;
        clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
