//
//  ModePicker.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 12/05/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

protocol PassModedataDelegate {
    
    func passModeData(value: String)
}


class ModePicker: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate : PassModedataDelegate?
    
    
    let mode_array = ["Auto", "802.11b", "802.11g", "802.11g+n"]
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        if delegate != nil {
            let row = pickerView.selectedRow(inComponent: 0)
            self.delegate?.passModeData(value: mode_array[row])
        }
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mode_array.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mode_array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(mode_array[row])
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
