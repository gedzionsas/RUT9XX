//
//  AuthenticationPicker.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 27/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

protocol PassauthdataDelegate {
    
    func passAuthData(value: String)
}



class AuthenticationPicker: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let authentication_array = ["None", "CHAP", "PAP"]
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var delegate : PassauthdataDelegate?
    
    
    
    @IBAction func doneButton(_ sender: Any) {
        if delegate != nil {
            let row = pickerView.selectedRow(inComponent: 0)
            self.delegate?.passAuthData(value: authentication_array[row])
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //  print(authentication_array.count)
        return authentication_array.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //  print(authentication_array[row])
        return authentication_array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(authentication_array[row])
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
