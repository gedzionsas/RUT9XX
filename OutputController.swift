//
//  OutputController.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 05/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

class OutputController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var periodicControlDetails = [dataForPeriodicCell]()
    private let dOut1Value = "DOUT1", dOut2Value = "DOUT2"
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        var checked = ""
        let point = sender.superview?.convert(sender.center, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: point!) {
            let row = periodicControlDetails[indexPath.row]
            row.switchButton = sender.isOn ? "1" : "0"
            periodicControlDetails[indexPath.row] = row
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            
            if ((sender as AnyObject).isOn == true)
            {
                let point = sender.superview?.convert(sender.center, to: self.tableView)
                var stringRowNumber = String(indexPath.row)
                checked = "1"
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                Rut9xxPeriodicControlRulesModel().Rut9xxPeriodicControlRulesMethod(rowNumber: stringRowNumber, valueSwitch: checked){ (result) in
                    
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                
            } else {
                checked = "0"
                let point = sender.superview?.convert(sender.center, to: self.tableView)
                var stringRowNumber = String(indexPath.row)
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                Rut9xxPeriodicControlRulesModel().Rut9xxPeriodicControlRulesMethod(rowNumber: stringRowNumber, valueSwitch: checked){ (result) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ocSwitch: UISwitch!
    @IBOutlet weak var relaySwitch: UISwitch!
    @IBAction func ocOutputSwitch(_ sender: Any) {
        if ((sender as AnyObject).isOn == true){
            Rut9xxOutputOnOffSetModel().outputOnOffSetDataModel (doutParam: dOut1Value, value: "1") { (result) in
            }
        } else {
            Rut9xxOutputOnOffSetModel().outputOnOffSetDataModel (doutParam: dOut1Value, value: "0") { (result) in
            }
        }
    }
    @IBAction func relayOutput(_ sender: Any) {
        if ((sender as AnyObject).isOn == true){
            Rut9xxOutputOnOffSetModel().outputOnOffSetDataModel (doutParam: dOut2Value, value: "1") { (result) in
            }
        } else {
            Rut9xxOutputOnOffSetModel().outputOnOffSetDataModel (doutParam: dOut2Value, value: "0") { (result) in
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        Rut9xxOutputModel().Rut9xxOutputMethod(){ (result) in
            let lenght = result[0].count
            
            if lenght <= 2 {
                
                for item in result  {
                    var dOut1Value = (item["DOut1"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
                    var dOut2Value = (item["DOut2"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
                    self.checkSwitchValue(switchName: self.ocSwitch, value: dOut1Value!)
                    self.checkSwitchValue(switchName: self.relaySwitch, value: dOut2Value!)
                    
                }
            } else {
                self.updateUI(array: result)
            }
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        self.tableView.tableFooterView = UIView()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if periodicControlDetails.count != 0 {
            return periodicControlDetails.count
        } else {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if periodicControlDetails.count != 0 {
            return 65
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "periodicControlCell"
        if periodicControlDetails.count != 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Rut9xxPeriodicControlCell else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            }
            
            let row = periodicControlDetails[indexPath.row]
            cell.actionLabel.text = row.action
            cell.modeLabel.text = row.mode
            cell.timeLabel.text = row.time
            cell.daysLabel.text = row.days
            cell.switchButton.isOn = (row.switchButton == "1")
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "messagePeriodicCell", for: indexPath) as? Rut9xxPeriodicControlMessageCell else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            }
            cell.messageLabel.text = "There are no periodic controls created yet. Create periodic controls go to the router's WebUI"
            return cell
        }
        
    }
    
    
    
    func checkSwitchValue(switchName: UISwitch, value: String){
        if(value == "0"){
            switchName.isOn = false
        }else{
            switchName.isOn = true
        }
    }
    
    
    func  makeTimeFromStrings(hour: String, minutes: String)-> (String){
        var result = ""
        if(hour.isEmpty){
            if(minutes.isEmpty){
                result = "-"
            }else{
                result = minutes
            }
        }else{
            if(!minutes.isEmpty){
                result = hour + ":" + minutes
            }else{
                result = hour
            }
        }
        return result
    }
    
    
    private func updateUI(array: [[String: String]]) {
        var i = 0
        
        for item in array {
            
            var enabledValue = item["Enabled"] as? String
            if (enabledValue?.isEmpty)! {
                enabledValue = "0"
            }
            
            var actionValue = item["Action"] as? String
            if (actionValue?.isEmpty)! {
                actionValue = "-"
            } else {
                actionValue = actionValue?.capitalized
            }
            var modeValue = item["Mode"] as? String
            if (modeValue?.isEmpty)! {
                modeValue = "-"
            } else {
                modeValue = modeValue?.capitalized
            }
            
            
            var fixedHourValue = item["FixedHour"] as? String
            var fixedMinutesValue = item["FixedMinutes"] as? String
            var timeValue = makeTimeFromStrings(hour: fixedHourValue!, minutes: fixedMinutesValue!)
            var dayValue = item["Day"] as? String
            
            var dOut1Value = (item["DOut1"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
            var dOut2Value = (item["DOut2"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
            self.checkSwitchValue(switchName: self.ocSwitch, value: dOut1Value!)
            self.checkSwitchValue(switchName: self.relaySwitch, value: dOut2Value!)
            
            
            if (dayValue?.isEmpty)! {
                dayValue = "-"
            }
            
            guard let row1 = dataForPeriodicCell(mode: modeValue!, time: timeValue, action: actionValue!, switchButton: enabledValue!, days: dayValue!) else {
                fatalError("Unable to instantiate row1")
            }
            periodicControlDetails += [row1]
            tableView.reloadData()
            
        }
    }
    
}
