//
//  fwDownloadFwUpdateViewController.swift
//  rutxxx_IOS
//
//  Created by Gedas Urbonas on 17/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class fwDownloadFwUpdate: UIViewController {
  internal func fwDownloadUpdateTask (complete: @escaping ()->()){

    let token = UserDefaults.standard.value(forKey: "saved_token")

    var testFileSize = "0"
    var downloadedImageSizeValue = [String]()
    
    Json().infoAboutFirmware(token: token as! String, param1: "stat", param2: "/tmp/firmware.img") { (newFirmwareValue) in
      print(newFirmwareValue)
      MethodsClass().processJsonStdoutOutput(response_data: newFirmwareValue){ (value) in
    print("nuidi", value)
//    downloadedImageSizeValue[0] = value
//        if downloadedImageSizeValue[0].isEmpty {
//          Json().downloadNewFirmware(token: token as! String){ (newFirmwareValue) in
//            var i = 1
//            while !(downloadedImageSizeValue[0]){
//              i += 1
          //  }

        //  }
    //    }
        
  }
      complete()
    }
    
    }
}
