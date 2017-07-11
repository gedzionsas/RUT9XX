//
//  InputController.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 05/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

class InputController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        Rut9xxInputRulesModel().Rut9xxInputRulesMethod(){ (result) in
print("labai gerai", result)
            
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    let index = typeValue.index(typeValue.startIndex, offsetBy: 1)
    result = result1.substring(to: index)
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
}
