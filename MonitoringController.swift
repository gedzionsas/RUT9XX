//
//  MonitoringController.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 12/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class MonitoringController: UITableViewController {
    private let ENABLE = "enable"
    private let HOSTNAME = "hostname"
    private let PORT = "port"
    private let CONNECTION_STATE = "connectionState"
    private let LAN_MAC_ADDRESS = "lanMacAddress"
    let section = ["Remote Access Control", "Status"]
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func switchTapped(_ sender: Any) {
        tableView.beginUpdates()
        tableView.endUpdates()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }

    @IBOutlet weak var connectionState: UILabel!
    @IBOutlet weak var lanMacAdressField: UILabel!
    @IBOutlet weak var serialNumberField: UILabel!
    @IBOutlet weak var monitoringField: UILabel!
    @IBOutlet weak var portField: UITextField!
    @IBOutlet weak var hostNameField: UITextField!
    @IBOutlet weak var switchButton: UISwitch!
    var pickerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(onSave))
        // Do any additional setup after loading the view, typically from a nib.
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

        performMonitoringGetDataTask()
        

        
        self.navigationItem.rightBarButtonItem?.isEnabled = false

    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        headerView.backgroundColor = UIColor.white
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        topBorder.backgroundColor = UIColor.init(red: CGFloat(12/255.0), green: CGFloat(87/255.0), blue: CGFloat(168/255.0), alpha: CGFloat(1.0))
        let bottomBorder = UIView(frame: CGRect(x: 0, y: headerView.frame.size.height - 1, width: tableView.frame.size.width, height: 1))
        bottomBorder.backgroundColor = UIColor.init(red: CGFloat(12/255.0), green: CGFloat(87/255.0), blue: CGFloat(168/255.0), alpha: CGFloat(1.0))
        let label = UILabel(frame: CGRect(x: 15, y: 11, width: tableView.frame.size.width - 15, height: 22))
        label.text = self.section [section]
        label.textColor = UIColor.init(red: CGFloat(12/255.0), green: CGFloat(87/255.0), blue: CGFloat(168/255.0), alpha: CGFloat(1.0))
        headerView.addSubview(topBorder)
        headerView.addSubview(label)
        headerView.addSubview(bottomBorder)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 1 && switchButton.isOn == false {
                return 0.0
            } else {
                return 44
            }
        } else {
            if indexPath.row == 0 {
                return 58
            } else {
                return 70.0
            }
        }

    }
    

    func onSave() {
        var switchValue = getSwitchValue(Switch: switchButton)
        performMonitoringSetData(switchValue: switchValue, hostnameValue: hostNameField.text!, portValue: portField.text!)
        
    }

    @IBAction func hostNameEdittingEnd(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    @IBAction func portEditingEnded(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    func performMonitoringGetDataTask() {
        MonitoringGetDataModel().monitoringModel(){ (result) in
            
            MethodsClass().checkForBraces(value: result[self.ENABLE] as! String){ (enable) in
                self.checkSwitchPosition(value: enable)
   
            MethodsClass().checkForBraces(value: result[self.HOSTNAME] as! String){ (hostname) in
                self.hostNameField.text = hostname
            }
            MethodsClass().checkForBraces(value: result[self.PORT] as! String){ (port) in
                self.portField.text = port
            }
            MethodsClass().checkForBraces(value: result[self.CONNECTION_STATE] as! String){ (connectionStateValue) in
                if enable == "0" {

                } else {
                    self.connectionState.text = connectionStateValue
                    self.tableView.reloadData()
                }
                
            }
            MethodsClass().checkForBraces(value: result[self.LAN_MAC_ADDRESS] as! String){ (lanmacAddress) in
                self.lanMacAdressField.text = lanmacAddress.uppercased()
            }
            var serialNumber = UserDefaults.standard.value(forKey: "deviceserial_number") as! String
            self.serialNumberField.text = serialNumber
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            
            }
        }
    }
    func performMonitoringSetData(switchValue: String, hostnameValue: String, portValue: String) {
        MonitoringSetDataModel().monitoringModel(switchValue: switchValue, hostnameValue: hostnameValue, portValue: portValue){ (result) in

            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    
    
    func getSwitchValue (Switch: UISwitch)->(String){
    var switchValue = ""
    if(Switch.isOn){
        switchValue = "1"
    }else{
        switchValue = "0"
      }
    return switchValue
    }
    
    func checkSwitchPosition(value: String){
    let enableString = "Enabled", disabledString = "Disabled"
    
    if(value == "1"){
        switchButton.isOn = true
        monitoringField.text = enableString
    }else{
        switchButton.isOn = false
        monitoringField.text = disabledString
    }
    }
    

}
