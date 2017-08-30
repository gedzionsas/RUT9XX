//
//  SleepDelayPickerView.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 11/08/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

protocol PassSleepDelaydataDelegate {
    
    func passSleepDelayData(value: String)
}


class SleepDelayPickerView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate : PassSleepDelaydataDelegate?
    
    
    let sleepDelay_array = ["5 min.", "10 min.", "15 min.", "30 min."]

    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func doneButton(_ sender: Any) {
        if delegate != nil {
            let row = pickerView.selectedRow(inComponent: 0)
            self.delegate?.passSleepDelayData(value: sleepDelay_array[row])
        }
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sleepDelay_array.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sleepDelay_array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(sleepDelay_array[row])
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
