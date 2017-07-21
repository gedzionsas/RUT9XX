//
//  ServiceModePicker.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 09/05/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit
protocol PassServiceesdataDelegate {
    
    func passServicesData(value: String)
}


class ServiceModePicker: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate : PassServiceesdataDelegate?
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func doneButton(_ sender: Any) {
        if delegate != nil {
            let row = pickerView.selectedRow(inComponent: 0)
            self.delegate?.passServicesData(value: createServiceList(value: checkRouterModule())[row])
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return createServiceList(value: checkRouterModule()).count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return createServiceList(value: checkRouterModule())[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(createServiceList(value: checkRouterModule())[row])
    }
    
    func checkRouterModule ()->[String: String]{
        var moduleService = "3G"
        var moduleService2 = "0"
        var objectDevices: [String: String] = [:]
        var vidValue = UserDefaults.standard.value(forKey: "modulevid_value") as? String
        var pidValue = UserDefaults.standard.value(forKey: "modulepid_value") as? String
        var moduleVidPid = vidValue! + ":" + pidValue!
        
        if (moduleVidPid == "12D1:1573" || moduleVidPid == "12D1:15C1" || moduleVidPid == "12D1:15C3") {
            moduleService = "LTE"
        } else if moduleVidPid == "1BC7:1201" {
            moduleService = "TelitLTE"
            moduleService2 = "2"
        } else if moduleVidPid == "1BC7:0036" {
            moduleService = "TelitLTE_V2"
            moduleService2 = "2"
        } else if moduleVidPid == "1199:68C0" {
            moduleService = "SieraLTE"
        } else if moduleVidPid == "05C6:9215" {
            moduleService = "QuectelLTE"
            moduleService2 = "2"
        } else if moduleVidPid == "1BC7:0021" {
            moduleService2 = "1"
        }
        
        objectDevices["ModuleService"] = moduleService
        objectDevices["ModuleService2"] = moduleService2
        objectDevices["VidPidValue"] = moduleVidPid
        return objectDevices
    }
    
    func createServiceList (value: [String: String])-> [String]{
        var moduleVidPid = ""
        var moduleService = ""
        var moduleService2 = ""
        var serviceArray = [String]()
        moduleService = value["ModuleService"]!
        moduleService2 = value["ModuleService2"]!
        moduleVidPid = value["VidPidValue"]!
        
        serviceArray.insert("2G only", at: 0)
        if moduleService2 == "0" {
            serviceArray.insert("2G preferred", at: 0)
        }
        serviceArray.insert("3G only", at: 0)
        if moduleService2 == "0" {
            serviceArray.insert("3G preferred", at: 0)
        }
        if moduleVidPid == "12D1:1573" || moduleVidPid == "1BC7:1201" || moduleVidPid == "12D1:15C1" || moduleVidPid == "12D1:15C3" || moduleService == "SieraLTE" || moduleService == "QuectelLTE" || moduleService == "TelitLTE_V2" {
            serviceArray.insert("4G (LTE) only", at: 0)
            if moduleService2 == "0" {
                serviceArray.insert("4G (LTE) preferred", at: 0)
            }
            if moduleVidPid == "12D1:1573" {
                serviceArray.insert("4G (LTE) and 3G only", at: 0)
            }
            serviceArray.insert("Automatic", at: 0)
        } else {
            serviceArray.insert("Automatic", at: 0)
        }
        return serviceArray
    }
    
}
