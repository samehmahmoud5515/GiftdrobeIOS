//
//  SchedulingListCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 6/13/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class SchedulingListCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var todayIV: UIImageView!
    
    func displayContent (item: ScheduleModel) {
        if item.today == "1" {
             dayLabel.isHidden = true
             monthLabel.isHidden = true
             todayIV.isHidden = false
            
        }else {
            dayLabel.isHidden = false
            monthLabel.isHidden = false
            todayIV.isHidden = true
            dayLabel.text = item.day
            if let mon = item.month {
                let m = mon[..<3]
                monthLabel.text = m.uppercased() }
        }
        personLabel.text = "For: " + item.forWhom!
        repeatLabel.text = "Repeat every: " + item.repeatPeriod!
       
    }

}
