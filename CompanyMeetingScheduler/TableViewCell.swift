//
//  TableViewCell.swift
//  CompanyMeetingScheduler
//
//  Created by Abhinav Mathur on 16/05/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var meetingTime: UILabel!
    @IBOutlet weak var meetingDescription: UILabel!
    @IBOutlet weak var meetingEndTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
