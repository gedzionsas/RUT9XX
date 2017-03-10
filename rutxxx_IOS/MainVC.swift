//
//  MainVC.swift
//  bandymasAlam
//
//  Created by Gedas Urbonas on 13/02/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var menuView: UIView!
  let section = ["MOBILE", "WIRELESS"]
  
  
  @IBOutlet var leadingConstraintForSlideMenu: NSLayoutConstraint!
  @IBAction func logOutButton(_ sender: Any) {
    
    UserDefaults.standard.setValue("00000000000000000000000000000000", forKey: "saved_token")
    dismiss(animated: true, completion: nil)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier :"LoginVC")
    self.present(viewController, animated: true)
    
    UserDefaults.standard.setValue(false, forKey: "isLoggedIn")
    UserDefaults.standard.synchronize()

    
  }
  var menuShowing = false
  

  @IBOutlet var tableView: UITableView!
  
  override func viewDidLoad() {
    
    
    super.viewDidLoad()
    MainWindowModel().mainTasks(param1: "")
    
    menuView.layer.shadowOpacity = 1
    menuView.layer.shadowRadius = 6
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.section [section]
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.section.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   return 6
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell1", for: indexPath)

    return cell
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
