//
//  SchedulerTableViewCell.swift
//  CompanyMeetingScheduler
//
//  Created by Abhinav Mathur on 17/05/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import UIKit

class SchedulerTableViewCell: UITableViewCell {
    @IBOutlet weak var meetingDate: UIButton!
    @IBOutlet weak var dateArrow: UIImageView!
    @IBOutlet weak var meetingStartTime: UIButton!
    @IBOutlet weak var startTimeArrow: UIImageView!
    @IBOutlet weak var meetingEndTime: UIButton!
    @IBOutlet weak var endTimeArrow: UIImageView!
    @IBOutlet weak var meetingDescription: UITextView!
    @IBOutlet weak var submitMeetingSchedule: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
