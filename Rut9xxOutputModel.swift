//
//  Rut9xxOutputModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 12/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class Rut9xxOutputModel: UIViewController {
    
    let token = UserDefaults.standard.value(forKey: "saved_token")
    
    internal func Rut9xxOutputMethod(complete: @escaping ([[String: String]])->()){
        let config = "output_control"
        let actionOption = "action"
        let modeOption = "mode"
        let fixedHourOption = "fixed_hour"
        let fixedMinutesOption = "fixed_minute"
        let dayOption = "day"
        let enabledOption = "enabled"
        
        Json().fileExec2Comm(token: token as! String, command: "cat /etc/config/output_control") { (response9) in
            MethodsClass().processJsonStdoutOutput(response_data: response9){ (value) in
                
                Json().fileExec2Comm(token: self.token as! String, command: "gpio.sh get DOUT1") { (response1) in
                    MethodsClass().processJsonStdoutOutput(response_data: response1){ (dOut1Value) in
                        Json().fileExec2Comm(token: self.token as! String, command: "gpio.sh get DOUT2") { (response2) in
                            MethodsClass().processJsonStdoutOutput(response_data: response2){ (dOut2Value) in
                                
                                var i = 0
                                
                                let Arr : [String] = value.components(separatedBy: "rule")
                                for item in Arr {
                                    i += 1
                                }
                                
                                var object: [String: String] = [:]
                                var arrayObjects = [[String: String]]()
                                
                                var rulesNumber = 0
                                var rulesCount = (i - 1)
                                
                                let dispatchGroup = DispatchGroup()
                                
                                while (rulesNumber < rulesCount) {
                                    
                                    dispatchGroup.enter()
                                    
                                    var configSection = "@rule[\(rulesNumber)]"
                                    print(rulesNumber, rulesCount)
                                    
                                    
                                    Json().deviceinform(token: self.token as! String, config: config, section: configSection, option: actionOption) { (response1) in
                                        MethodsClass().getJsonValue(response_data: response1) { (actionValue) in
                                            Json().deviceinform(token: self.token as! String, config: config, section: configSection, option: modeOption) { (response2) in
                                                MethodsClass().getJsonValue(response_data: response2) { (modeValue) in
                                                    Json().deviceinform(token: self.token as! String, config: config, section: configSection, option: fixedHourOption) { (response3) in
                                                        MethodsClass().getJsonValue(response_data: response3) { (fixedHourValue) in
                                                            Json().deviceinform(token: self.token as! String, config: config, section: configSection, option: fixedMinutesOption) { (response4) in
                                                                MethodsClass().getJsonValue(response_data: response4) { (fixedMinutesValue) in
                                                                    Json().deviceinform(token: self.token as! String, config: config, section: configSection, option: dayOption) { (response5) in
                                                                        MethodsClass().getJsonArrayValue(response_data: response5) { (days) in
                                                                            var daysArray = [String]()
                                                                            if !days.isEmpty {
                                                                                for day in days {
                                                                                    daysArray.insert(day.capitalized, at: 0)
                                                                                }
                                                                            }
                                                                            var dayValue = daysArray.joined(separator: " ")
                                                                            
                                                                            Json().deviceinform(token: self.token as! String, config: config, section: configSection, option: enabledOption) { (response6) in
                                                                                MethodsClass().getJsonValue(response_data: response6) { (enabledValue) in
                                                                                    
                                                                                    
                                                                                    
                                                                                    if (!actionValue.isEmpty && !modeValue.isEmpty) {
                                                                                        object["Enabled"] = enabledValue
                                                                                        object["Action"] = actionValue
                                                                                        object["Mode"] = modeValue
                                                                                        object["FixedHour"] = fixedHourValue
                                                                                        object["FixedMinutes"] = fixedMinutesValue
                                                                                        object["Day"] = dayValue
                                                                                        object["DOut1"] = dOut1Value
                                                                                        object["DOut2"] = dOut2Value
                                                                                        arrayObjects.insert(object, at: 0)
                                                                                    }
                                                                                    if rulesNumber == rulesCount {
                                                                                        dispatchGroup.leave()
                                                                                    }
                                                                                    
                                                                                }}}}}}}}}}
                                        }}
                                    rulesNumber += 1
                                }
                                
                                if rulesNumber == 0 {
                                    object["DOut1"] = dOut1Value
                                    object["DOut2"] = dOut2Value
                                    arrayObjects.insert(object, at: 0)
                                }
                                
                                
                                dispatchGroup.notify(queue: DispatchQueue.main) {
                                    complete(arrayObjects)
                                    
                                }
                                
                                
                                
                                
                            }}
                    }}
            }}
        
    }}
