//
//  TableViewCell.swift
//  Golden Hour
//
//  Created by Sam on 10/7/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

class TimeTableCell: UITableViewCell {
    
    // Time Mode
    @IBOutlet weak var timeLabel: UILabel!
    
    // Cell Mode
    @IBOutlet weak var cellView: UIView!
    
    // Cell Content
    @IBOutlet weak var cellBG: UIImageView!
    @IBOutlet weak var cellSymbol: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDuration: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        cellBG.layer.cornerRadius = 15
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
