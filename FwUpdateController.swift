//
//  FwUpdateController.swift
//  rutxxx_IOS
//
//  Created by Gedas Urbonas on 15/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class FwUpdateController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var fwUpdateData = [dataToShow]()


  @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.delegate = self
      tableView.dataSource = self
      

       FwUpdateModel().fwUpdateTask(){ (result) in
        UserDefaults.standard.setValue(result, forKey: "fwupdate_array")
        self.updateUI(array: UserDefaults.standard.array(forKey: "fwupdate_array") as! [String])

      }
      
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fwUpdateData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
   let cellIdentifier = "fwUpdateCell"
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? fwUpdateCell else {
      fatalError("The dequeued cell is not an instance of MealTableViewCell.")
    }
    
    let row = fwUpdateData[indexPath.row]
    
    cell.nameOfCell.text = row.name
    cell.valueOfCell.text = row.value
    
    return cell
  }
  
  
  
  
  private func updateUI(array: [String]) {
      print(array[0])
  guard let row1 = dataToShow(name: "FW version", value: (UserDefaults.standard.value(forKey: "devicefirmware_number") as? String)!) else {
    fatalError("Unable to instantiate row1")
  }
  guard let row2 = dataToShow(name: "Build data", value: array[0]) else {
    fatalError("Unable to instantiate row2")
  }
  guard let row3 = dataToShow(name: "Kernel version", value: array[1]) else {
    fatalError("Unable to instantiate row3")
  }
  guard let row4 = dataToShow(name: "New version", value: array[2]) else {
    fatalError("Unable to instantiate row4")
  }
  fwUpdateData += [row1, row2, row3, row4]
    tableView.reloadData()
   
    }
}
