//
//  Util.swift
//  CompanyMeetingScheduler
//
//  Created by Abhinav Mathur on 17/05/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import Foundation

class Util
{
    static var workingStartTime = "09:00"
    static var workingEndTime   = "19:00"
    static var slotInterval     = 30
    static var workingDays      = ["Monday","Tuesday","Wednesday","Thursday","Friday"]
    
    func dayMonthYearFromDate(date : Date)-> String
    {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let dateString = df.string(from: date)
        
        return dateString
    }
    
    func timeFormatChange(time : String)-> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let date = dateFormatter.date(from: time)
        dateFormatter.dateFormat = "hh:mma"
        let newTime = dateFormatter.string(from: date!)
        return newTime
    }
    
    func getDayOfWeek(_ today: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    func timeFromDate(dateObj : Date)-> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.string(from: dateObj)
        return strDate
    }
}
