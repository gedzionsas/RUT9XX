//
//  dataToShowMain.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 11/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

class dataToShowMain {
    var nameMobile: String
    var valueMobile: String
    var nameWireless: String
    var valueWireless: String
    
    //MARK: Initialization
    
    init?(nameMobile: String, valueMobile: String, nameWireless: String, valueWireless: String) {
        
        // The name must not be empty
        guard !nameMobile.isEmpty else {
            return nil
        }
        
        guard !valueMobile.isEmpty else {
            return nil
        }
        guard !nameWireless.isEmpty else {
            return nil
        }
        
        guard !valueWireless.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.nameMobile = nameMobile
        self.valueMobile = valueMobile
        self.nameWireless = nameWireless
        self.valueWireless = valueWireless
        
    }
}
