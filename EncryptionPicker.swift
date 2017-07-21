//
//  EncryptionPicker.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 12/05/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

protocol PassMEncryptiondataDelegate {
    
    func passEncryptionData(value: String)
}


class EncryptionPicker: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate : PassMEncryptiondataDelegate?
    
    
    let encryption_array = ["No encryption", "WEP open system", "WEP shared key", "WPA-PSK", "WPA2-PSK", "WPA-PSK/WPA2-PSK mixed mode"]
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func doneButton(_ sender: Any) {
        if delegate != nil {
            let row = pickerView.selectedRow(inComponent: 0)
            self.delegate?.passEncryptionData(value: encryption_array[row])
        }
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return encryption_array.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return encryption_array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(encryption_array[row])
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
