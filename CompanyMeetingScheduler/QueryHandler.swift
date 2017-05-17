//
//  QueryHandler.swift
//  CompanyMeetingScheduler
//
//  Created by Abhinav Mathur on 16/05/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import Foundation
import CoreData

class QueryHandler {
    
    func removeOldRecord()
    {
        let managedContext = CoreDataStack.sharedInstance.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LastMeeting")
        do {
            let results = try managedContext.fetch(fetchRequest)
            let group = results as! [NSManagedObject]
            if group.count > 0{
                for i in 0  ..< group.count
                {
                    managedContext.delete(group[i])
                }
            }
            do {
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }  catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

    }

    func setLastMeeting(meetingInformation : JSON, date : Date)
    {
        let managedContext = CoreDataStack.sharedInstance.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "LastMeeting",in:managedContext)
        
        do {
            let msgupdate = NSManagedObject(entity: entity!,insertInto: managedContext)
            msgupdate.setValue(meetingInformation["start_time"].stringValue,forKey: "startTime")
            msgupdate.setValue(meetingInformation["end_time"].stringValue,forKey: "endTime")
            msgupdate.setValue(meetingInformation["description"].stringValue,forKey: "meetingDescription")
            msgupdate.setValue(meetingInformation["participants"].arrayObject,forKey: "participants")
            msgupdate.setValue(date,forKey: "meetingDate")

            do {
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
    }
    
    func returnLastMeeting() -> Array<AnyObject>
    {
        var returnValue : Array<AnyObject> = []
        
        let managedContext = CoreDataStack.sharedInstance.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LastMeeting")
        do {
            let results = try managedContext.fetch(fetchRequest)
            let group = results as! [NSManagedObject]
            if group.count > 0{
                for i in 0  ..< group.count
                {
                    returnValue.append(group[i] as AnyObject)
                }
            }
        }  catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return returnValue
    }

    func setCompanyMeetingSettings(startingWorkingHours : String, endingWorkingHours : String, slotInterval : Int, workingDays : Array<String>)
    {
        let managedContext = CoreDataStack.sharedInstance.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "Meeting",in:managedContext)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Meeting")
        do {
            let results = try managedContext.fetch(fetchRequest)
            let group = results as! [NSManagedObject]
            if group.count > 0{
                for i in 0  ..< group.count
                {
                    managedContext.delete(group[i])
                }
            }
            let msgupdate = NSManagedObject(entity: entity!,insertInto: managedContext)
            msgupdate.setValue(startingWorkingHours,forKey: "companyStartTime")
            msgupdate.setValue(endingWorkingHours,forKey: "companyEndTime")
            msgupdate.setValue(slotInterval,forKey: "slotInterval")
            msgupdate.setValue(workingDays,forKey: "workingDays")

            do {
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }  catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func returnCompanyMeetingSettings() -> (String,String,Int,Array<String>)
    {
        var start   : String = ""
        var end     : String = ""
        var slot    : Int = 0
        var days    : Array<String> = []
        
        let managedContext = CoreDataStack.sharedInstance.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Meeting")
        do {
            let results = try managedContext.fetch(fetchRequest)
            let group = results as! [NSManagedObject]
            if group.count > 0{
                start = group[0].value(forKey: "companyStartTime") as! String
                end = group[0].value(forKey: "companyEndTime") as! String
                slot = group[0].value(forKey: "slotInterval") as! Int
                days = group[0].value(forKey: "workingDays") as! Array<String>
            }
        }  catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return (start,end,slot,days)
    }
    
}
