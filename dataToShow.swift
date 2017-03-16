//
//  dataToShow.swift
//  rutxxx_IOS
//
//  Created by Gedas Urbonas on 16/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class dataToShow {
  var name: String
  var value: String
  
  //MARK: Initialization
  
  init?(name: String, value: String) {
    
    // The name must not be empty
    guard !name.isEmpty else {
      return nil
    }
    
    // The rating must be between 0 and 5 inclusively
    guard !value.isEmpty else {
      return nil
    }
    
    // Initialize stored properties.
    self.name = name
    self.value = value
    
  }
}
