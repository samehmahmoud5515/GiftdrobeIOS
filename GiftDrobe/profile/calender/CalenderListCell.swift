//
//  CalenderListCell.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/4/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class CalenderListCell: UITableViewCell {

   
    
    @IBOutlet weak var today_iv: UIImageView!
    @IBOutlet weak var month_label: UILabel!
    @IBOutlet weak var day_label: UILabel!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    func displayContent(model : EventModel)
    {
        
        name_label.text = model.relation
        date_label.text = model.occasion
        day_label.text = model.day
        if let mon = model.month {
            let m = mon[..<3]
            month_label.text = m.uppercased() }

       if model.today == "0"
       {
        self.month_label.isHidden = false
        self.day_label.isHidden = false
        self.today_iv.isHidden = true
       }
       else {
        self.month_label.isHidden = true
        self.day_label.isHidden = true
        self.today_iv.isHidden = false
       }

    }
  
    
    
}


extension StringProtocol where IndexDistance == Int {
    func index(at offset: Int, from start: Index? = nil) -> Index? {
        return index(start ?? startIndex, offsetBy: offset, limitedBy: endIndex)
    }
    func character(at offset: Int) -> Character? {
        precondition(offset >= 0, "offset can't be negative")
        guard let index = index(at: offset) else { return nil }
        return self[index]
    }
    subscript(_ range: CountableRange<Int>) -> SubSequence {
        precondition(range.lowerBound >= 0, "lowerBound can't be negative")
        let start = index(at: range.lowerBound) ?? endIndex
        let end = index(at: range.count, from: start) ?? endIndex
        return self[start..<end]
    }
    subscript(_ range: CountableClosedRange<Int>) -> SubSequence {
        precondition(range.lowerBound >= 0, "lowerBound can't be negative")
        let start = index(at: range.lowerBound) ?? endIndex
        let end = index(at: range.count, from: start) ?? endIndex
        return self[start..<end]
    }
    subscript(_ range: PartialRangeUpTo<Int>) -> SubSequence {
        return prefix(range.upperBound)
    }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence {
        return prefix(range.upperBound+1)
    }
    subscript(_ range: PartialRangeFrom<Int>) -> SubSequence {
        return suffix(Swift.max(0,count-range.lowerBound))
    }
}
extension Substring {
    var string: String { return String(self) }
}

