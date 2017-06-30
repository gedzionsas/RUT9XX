//
//  SimPinModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 19/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class SimPinModel: UIViewController {
    
    
    
    let simCardInsertedValue = "inserted"
    let simCardErrorValue = "ERROR"
    let token = UserDefaults.standard.value(forKey: "saved_token")

    
    internal func simPinMethod(simPin: String, complete: @escaping (String)->()){

        var result = ""
        var simCardResultValue = ""
        let token = UserDefaults.standard.value(forKey: "saved_token")
        let simCardNumber = UserDefaults.standard.value(forKey: "simcard_value")
        
        if !simPin.isEmpty {
            Json().simPinCheck(token: token as! String, simPin: simPin) { (value) in
                print(value)
                MethodsClass().processJsonStdoutOutput(response_data: value){ (simCardResult) in
                      result = simCardResult
                    Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: "-z") { (value1) in
                        MethodsClass().processJsonStdoutOutput(response_data: value1){ (checkValue) in
                            print(checkValue)
                            if checkValue.trimmingCharacters(in: .whitespacesAndNewlines) == self.simCardInsertedValue {
                                if !(simCardResult.range(of: self.simCardErrorValue) != nil) {
                                    Json().setSimCardApn(token: token as! String, simCardNumber: simCardNumber as! String, apnValue: simPin, value: "pincode") { (value2) in
                                        print(value2)
                                        Json().commitConfigsChanges(token: self.token as! String, config: SIM_CARD_CONFIG) { (json) in
                                            result = simCardResult
                                            complete(result)

                                        }
                                }
                                }}
                    complete(result)
                }}}}
        }
        
    }
}
