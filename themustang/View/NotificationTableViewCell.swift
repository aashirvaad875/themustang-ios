//
//  NotificationTableViewCell.swift
//  themustang
//
//  Created by Ashik Chalise on 9/3/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var notificationDate: UILabel!
    @IBOutlet weak var notificationMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notificationImage.layer.cornerRadius = 24;
        clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
