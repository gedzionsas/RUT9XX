//
//  WebUiController.swift
//  rutxxx_IOS
//
//  Created by Gedas Urbonas on 10/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit
import Foundation

class WebUiController: UIViewController {

  @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
   //   let IP = URL(string: "http://192.168.1.1")

      let webViewUrlRequest = URLRequest(url: IP!)
      webView.loadRequest(webViewUrlRequest)
      webView.scalesPageToFit = true

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
