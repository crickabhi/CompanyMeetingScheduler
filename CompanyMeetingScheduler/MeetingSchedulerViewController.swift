//
//  MeetingSchedulerViewController.swift
//  CompanyMeetingScheduler
//
//  Created by Abhinav Mathur on 17/05/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import UIKit

class MeetingSchedulerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!

    var pickerHelper        : String?
    
    var dateValue           : String!
    var startValue          : String?
    var endValue            : String?
    var meetingDescription  : String?
    
    let descriptionMaxLength = 250
    var meetingCount        : Int!
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()

        // Set some of UIDatePicker properties
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        
        datePicker.isHidden = true
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(MeetingSchedulerViewController.datePickerValueChanged), for: .valueChanged)
        
        self.navigationItem.title = "SCHEDULE A MEETING"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MeetingSchedulerViewController.dismissKeyboard))
        self.view!.addGestureRecognizer(tap)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = SchedulerTableViewCell()
        
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "landscapeSchedulerCell") as! SchedulerTableViewCell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "potraitSchedulerCell") as! SchedulerTableViewCell
        }
        cell.dateArrow.image = cell.dateArrow.image?.withRenderingMode(.alwaysTemplate)
        cell.dateArrow.tintColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0)
        cell.startTimeArrow.image = cell.startTimeArrow.image?.withRenderingMode(.alwaysTemplate)
        cell.startTimeArrow.tintColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0)
        cell.endTimeArrow.image = cell.endTimeArrow.image?.withRenderingMode(.alwaysTemplate)
        cell.endTimeArrow.tintColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0)

        cell.meetingDate.setTitle(self.dateValue, for: .normal)
        cell.meetingDate.layer.cornerRadius = 5
        cell.meetingDate.layer.borderWidth = 0.8
        cell.meetingDate.layer.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1.0).cgColor
        //cell.meetingDate.addTarget(self, action: #selector(MeetingSchedulerViewController.setMeetingDate), for: .touchUpInside)
        if self.startValue != nil
        {
            cell.meetingStartTime.setTitle(self.startValue, for: .normal)
        }
        cell.meetingStartTime.layer.cornerRadius = 5
        cell.meetingStartTime.layer.borderWidth = 0.8
        cell.meetingStartTime.layer.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1.0).cgColor
        cell.meetingStartTime.addTarget(self, action: #selector(MeetingSchedulerViewController.setMeetingStartTime), for: .touchUpInside)

        if self.endValue != nil
        {
            cell.meetingEndTime.setTitle(self.endValue, for: .normal)
        }
        cell.meetingEndTime.layer.cornerRadius = 5
        cell.meetingEndTime.layer.borderWidth = 0.8
        cell.meetingEndTime.layer.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1.0).cgColor
        cell.meetingEndTime.addTarget(self, action: #selector(MeetingSchedulerViewController.setMeetingEndTime), for: .touchUpInside)

        cell.meetingDescription.delegate = self
        
        if meetingDescription != nil
        {
            cell.meetingDescription.text = self.meetingDescription
        }
        else
        {
            cell.meetingDescription.text = "Description"
            cell.meetingDescription.textColor = UIColor.lightGray
        }

        cell.meetingDescription.layer.cornerRadius = 5
        cell.meetingDescription.layer.borderWidth = 0.8
        cell.meetingDescription.layer.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1.0).cgColor
        
        cell.submitMeetingSchedule.layer.cornerRadius = 10
        cell.submitMeetingSchedule.addTarget(self, action: #selector(MeetingSchedulerViewController.submitMeetingDetails), for: .touchUpInside)

        return cell
    }
    
    func setMeetingDate()
    {
        self.pickerHelper = "meetingDate"
        datePicker.isHidden = false
        datePicker.datePickerMode = .date
    }
    
    func setMeetingStartTime()
    {
        self.pickerHelper = "meetingStartTime"
        datePicker.isHidden = false
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = Util.slotInterval
    }
    
    func setMeetingEndTime()
    {
        self.pickerHelper = "meetingEndTime"
        datePicker.isHidden = false
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = Util.slotInterval
    }
    
    func submitMeetingDetails()
    {
        let day = Util().getDayOfWeek(self.dateValue)
        
        if day == 1 || day == 7
        {
            let alert = UIAlertController(title: "Alert", message: "Meeting cannot be scheduled on a holiday.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil);
        }
        else
        {
            if self.startValue != nil && self.endValue != nil
            {
                if meetingCount >= 0 && meetingCount < 4
                {
                    if self.startValue! > Util.workingStartTime && Util.workingEndTime > self.endValue! && self.endValue! > self.startValue!
                    {
                        let meetingDetails = QueryHandler().returnLastMeeting()
                        var isAvailable : Bool = true
                        
                        for i in 0 ..< meetingDetails.count
                        {
                            if self.startValue! > ((meetingDetails[i] as AnyObject).value(forKey: "endTime") as! String)
                            {
                                isAvailable = true
                                self.displayAlert(alertTitle : "Success", alertMessage : "Meeting scheduled successfully.")
                                self.navigationController?.viewControllers.removeLast(self.navigationController!.viewControllers.count - 1)
                                return
                            }
                            else
                            {
                                isAvailable = false
                                self.displayAlert(alertTitle : "Alert", alertMessage : "Sorry,meeting cannot be scheduled for the desired period because the slot is already occupied. Please schedule it for any other period.")
                                return
                            }
                        }
                    }
                    else if self.startValue! < Util.workingStartTime || Util.workingEndTime < self.endValue!
                    {
                        let messageString = "\n" + "Start time: " + Util.workingStartTime + "\n" + "End time: " + Util.workingEndTime
                        self.displayAlert(alertTitle : "Alert", alertMessage : "Meeting should be scheduled during the working hours. " + messageString)
                    }
                    else
                    {
                        self.displayAlert(alertTitle : "Alert", alertMessage : "Meeting end time cannot be before the start time.")
                    }
                }
                else
                {
                    self.displayAlert(alertTitle : "Alert", alertMessage : "Slots full for the given date.Check for next day.")
                }
            }
            else
            {
                self.displayAlert(alertTitle : "Alert", alertMessage : "Please set the meeting timing correctly.")
            }
         }
    }

    func datePickerValueChanged(_ sender: UIDatePicker){
    
        let dateFormatter: DateFormatter = DateFormatter()

        if sender.datePickerMode == .date && self.pickerHelper == "meetingDate"
        {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.dateValue =  dateFormatter.string(from: sender.date)
        }
        if sender.datePickerMode == .time
        {
            dateFormatter.dateFormat = "HH:mm"
            if self.pickerHelper == "meetingStartTime"
            {
                self.startValue =  dateFormatter.string(from: sender.date)
            }
            else
            {
                self.endValue =  dateFormatter.string(from: sender.date)
            }
        }
        datePicker.isHidden = true
        self.tableView.reloadData()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray && !textView.text.isEmpty
        {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentString: NSString = textView.text! as NSString
        if text == "\n"
        {
            textView.endEditing(true)
            textView.resignFirstResponder()
            return false
        }
        if textView.textColor == UIColor.lightGray && !text.isEmpty
        {
            textView.text = nil
            textView.textColor = UIColor.black
            return true
        }
        else
        {
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: text) as NSString
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            return newString.length <= self.descriptionMaxLength
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
        datePicker.isHidden = true
    }

    func displayAlert(alertTitle : String, alertMessage : String)
    {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil);

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
