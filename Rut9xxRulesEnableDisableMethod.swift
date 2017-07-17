//
//  Rut9xxRulesEnableDisableMethod.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 12/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class Rut9xxRulesEnableDisableMethod: UIViewController {
    
    
    
    internal func Rut9xxInputRulesMethod(rowNumber: String, valueSwitch: String, complete: @escaping ()->()){
        let token = UserDefaults.standard.value(forKey: "saved_token")


        let iomanConfig = "ioman"
        let configOption = "enabled"
        let configSection = "@rule[\(rowNumber)]"
        let configValue = valueSwitch
        
        Json().setConfigInformation(token: token as! String, config:iomanConfig, section: configSection, configOption: configOption, value: configValue) { (response) in
            print("valio", response)
            Json().commitConfigsChanges(token: token as! String, config: iomanConfig) { (json) in
                Json().luciReload(token: token as! String) { (json) in

                complete()
                
                }}}

    }}
