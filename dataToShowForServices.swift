//
//  dataToShowForServices.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 03/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class dataToShowForServices {
    var name: String
    var value: String
    var restart: String
    
    //MARK: Initialization
    
    init?(name: String, value: String, restart: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        guard !value.isEmpty else {
            return nil
        }
        
        guard !restart.isEmpty else {
            return nil
        }
        // Initialize stored properties.
        self.name = name
        self.value = value
        self.restart = restart
        
    }
}
