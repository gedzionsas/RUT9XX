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
        edgesForExtendedLayout = []
        let webViewUrlRequest = URLRequest(url: IP!)
        webView.loadRequest(webViewUrlRequest)
        webView.scalesPageToFit = true
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.automaticallyAdjustsScrollViewInsets  = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
