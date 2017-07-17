//
//  InputController.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 05/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

class InputController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var rulesDetails = [dataForRulesCell]()

    @IBAction func switchTapped(_ sender: UISwitch) {
        var checked = ""
        let point = sender.superview?.convert(sender.center, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: point!) {
            let row = rulesDetails[indexPath.row]
            row.switchButton = sender.isOn ? "1" : "0"
            rulesDetails[indexPath.row] = row
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
                Rut9xxRulesEnableDisableMethod().Rut9xxInputRulesMethod(rowNumber: stringRowNumber, valueSwitch: checked){ (result) in
                   
                    
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
                Rut9xxRulesEnableDisableMethod().Rut9xxInputRulesMethod(rowNumber: stringRowNumber, valueSwitch: checked){ (result) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        Rut9xxInputRulesModel().Rut9xxInputRulesMethod(){ (result) in
            
            self.updateUI(array: result)
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
        if rulesDetails.count != 0 {
        return rulesDetails.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "rulesCell"
        
        if rulesDetails.count != 0 {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Rut9xxRulesCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let row = rulesDetails[indexPath.row]
        cell.typeLabel.text = row.type
        cell.triggerLabel.text = row.trigger
        cell.actionLabel.text = row.action
        cell.switchButton.isOn = (row.switchButton == "1")
        
        return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? Rut9xxMessageCell else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            }
           cell.messageLabel.text = "There are no input rules created yet. Create rules for input configuration go to the router's WebUI"
           return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
    }


    
    
    private func checkTypeValue(typeValue: String, analogTypeValue: String)-> (String) {
    var result = ""
    if (!typeValue.isEmpty) {
    if (typeValue == "digital1") {
    result = "Digital"
    } else if (typeValue == "digital2") {
    result = "Digital isolated"
    } else if (typeValue == "analog") && (analogTypeValue == "voltagetype") {
    result = "Analog Voltage"
    } else if (typeValue == "analog") && (analogTypeValue == "currenttype") {
    result = "Current"
    } else {
    let result1 = typeValue.capitalized
    }
    } else {
    result = ""
    }
    return result
    }
    
    private func checkTriggerValue(type: String, trigger: String, analogTypeValue: String, minValue: String, maxValue: String, minCValue: String, maxCValue:String)-> (String) {
    
    var result = ""
    var minMaxLine = ""
    var minValue1 = ""
    var maxValue1 = ""
    var minCValue1 = ""
    var maxCValue1 = ""
    
    if (minValue.isEmpty && maxValue.isEmpty && minCValue.isEmpty && maxCValue.isEmpty) {
    minMaxLine = "( 0 - 0 )"
    }
    if (analogTypeValue == "voltagetype") {
    if (minValue.isEmpty) {
    minValue1 = "0"
    }
    if (maxValue.isEmpty) {
    maxValue1 = "24"
    }
    if (minMaxLine.isEmpty) {
    minMaxLine = "( " + minValue + "V - " + maxValue + "V )";
    }
    } else if (analogTypeValue == "currenttype") {
    if (minCValue.isEmpty) {
    minCValue1 = "0"
    }
    if (maxCValue.isEmpty) {
    maxCValue1 = "24"
    }
    if (minMaxLine.isEmpty) {
    minMaxLine = "(\(minCValue)mA - \(maxCValue)mA)"
    }
    }
    
    if(trigger == "no") && (type == "digital1"){
    result = "Input open"
    }else if(trigger == "nc") && (type == "digital1"){
    result = "Input shorted"
    }else if(trigger == "both") && (type == "digital1"){
    result = "Both"
    }else if(trigger == "no") && (type == "digital2"){
    result = "Low logic level"
    }else if(trigger == "nc") && (type == "digital2"){
    result = "High logic level"
    }else if(trigger == "both") && (type == "digital2"){
    result = "Both"
    }
    
    else if(trigger == "in") && (type == "analog"){
    result = "In \(minMaxLine)"
    }else if(trigger == "out") && (type == "analog"){
    result = "Out \(minMaxLine)"
    }else{
    result = "N/A"
    }
    return result
    }
    
    
    private func checkAction(action: String, outPut: String)-> (String){
    var result = ""
    var outputText = ""
    
    if(action == "sendSMS"){
    result = "Send SMS"
    }else if(action == "sendEmail"){
    result = "Send Email"
    }else if(action == "changeSimCard"){
    result = "Change SIM Card"
    }else if(action == "changeProfile"){
    result = "Change Profile"
    }else if(action == "wifion"){
    result = "Turn on WiFi"
    }else if(action == "wifioff"){
    result = "Turn off WiFi"
    }else if(action == "reboot"){
    result = "Reboot"
    }else if(action == "output"){
    if(outPut == "1"){
    outputText = "Open collector"
    }else if(outPut == "2"){
    outputText = "Relay output"
    }else{
    outputText = "None"
    }
    result = "Output (\(outputText))"
    }else{
    result = "N/A"
    }
    return result
    }
    
    
    private func updateUI(array: [[String: String]]) {
        var i = 0
        

            for item in array {
                var enabledValue = item["Enabled"] as? String
                var typeValue = item["Type"] as? String
                var triggerValue = item["Trigger"] as? String
                var actionValue = item["Action"] as? String
                
                var analogTypeValue = item["AnalogType"] as? String
                var minValue = item["MinValue"] as? String
                var maxValue = item["MaxValue"] as? String
                var minCValue = item["MinCValue"] as? String
                var maxCValue = item["MaxCValue"] as? String
                var outPutNb = item["OutputNb"] as? String


                var checkedType = checkTypeValue(typeValue: typeValue!, analogTypeValue: analogTypeValue!)
                var checkedTrigger = checkTriggerValue(type: typeValue!, trigger: triggerValue!, analogTypeValue: analogTypeValue!, minValue: minValue!, maxValue: maxValue!, minCValue: minCValue!, maxCValue: maxCValue!)
                var checkedAction = checkAction(action: actionValue!, outPut: outPutNb!)
            
        
        guard let row1 = dataForRulesCell(type: checkedType, trigger: checkedTrigger, action: checkedAction, switchButton: enabledValue!) else {
            fatalError("Unable to instantiate row1")
        }

        rulesDetails += [row1]
                i += 1
        tableView.reloadData()
                    }
    }
}
