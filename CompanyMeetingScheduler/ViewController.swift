//
//  ViewController.swift
//  CompanyMeetingScheduler
//
//  Created by Abhinav Mathur on 16/05/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scheduleMeetingButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var meetingData         : Array<AnyObject> = []
    var meetingDateToSee    = Date()
    
    var API = "http://fathomless-shelf-5846.herokuapp.com/api/schedule?date="
    
    override func viewWillAppear(_ animated: Bool) {
        //let urlToUse : String = API + Util().dayMonthYearFromDate(date: meetingDateToSee)
        //self.getData(urlToUse: urlToUse)
        self.meetingData = QueryHandler().returnLastMeeting()
        if self.meetingData.count > 0
        {
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
                self.meetingDateToSee = (self.meetingData[0] as AnyObject).value(forKey: "meetingDate") as! Date
                self.navigationItem.title = Util().dayMonthYearFromDate(date: self.meetingDateToSee)
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            })
        }
        else
        {
            let urlToUse : String = API + Util().dayMonthYearFromDate(date: meetingDateToSee)
            self.getData(urlToUse: urlToUse)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.scheduleMeetingButton.layer.cornerRadius = 10

        let settingValues = QueryHandler().returnCompanyMeetingSettings()
        if settingValues.0 != ""
        {
            Util.workingStartTime = settingValues.0
        }
        if settingValues.1 != ""
        {
            Util.workingEndTime = settingValues.1
        }
        if settingValues.2 > 0
        {
            Util.slotInterval = settingValues.2
        }
        if settingValues.3.count > 0
        {
            Util.workingDays = settingValues.3
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(ViewController.getNextMeetings))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Previous", style: .done, target: self, action: #selector(ViewController.getPreviousMeetings))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func getPreviousMeetings()
    {
        let meetingDate = Calendar.current.date(byAdding: .day, value: -1, to: meetingDateToSee)
        let day = Util().getDayOfWeek(Util().dayMonthYearFromDate(date: meetingDate!))
        if day == 1
        {
            let meetingDate = Calendar.current.date(byAdding: .day, value: -2, to: meetingDate!)
            meetingDateToSee = meetingDate!
            let urlToUse : String = API + Util().dayMonthYearFromDate(date: meetingDate!)
            self.getData(urlToUse: urlToUse)
        }
        else if day == 7
        {
            let meetingDate = Calendar.current.date(byAdding: .day, value: -1, to: meetingDate!)
            meetingDateToSee = meetingDate!
            let urlToUse : String = API + Util().dayMonthYearFromDate(date: meetingDate!)
            self.getData(urlToUse: urlToUse)
        }
        else
        {
            meetingDateToSee = meetingDate!
            let urlToUse : String = API + Util().dayMonthYearFromDate(date: meetingDate!)
            self.getData(urlToUse: urlToUse)
        }
    }
    
    func getNextMeetings()
    {
        let meetingDate = Calendar.current.date(byAdding: .day, value: 1, to: meetingDateToSee)
        let day = Util().getDayOfWeek(Util().dayMonthYearFromDate(date: meetingDate!))
        if day == 1
        {
            let meetingDate = Calendar.current.date(byAdding: .day, value: 1, to: meetingDate!)
            meetingDateToSee = meetingDate!
            let urlToUse : String = API + Util().dayMonthYearFromDate(date: meetingDate!)
            self.getData(urlToUse: urlToUse)
        }
        else if day == 7
        {
            let meetingDate = Calendar.current.date(byAdding: .day, value: 2, to: meetingDate!)
            meetingDateToSee = meetingDate!
            let urlToUse : String = API + Util().dayMonthYearFromDate(date: meetingDate!)
            self.getData(urlToUse: urlToUse)
        }
        else
        {
            meetingDateToSee = meetingDate!
            let urlToUse : String = API + Util().dayMonthYearFromDate(date: meetingDate!)
            self.getData(urlToUse: urlToUse)
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.meetingData.count > 0
        {
            return meetingData.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = TableViewCell()
        let cellInfo = meetingData[indexPath.row] as AnyObject
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "landscapeCell") as! TableViewCell
            cell.meetingTime.text = Util().timeFormatChange(time: cellInfo.value(forKey: "startTime") as! String)
            cell.meetingEndTime.text = Util().timeFormatChange(time: cellInfo.value(forKey: "endTime") as! String)

        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "potraitCell") as! TableViewCell
            cell.meetingTime.text = Util().timeFormatChange(time: cellInfo.value(forKey: "startTime") as! String) + " - " + Util().timeFormatChange(time: cellInfo.value(forKey: "endTime") as! String)
        }
        
        cell.meetingDescription.text = cellInfo.value(forKey: "meetingDescription") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func getData(urlToUse : String)
    {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.labelText = "Loading"
        
        let url = URL(string: urlToUse)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                if error!.localizedDescription == "The Internet connection appears to be offline."
                {
                    self.displayAlert(alertTitle : "You are not connected to the internet.", alertMessage : "Check Internet Connection")
                }
                else
                {
                    self.displayAlert(alertTitle : "Error", alertMessage : "There was some error! Please try again later")
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                })
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            print(JSON(json))
            
            let meetingJSON = JSON(json)
            
            //self.meetingData = meetingJSON.array!.sorted{($0["start_time"] < $1["start_time"])}
            QueryHandler().removeOldRecord()
            for i in 0 ..< meetingJSON.count
            {
                QueryHandler().setLastMeeting(meetingInformation: meetingJSON[i], date : self.meetingDateToSee)
            }
            
            self.meetingData = QueryHandler().returnLastMeeting()
            self.meetingData.sort(by: {((($0 as AnyObject).value(forKey: "startTime") as! String) < (($1 as AnyObject).value(forKey: "startTime") as! String))})

            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
                self.navigationItem.title = Util().dayMonthYearFromDate(date: self.meetingDateToSee)
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            })
        }
        
        task.resume()
    }
    
    @IBAction func scheduleMeeting(_ sender: Any) {
        self.performSegue(withIdentifier: "scheduleMeetingSegue", sender: NSDate())
    }
    
    @IBAction func settingsButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "settingsSegue", sender: NSDate())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        if segue.identifier == "scheduleMeetingSegue" {
            let vc = segue.destination as! MeetingSchedulerViewController
            vc.dateValue = Util().dayMonthYearFromDate(date: self.meetingDateToSee)
            vc.meetingCount = self.meetingData.count
        }
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


}

