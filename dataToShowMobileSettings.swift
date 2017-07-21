//
//  dataToShowMobileSettings.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 24/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

class dataToShowMobileSettings {
    var name: String
    var value: String
    
    //MARK: Initialization
    
    init?(name: String, value: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        //        guard !value.isEmpty else {
        //            return nil
        //        }
        
        // Initialize stored properties.
        self.name = name
        self.value = value
        
    }
}
