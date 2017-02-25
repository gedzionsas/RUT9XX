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
  
  public func processJsonStdoutOutput (response_data: Any?, complete: (String)->()){
    
    var result = ""
    if let jsonDic = response_data as? JSON {
      print(jsonDic)
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
  
  public func getJsonValue (response_data: Any?, complete: (String)->()){
    
    var gotDeviceInterface = ""
    var valueString = "value"
    if let jsonDic = response_data as? JSON {
      print(jsonDic)
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
  public func processedDataArrayString(response_data: String, complete: ([String])->()){
  let lines = response_data.components(separatedBy: .newlines)
    complete(lines)
  }
  
}
