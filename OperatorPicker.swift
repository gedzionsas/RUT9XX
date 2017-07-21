//
//  OperatorPicker.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 28/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

protocol PassOperatorsdataDelegate {
    
    func passOperatorsData(value: String, apnValue: String)
}
class OperatorPicker: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    var delegate: PassOperatorsdataDelegate?
    var operators: [String] = []
    var operatorsApn: [String] = []
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneTapped(_ sender: Any) {
        if delegate != nil {
            let row = pickerView.selectedRow(inComponent: 0)
            self.delegate?.passOperatorsData(value: operators[row], apnValue: operatorsApn[row])
        }
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        var asda = separateOperatorsString()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return operators.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return operators[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    
    func separateOperatorsString()-> ([String]) {
        let operatorsString = UserDefaults.standard.value(forKey: "operators_value") as? String
        let operatorsArrFirst : [String] = operatorsString!.components(separatedBy: ",")
        var i = 1
        var j = 0
        operators.append("None")
        operatorsApn.append("")
        while i < operatorsArrFirst.count {
            j = 0
            let operatorsArr : [String] = operatorsArrFirst[i].components(separatedBy: ":")
            while j < operatorsArr.count {
                operators.append(operatorsArr[j])
                j = j + 1
                operatorsApn.append(operatorsArr[j])
                j += 1
            }
            i = i + 1
        }
        return operators
    }
    
}
