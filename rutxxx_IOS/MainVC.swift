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
    
 var mainData = [dataToShowMain]()
 var mainData2 = [dataToShowMain2]()
 var mainData3 = [dataToShowMainCircles]()
    var refresh: UIRefreshControl!

    
  let mobileNames = ["SIM CARD IN USE", "OPERATOR", "CONNECTION TYPE", "ROAMING STATUS"]
  let wirelessNames = ["WIRELESS NAME", "MODEL/CHANNEL", "ENCRYPTION", "CLIENTS"]
    

var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

  
  @IBAction func rebootButton(_ sender: Any) {
    let refreshAlert = UIAlertController(title: "Reboot", message: "Reboot router?", preferredStyle: UIAlertControllerStyle.alert)
    
    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in

      self.dismiss(animated: true, completion: nil)
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let viewController = storyboard.instantiateViewController(withIdentifier :"LoginVC")
      self.present(viewController, animated: true)
      let token = UserDefaults.standard.value(forKey: "saved_token")
      Json().aboutDevice(token: token as! String, command: "reboot", parameter: "config") { (json) in
        print("Reboot have been done")
      }
    }))
    
    refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
      print("Reboot Canceled")
    }))
    
    present(refreshAlert, animated: true, completion: nil)
    
  }
  
  
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
    
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    
    refresh = UIRefreshControl()
    tableView.addSubview(refresh)
    refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refresh.addTarget(self, action: #selector(MainVC.refreshData), for: UIControlEvents.valueChanged)
    
    
    activityIndicator.center = self.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    view.addSubview(activityIndicator)
    
    activityIndicator.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
    tableView.delegate = self
    tableView.dataSource = self

    MainWindowModel().mainTasks(){ (result) in
        print(result)
        UserDefaults.standard.setValue(result, forKey: "temp")
        let valuee = UserDefaults.standard.array(forKey: "temp")
        self.updateUIMain(value: valuee?[2] as! [String] , names: valuee?[3] as! [String])
        self.updateUI(valueMobile: valuee?[0] as! [String] , valueWireless: valuee?[1] as! [String])
        
        var valueMobileSignal = valuee![4] as? [String]
        var valueWirelessQuality = valuee![6] as? [String]
        var nameQuality = valuee![5] as? [String]
        let finalSignalValue = Double((valueMobileSignal?[0])!)
        let finalWirelessQuality = Int((valueWirelessQuality?[0])!)

        self.updateUIMainCircles(value: finalSignalValue!, wirelessValue: finalWirelessQuality!, stringQuality: (nameQuality?[0])! )
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    menuView.layer.shadowOpacity = 1
    menuView.layer.shadowRadius = 6
    

  }
  
    func refreshData() {
        
        MainWindowModel().mainTasks(){ (result) in
            self.mainData.removeAll()
            self.mainData2.removeAll()
            self.mainData3.removeAll()
            UserDefaults.standard.setValue(result, forKey: "temp")
            let valuee = UserDefaults.standard.array(forKey: "temp")
            self.updateUIMain(value: valuee?[2] as! [String] , names: valuee?[3] as! [String])
            self.updateUI(valueMobile: valuee?[0] as! [String] , valueWireless: valuee?[1] as! [String])
            
            var valueMobileSignal = valuee![4] as? [String]
            var valueWirelessQuality = valuee![6] as? [String]
            var nameQuality = valuee![5] as? [String]
            let finalSignalValue = Double((valueMobileSignal?[0])!)
            let finalWirelessQuality = Int((valueWirelessQuality?[0])!)
            
            self.updateUIMainCircles(value: finalSignalValue!, wirelessValue: finalWirelessQuality!, stringQuality: (nameQuality?[0])! )
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   return (mainData.count + mainData2.count + mainData3.count)
  }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
        return 80
        } else if indexPath.row == 1 {
        return 190
        } else {
            return 52
        }
    }

    
   
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    if indexPath.row == 0 {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell1", for: indexPath) as? MainPrototypeCell1 else {
            fatalError("The dequeued cell is not an instance of MainPrototypeCell1.")
        }
        let row = mainData2[indexPath.row]
        cell.uptimeLabel.text = row.nameUptime
        cell.uptimeValue.text = row.valueUptime
        cell.dataUsageLabel.text = row.nameDataUsage
        cell.dataUsageValue.text = row.valueDataUsage
        cell.clientsLabel.text = row.nameClients
        cell.clientsValue.text = row.valueClients
        return cell
    }
    else if indexPath.row == 1 {
        
        print(indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell2", for: indexPath) as? MainPrototypeCell2 else {
            fatalError("The dequeued cell is not an instance of MainPrototypeCell2.")
        }
        let row = mainData3[indexPath.row - 1]
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 3, delay: 0, options: [], animations: {
                cell.mobileStrenghtCircle.value = CGFloat(row.mobileStrenghtRing)
                cell.mobileStrenghtCircle.unitString = row.nameString
                cell.wirelessStrenghtCircle.value = CGFloat(row.wirelessQualityRing)
                
            }, completion: nil)
        }
        
        return cell
    } else {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell3", for: indexPath) as? MainPrototypeCell3 else {
            fatalError("The dequeued cell is not an instance of MainPrototypeCell3.")
        }
    let row = mainData[indexPath.row - 2]
    cell.labelOneField.text = row.nameMobile
    cell.labelTwoField.text = row.nameWireless
    
    cell.valueLabelOne.text = row.valueMobile
    cell.valueLabelTwo.text = row.valueWireless
        
        return cell
    }
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
    
    
    private func updateUI(valueMobile: [String], valueWireless: [String]) {
        let counted = valueMobile.count
        var i = 0
        for _ in valueMobile {
            guard let row = dataToShowMain(nameMobile: mobileNames[i], valueMobile: valueMobile[i], nameWireless:wirelessNames[i], valueWireless:valueWireless[i] ) else {
                fatalError("Unable to instantiate row1")
            }
            mainData += [row]
            i += 1
        }
      tableView.reloadData()
    }
    private func updateUIMain(value: [String], names: [String]) {
        var i = 0
            guard let row = dataToShowMain2(nameUptime: names[0], valueUptime: value[0], nameDataUsage:names[1], valueDataUsage:value[1],  nameClients:names[2], valueClients:value[2] ) else {
                fatalError("Unable to instantiate row1")
            }
            mainData2 += [row]
        tableView.reloadData()

    }
    private func updateUIMainCircles(value: Double, wirelessValue: Int, stringQuality: String) {
        guard let row = dataToShowMainCircles(mobileStrenghtRing: value, wirelessQualityRing: wirelessValue, nameString: stringQuality) else {
            fatalError("Unable to instantiate row1")
        }
        mainData3 += [row]
        tableView.reloadData()

        
    }

    
}
