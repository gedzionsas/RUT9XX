//
//  AboutController.swift
//  rutxxx_IOS
//
//  Created by Gedas Urbonas on 07/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class AboutController: UIViewController {
  
  @IBOutlet weak var rightsLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        self.versionLabel.text = "Version: \(version)"
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
