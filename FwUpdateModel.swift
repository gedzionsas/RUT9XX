//
//  FwUpdateModel.swift
//  rutxxx_IOS
//
//  Created by Gedas Urbonas on 15/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class FwUpdateModel: UIViewController {
    
    internal func fwUpdateTask (complete: @escaping ([String])->()){
        
        let token = UserDefaults.standard.value(forKey: "saved_token")
        var fwValue = ""
        
        Json().aboutDevice(token: token as! String, command: "uname", parameter: "-a") { (json) in
            MethodsClass().processJsonStdoutOutput(response_data: json){ (value) in
                UserDefaults.standard.setValue(value.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "fwinformation")
            }
            Json().aboutDevice(token: token as! String, command: "auto_update.sh", parameter: "check") { (newFirmwareValue) in
                MethodsClass().processJsonStdoutOutput(response_data: newFirmwareValue){ (value) in
                    if (!value.isEmpty){
                        if (value.range(of: "=") != nil){
                            let arrFirmwareValue = value.components(separatedBy: "=")
                            if (arrFirmwareValue[0].range(of: "error") != nil){
                                fwValue = "Not available"
                            } else {
                                fwValue = arrFirmwareValue[1]
                            }
                        } else {
                            fwValue = value
                        }
                    }
                    UserDefaults.standard.setValue(fwValue.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "fwValue")
                }
                if let stringValue = UserDefaults.standard.string(forKey: "fwinformation"), !stringValue.isEmpty {
                    let arrInfo = stringValue.components(separatedBy: " ")
                    var array = [String]()
                    var arrayForDate = [String]()
                    var stringOfDate = ""
                    
                    if !arrInfo[9].isEmpty && !arrInfo[5].isEmpty && !arrInfo[6].isEmpty && !arrInfo[7].isEmpty {
                        arrayForDate.append(arrInfo[9])
                        arrayForDate.append(FwUpdateModel().checkMonth(param: arrInfo[5]))
                        arrayForDate.append(arrInfo[6])
                        stringOfDate = arrayForDate.joined(separator: "-")
                        stringOfDate = stringOfDate + " \(arrInfo[7])"
                        print(stringOfDate)
                    } else {
                        stringOfDate = "Not data"
                    }
                    
                    array.append(stringOfDate)
                    array.append(FwUpdateModel().checkForEmptyData(param: arrInfo[2]))
                    array.append(FwUpdateModel().checkForEmptyData(param: UserDefaults.standard.string(forKey: "fwValue")!))
                    print(array)
                    complete(array)
                }
            }}
    }
    
    func checkForEmptyData(param: String) -> String {
        var result = ""
        if param.isEmpty {
            result = "Not available"
        } else if (param.range(of: "no_new") != nil) {
            result = "No new version"
        } else {
            result = param
        }
        
        return result
    }
    
    
    func checkMonth(param: String) -> String {
        var result = ""
        var monthList: [String] = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"]
        var intList: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        
        let value = param.lowercased()
        var i = 0
        while !(monthList[i] == value){
            i += 1
        }
        if intList[i] < 10 {
            result = "0\(intList[i])"
        } else {
            result = "\(intList[i])"
        }
        return result
    }
}


