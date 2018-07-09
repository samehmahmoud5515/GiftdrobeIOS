//
//  NotificationCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 3/28/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var notification_title: UILabel!
    
    @IBOutlet weak var notification_date: UILabel!
    
    @IBOutlet weak var notification_price: UILabel!
    
    @IBOutlet weak var noti_imageView: UIImageView!
    
    func displayContent (notification:NotificationItem) {
        notification_title.text = ""
        notification_date.text = ""
        notification_price.text = ""
        
        let url = URL(string: notification.image!)
        let image = UIImage(named: "placeholder")
        noti_imageView.kf.setImage(with: url,placeholder: image)
        
        notification_title.text = notification.name
        notification_date.text = notification.date
        notification_price.text = notification.price! + " EGP"
    }
}
