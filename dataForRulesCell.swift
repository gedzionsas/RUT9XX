//
//  dataForRulesCell.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 12/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class dataForRulesCell {
    var type: String
    var trigger: String
    var action: String
    var switchButton: String
    //var switchButton:
    
    
    //MARK: Initialization
    
    init?(type: String, trigger: String, action: String, switchButton: String) {
        
        // The name must not be empty
        guard !type.isEmpty else {
            return nil
        }
        
        guard !trigger.isEmpty else {
            return nil
        }
        
        guard !action.isEmpty else {
            return nil
        }
        
        //    guard !value.isEmpty else {
        //      return nil
        //    }
        //
        // Initialize stored properties.
        self.type = type
        self.trigger = trigger
        self.action = action
        self.switchButton = switchButton
        
    }
}
