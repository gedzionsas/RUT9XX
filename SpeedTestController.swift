//
//  SpeedTestController.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 07/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit
import MBCircularProgressBar


class SpeedTestController: UIViewController {
    var menuShowing = false
    
    let token = UserDefaults.standard.value(forKey: "saved_token")
    var threadEndValue = ""
    var fileResult = ""
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var circleProgress: MBCircularProgressBarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func menuButton(_ sender: Any) {
        if (menuShowing) {
            leadingConstraint.constant = -240
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()})
        } else {
            leadingConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
        menuShowing = !menuShowing
        
    }
    
    @IBAction func startButton(_ sender: Any) {
        
        let randomNum:UInt32 = arc4random_uniform(100)
        let someString:String = String(randomNum)
        
        if circleProgress.value == 10 {
            //            BG() {
            if (!someString.isEmpty) {
                Json().startSpeedTest(token: self.token as! String, fileValue: Int(randomNum)) { (json) in
                    print("veik", json)
                }}
            //}
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(47), execute: {
                // Put your code which should be executed with a delay here
                self.threadEndValue = "Started"
                //     while (!(self.fileResult.range(of: "Done") != nil)) {
                if(!(self.fileResult.range(of: "Access denied") != nil)) {
                    self.BG() {
                        Json().readSpeedTestFile(token: self.token as! String, fileValue: Int(randomNum)) { (json) in
                            print("veiksss", json)
                            //                                            if (!(json "Error")) {
                            //                                                fileResult = json
                            //                                            } else {
                            //                                                fileResult = "Done, Error"
                            //                                            }
                            // self.fileResult = "Done"
                            // }
                            
                        }
                    }
                }
                
            })
            
        }
    }
    
    
    
    
    func BG(_ block: @escaping ()->Void) {
        DispatchQueue.global(qos: .background).async(execute: block)
    }
    
    
}

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}
