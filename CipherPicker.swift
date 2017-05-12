//
//  CipherPicker.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 11/05/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

protocol PassCipherdataDelegate {
    
    func passCipherData(value: String)
}


class CipherPicker: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate : PassCipherdataDelegate?

    
    let cipher_array = ["Auto", "Force CCMP (AES)", "WEP shared key", "Force TKIP", "Force TKIP and CCMP (AES)"]
    
    @IBOutlet weak var pickerView: UIPickerView!

    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        if delegate != nil {
            let row = pickerView.selectedRow(inComponent: 0)
            print("nunu", cipher_array[row])
            self.delegate?.passCipherData(value: cipher_array[row])
        }
        dismiss(animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cipher_array.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cipher_array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(cipher_array[row])
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
