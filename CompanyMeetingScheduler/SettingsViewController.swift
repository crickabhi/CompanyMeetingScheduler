//
//  SettingsViewController.swift
//  CompanyMeetingScheduler
//
//  Created by Abhinav Mathur on 17/05/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import UIKit

class SettingsViewController: XLFormViewController {
    
    var groupId     : String?
    var groupState  : Int?
    
    struct Tags {
        static let SwitchBool = "switchBool"
        static let ButtonWithSegueId = "buttonWithSegueId"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        self.initializeForm()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SettingsViewController.cancelPressed(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(SettingsViewController.savePressed(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.initializeForm()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //self.initializeForm()
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Add Event")
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        section.title = "Company Working Hours"
        // Starts
        row = XLFormRowDescriptor(tag: "starts", rowType: XLFormRowDescriptorTypeTimeInline, title: "Start Time")
        row.value = Date(timeIntervalSinceNow: 60*60*24)
        section.addFormRow(row)
        
        // Ends
        row = XLFormRowDescriptor(tag: "ends", rowType: XLFormRowDescriptorTypeTimeInline, title: "End Time")
        row.value = Date(timeIntervalSinceNow: 60*60*25)
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        // Repeat
        row = XLFormRowDescriptor(tag: "slot", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Slot Interval")
        row.value = XLFormOptionsObject(value: 0, displayText: "30 Min")
        row.selectorTitle = "Slot"
        row.selectorOptions = [
            XLFormOptionsObject(value: 0, displayText: "30 Min"),
            XLFormOptionsObject(value: 1, displayText: "60 Min")]
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        self.form = form
    }
    
    override func formRowDescriptorValueHasChanged(_ formRow: XLFormRowDescriptor!, oldValue: Any!, newValue: Any!) {
        
        if formRow.tag == "starts" {
            let startDateDescriptor = form.formRow(withTag: "starts")!
            let endDateDescriptor = form.formRow(withTag: "ends")!
            if (startDateDescriptor.value! as AnyObject).compare(endDateDescriptor.value as! Date) == .orderedDescending {
                // startDateDescriptor is later than endDateDescriptor
                endDateDescriptor.value = Date(timeInterval: 60*60*24, since: startDateDescriptor.value as! Date)
                endDateDescriptor.cellConfig.removeObject(forKey: "detailTextLabel.attributedText")
                updateFormRow(endDateDescriptor)
            }
        }
        else if formRow.tag == "ends" {
            let startDateDescriptor = form.formRow(withTag: "starts")!
            let endDateDescriptor = form.formRow(withTag: "ends")!
            let dateEndCell = endDateDescriptor.cell(forForm: self) as! XLFormDateCell
            if (startDateDescriptor.value! as AnyObject).compare(endDateDescriptor.value as! Date) == .orderedDescending {
                // startDateDescriptor is later than endDateDescriptor
                dateEndCell.update()
                let newDetailText =  dateEndCell.detailTextLabel!.text!
                let strikeThroughAttribute = [NSStrikethroughStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
                let strikeThroughText = NSAttributedString(string: newDetailText, attributes: strikeThroughAttribute)
                endDateDescriptor.cellConfig["detailTextLabel.attributedText"] = strikeThroughText
                updateFormRow(endDateDescriptor)
            }
            else{
                let endDateDescriptor = self.form.formRow(withTag: "ends")!
                endDateDescriptor.cellConfig.removeObject(forKey: "detailTextLabel.attributedText")
                updateFormRow(endDateDescriptor)
            }
        }
    }
    
    func cancelPressed(_ button: UIBarButtonItem){
        self.navigationController?.viewControllers.removeLast()
    }
    
    func savePressed(_ button: UIBarButtonItem){
        let validationErrors : Array<NSError> = formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            showFormValidationError(validationErrors.first)
            return
        }
        
        Util.workingStartTime = Util().timeFromDate(dateObj: form.formRow(withTag: "starts")!.value! as! Date)
        Util.workingEndTime = Util().timeFromDate(dateObj: form.formRow(withTag: "ends")!.value! as! Date)
        if (form.formRow(withTag: "slot")!.value as AnyObject).valueData()! as! Int == 0
        {
            Util.slotInterval = 30
        }
        else
        {
            Util.slotInterval = 60
        }
        QueryHandler().setCompanyMeetingSettings(startingWorkingHours: Util.workingStartTime, endingWorkingHours: Util.workingEndTime, slotInterval: Util.slotInterval, workingDays: Util.workingDays)
        tableView.endEditing(true)
        self.navigationController?.viewControllers.removeLast()
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
