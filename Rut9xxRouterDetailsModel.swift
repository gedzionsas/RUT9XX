//
//  Rut9xxRouterDetailsModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 28/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class Rut9xxRouterDetailsModel: UIViewController {

    internal func routerDetailsModel (complete: @escaping ([String])->()){
        
     let serialNumber = UserDefaults.standard.value(forKey: "deviceserial_number")
     let formatedLanMacNumber = MethodsClass().formatMacNumber(response_dat: UserDefaults.standard.value(forKey: "devicelanmac_number") as! String)
     let imeiNumber = UserDefaults.standard.value(forKey: "deviceimei_number")
     let firmwareNumber = UserDefaults.standard.value(forKey: "devicefirmware_number")
        
        print("lanmac", UserDefaults.standard.value(forKey: "devicelanmac_number") as! String)
     let wlanMacNumber = MethodsClass().formatMacNumber(response_dat: calculateWlanMacAddress(number: UserDefaults.standard.value(forKey: "devicelanmac_number") as! String))

        var array = [String]()
        array.append(serialNumber as! String)
        array.append(formatedLanMacNumber as! String)
        array.append(imeiNumber as! String)
        array.append(firmwareNumber as! String)
        array.append(wlanMacNumber as! String)
        complete(array)
        
        
    }
    func calculateWlanMacAddress(number: String)->(String) {
        var result = "-"
        var firstTwoSymbols = ""
        let numberCharacters = NSCharacterSet.decimalDigits
        
        if (number != nil) {
            if number.range(of: "a") != nil || number.range(of: "b") != nil || number.range(of: "c") != nil || number.range(of: "d") != nil || number.range(of: "e") != nil || number.range(of: "f") != nil
            {
                firstTwoSymbols = String(number.characters.prefix(2))
            }
            if firstTwoSymbols == "00" {
                var calculationValue = hexCalculation(value: number)
                result = "00\(calculationValue)"
            }else if firstTwoSymbols.rangeOfCharacter(from: numberCharacters) != nil {
               var firstSymbol = String(number.characters.prefix(1))
                if firstSymbol == "0" {
                    var calculationValue = hexCalculation(value: number)
                    result = "0\(calculationValue)"
                } else {
                    result = hexCalculation(value: number)
                }
            }
        } else {
            result = "-"
        }
        return result
    }
    
    func hexCalculation(value: String)-> (String) {
        
        var result = " "

        var number:Int? = Int(value, radix: 16)!   // firstText is UITextField
        number = number! + 2
        result = (number?.toHexaString)!
        return result
    }
}

// extension which convert to another system
extension String {
    var drop0xPrefix:          String { return hasPrefix("0x") ? String(characters.dropFirst(2)) : self }
    var drop0bPrefix:          String { return hasPrefix("0b") ? String(characters.dropFirst(2)) : self }
    var hexaToDecimal:            Int { return Int(drop0xPrefix, radix: 16) ?? 0 }
    var hexaToBinaryString:    String { return String(hexaToDecimal, radix: 2) }
    var decimalToHexaString:   String { return String(Int(self) ?? 0, radix: 16) }
    var decimalToBinaryString: String { return String(Int(self) ?? 0, radix: 2) }
    var binaryToDecimal:          Int { return Int(drop0bPrefix, radix: 2) ?? 0 }
    var binaryToHexaString:    String { return String(binaryToDecimal, radix: 16) }
}

extension Int {
    var toBinaryString: String { return String(self, radix: 2) }
    var toHexaString:   String { return String(self, radix: 16) }
}
