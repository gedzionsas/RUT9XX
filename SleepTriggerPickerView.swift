//
//  SleepTriggerPickerView.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 11/08/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

protocol PassSleepTriggerdataDelegate {
    
    func passTriggerData(value: String)
}


class SleepTriggerPickerView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate : PassSleepTriggerdataDelegate?
    
    
    let sleepTrigger_array = ["Ignition", "Voltage", "Ignition & Voltage"]
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    

    @IBAction func doneButton(_ sender: Any) {
        if delegate != nil {
            let row = pickerView.selectedRow(inComponent: 0)
            self.delegate?.passTriggerData(value: sleepTrigger_array[row])
        }
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sleepTrigger_array.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sleepTrigger_array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(sleepTrigger_array[row])
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
    
}
