//
//  dataForPeriodicCell.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 13/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class dataForPeriodicCell {
    var action: String
    var mode: String
    var time: String
    var switchButton: String
    var days: String
    
    
    //MARK: Initialization
    
    init?(mode: String, time: String, action: String, switchButton: String, days: String) {
        
        // The name must not be empty
        guard !mode.isEmpty else {
            return nil
        }
        
        guard !days.isEmpty else {
            return nil
        }
        guard !time.isEmpty else {
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
        self.mode = mode
        self.time = time
        self.action = action
        self.switchButton = switchButton
        self.days = days
        
        
    }
}
