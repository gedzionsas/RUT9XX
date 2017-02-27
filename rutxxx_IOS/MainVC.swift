//
//  MainVC.swift
//  bandymasAlam
//
//  Created by Gedas Urbonas on 13/02/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
  
  @IBOutlet var menuView: UIView!
  
  
  @IBOutlet var leadingConstraintForSlideMenu: NSLayoutConstraint!
  var menuShowing = false
  
  
  override func viewDidLoad() {
    
    
    super.viewDidLoad()
    MainWindowModel().mainTasks(param1: "")
    
    menuView.layer.shadowOpacity = 1
    menuView.layer.shadowRadius = 6
  }
  
  @IBAction func menuBarButton(_ sender: Any) {
    
    if (menuShowing) {
      leadingConstraintForSlideMenu.constant = -240
      UIView.animate(withDuration: 0.3, animations: {
        self.view.layoutIfNeeded()})
    } else {
      leadingConstraintForSlideMenu.constant = 0
      
      UIView.animate(withDuration: 0.3, animations: {
        self.view.layoutIfNeeded()
      })
     
    }
    menuShowing = !menuShowing
  }
}
