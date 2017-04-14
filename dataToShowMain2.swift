//
//  dataToShowMain2.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 11/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
class dataToShowMain2 {
    var nameUptime: String
    var valueUptime: String
    var nameDataUsage: String
    var valueDataUsage: String
    var nameClients: String
    var valueClients: String
    
    //MARK: Initialization
    
    init?(nameUptime: String, valueUptime: String, nameDataUsage: String, valueDataUsage: String, nameClients: String, valueClients: String) {
        
        // The name must not be empty
        guard !nameUptime.isEmpty else {
            return nil
        }
        
        guard !valueUptime.isEmpty else {
            return nil
        }
        guard !nameDataUsage.isEmpty else {
            return nil
        }
        
        guard !valueDataUsage.isEmpty else {
            return nil
        }
        guard !nameClients.isEmpty else {
            return nil
        }
        
        guard !valueClients.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.nameUptime = nameUptime
        self.valueUptime = valueUptime
        self.nameDataUsage = nameDataUsage
        self.valueDataUsage = valueDataUsage
        self.nameClients = nameClients
        self.valueClients = valueClients
        
    }
}
