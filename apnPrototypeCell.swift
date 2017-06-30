//
//  apnPrototypeCell.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 24/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit




class apnPrototypeCell: UITableViewCell, UITextFieldDelegate {

    var textFieldEddited: Bool = false


    @IBOutlet weak var apnTextField: UITextField!
    
    @IBOutlet weak var apnNameTextField: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        apnTextField.delegate = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @IBAction func editttingEnded(_ sender: Any) {
//        Rut9xxSettingsInformationModel().routerInformationSettingsModel(){ (result) in
//            if !(self.apnTextField.text?.trimmingCharacters(in: .whitespaces) == result[2].trimmingCharacters(in: .whitespaces)) {
//                print("notmatch", result[2], self.apnTextField.text!)
//                if self.delegate != nil {
//                    self.delegate?.passTextData(string: self.apnTextField.text!)
//                }            } else {
//                print("match")
//                if self.delegate != nil {
//                    self.delegate?.passTextData(string: self.apnTextField.text!)
//                }
//            }
//        }
//        
//    }
//    

    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Leaving textField")
        var textFieldEddited: Bool = true

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("pabaiga")

    }
}


