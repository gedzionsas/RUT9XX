//
//  AboutController.swift
//  rutxxx_IOS
//
//  Created by Gedas Urbonas on 07/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

class AboutController: UIViewController {
    
    @IBOutlet weak var rightsLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkReachability() { success in

            
        }
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = "Version: \(version)"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func checkReachability(complete: (Bool)->()){
        if currentReachabilityStatus == .reachableViaWiFi {
            var dic = getWIFIInformation()
            if MAC_ADDRESS == dic["BSSID"]! {
                print(MAC_ADDRESS, dic)
            print("User is connected to the internet via wifi.")
            complete(true)
            } else {
                print("nera rysio")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = view
            }
        } else {
            print("There is no internet connection")
            complete(false)
        }
    }
    
    func getWIFIInformation() -> [String:String]{
        var informationDictionary = [String:String]()
        let informationArray:NSArray? = CNCopySupportedInterfaces()
        if let information = informationArray {
            let dict:NSDictionary? = CNCopyCurrentNetworkInfo(information[0] as! CFString)
            if let temp = dict {
                informationDictionary["SSID"] = String(describing: temp["SSID"]!)
                informationDictionary["BSSID"] = String(describing: temp["BSSID"]!)
                return informationDictionary
            }
        }
        
        return informationDictionary
    }

}
