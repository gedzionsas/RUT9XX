//
//  MethodsClass.swift
//  rutxxx_IOS
//
//  Created by Gedas Urbonas on 21/02/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit
import SwiftyJSON

public class MethodsClass: UIViewController {
  
  public func jsonResultObject (response_data: Any?) -> [Any?] {
    var result: [Any]
    if let jsonDic = response_data as? [String: Any] {
      result = jsonDic["result"] as! [Any]
      print("veik", result)
    } else {
      result = [""]
    }
    return result
  }
  
  public func processJsonSizeOutput (response_data: Any?, complete: (String)->()){
    
    var result = ""
    if let jsonDic = response_data as? JSON {
      if (jsonDic["result"].exists()){
        for item in jsonDic["result"].arrayValue {
          result = item["size"].stringValue
        }
        complete(result)
      } else {
        result = ""
        complete(result)
      }
    }else {
      print("klaida")
    }
  }
    
  public func formatMacNumber (response_dat: String)->(String){
        
        var strArray = Array(response_dat.characters).map { String($0) }
        let chunkSize = 2
        let sepratedString = stride(from: 0, to: strArray.count, by: chunkSize).map {
            Array(strArray[$0..<min($0 + chunkSize, strArray.count)]).joined()
            }.joined(separator: ":")
        
        return sepratedString
    }
    
  public func processJsonStdoutOutput (response_data: Any?, complete: (String)->()){
    
    var result = ""
    if let jsonDic = response_data as? JSON {
      if (jsonDic["result"].exists()){
        for item in jsonDic["result"].arrayValue {
          result = item["stdout"].stringValue
        }
        complete(result)
      } else {
        result = ""
        complete(result)
      }
    }else {
      print("klaida")
    }
  }
  public func parseFirmwareInformation (response_data: Any?, complete: (String)->()){
    
    var result = ""
    if let jsonDic = response_data as? JSON {
      if (jsonDic["result"].exists()){
        for item in jsonDic["result"].arrayValue {
          result = item["data"].stringValue
        }
        complete(result)
      } else {
        result = ""
        complete(result)
      }
    }else {
      print("klaida")
    }
  }

    public func getJsonArrayValue (response_data: Any?, complete: ([String])->()){
        
        var gotDeviceInterface = [""]
        let valueString = "value"
        
        if let jsonDic = response_data as? JSON {
            if (jsonDic["result"].exists()){
                for item in jsonDic["result"].arrayValue {
                    gotDeviceInterface = item[valueString].arrayValue.map { $0.stringValue}
                }
                complete(gotDeviceInterface)
            } else {
                gotDeviceInterface = [""]
                complete(gotDeviceInterface)
            }
        }else {
            print("klaida")
        }
    }
  public func getJsonValue (response_data: Any?, complete: (String)->()){
    
    var gotDeviceInterface = ""
    let valueString = "value"
    if let jsonDic = response_data as? JSON {
      if (jsonDic["result"].exists()){
        for item in jsonDic["result"].arrayValue {
          gotDeviceInterface = item[valueString].stringValue
          
        }
        complete(gotDeviceInterface)
      } else {
        gotDeviceInterface = ""
        complete(gotDeviceInterface)
      }
    }else {
      print("klaida")
    }
  }
  public func processedDataArrayString(response_data: String, complete: @escaping ([String])->()){
    var lines: [String] {
      return response_data.components(separatedBy: .newlines)
    }
    print(lines)
    complete(lines)
  }
    public func checkForBraces(value: String, complete: (String)->()){
    var result = ""
    if(value == "'") {
    result = value.replacingOccurrences(of: "'", with: "")
    } else {
    result = value
    }
    complete(result)
    }
  
}
