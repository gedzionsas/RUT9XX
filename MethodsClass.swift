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
        print(response_data)
        if let jsonDic = response_data as? JSON {
              print(jsonDic)
            if (jsonDic["result"].exists()){
                print(jsonDic["result"]["stdout"].stringValue)
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
}
