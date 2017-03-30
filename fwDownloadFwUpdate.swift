//
//  fwDownloadFwUpdateViewController.swift
//  rutxxx_IOS
//
//  Created by Gedas Urbonas on 17/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class fwDownloadFwUpdate: UIViewController {
  internal func fwDownloadUpdateTask (complete: ()->()){
    
    let token = UserDefaults.standard.value(forKey: "saved_token")
    
    var testFileSize = "0"
    var downloadedImageSizeValue = ""
    
    Json().infoAboutFirmware(token: token as! String, param1: "stat", param2: "/tmp/firmware.img") { (sizeValue) in
      MethodsClass().processJsonSizeOutput(response_data: sizeValue){ (value) in
        if value.isEmpty {
          Json().downloadNewFirmware(token: token as! String){ (newFirmwareValue) in
            var i = 1
            while !(downloadedImageSizeValue == testFileSize){
              testFileSize = downloadedImageSizeValue
              Json().infoAboutFirmware(token: token as! String, param1: "stat", param2: "/tmp/firmware.img") { (sizeDownloadValue) in
                MethodsClass().processJsonSizeOutput(response_data: sizeDownloadValue){ (response) in
                  downloadedImageSizeValue = response
                  i += 1
                }
                
              }
            }
            
          }
          // complete()
        }
        
        Json().aboutDevice(token: token as! String, command: "/sbin/chkimage", parameter: "/tmp/firmware.img") { (value) in
          MethodsClass().processJsonStdoutOutput(response_data: value){ (checkValue) in
            if !checkValue.isEmpty {
              if !(checkValue == "0") {
                print("Updating", checkValue)
                Json().updateNewFirmware(token: token as! String) { (value) in
                }
                
              }
              
            }
          }}
      }
    }
    complete()
  }
}
