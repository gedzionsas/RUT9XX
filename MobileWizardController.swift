//
//  MobileWizardController.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 19/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

protocol PassNextdataDelegate2 {
    
    func passNextPageData2()
}

class MobileWizardController: UITableViewController, PassauthdataDelegate, PassOperatorsdataDelegate {
    var delegate: PassNextdataDelegate2?
    
    
    //   let backgroundImage = UIImage(named: "background.png")
    @IBAction func operatorButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "operatorsId") as! OperatorPicker
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func passOperatorsData(value: String, apnValue: String) {
        operatorButton.setTitle(value, for: .normal)
        apnTextField.text = apnValue
        tableView.reloadData()
        UserDefaults.standard.setValue(value, forKey: "operator_profile_value")
        UserDefaults.standard.setValue(apnTextField.text, forKey: "apn_value")
    }
    
    func passAuthData(value: String) {
        authValue = value
        authenticationButton.setTitle(value, for: .normal)
        tableView.reloadData()
        UserDefaults.standard.setValue(value, forKey: "mobileauthentication_value")
        if !(value.lowercased() == none) || !(value.lowercased() == noData) {
            if usernamefield.text == "" || passwordField.text == "" {
                usernameLabel.textColor = UIColor.red
                passwordLabel.textColor = UIColor.red
            }
        }
    }
    
    @IBAction func authenticationButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "authenticationId") as! AuthenticationPicker
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func apnEndEditing(_ sender: Any) {
        if apnTextField.text == apnValues {
        } else {
            UserDefaults.standard.setValue(apnTextField.text, forKey: "apn_value")
        }
    }
    @IBAction func usernameEndEditing(_ sender: Any) {
        usernameLabel.textColor = UIColor.white
        if usernamefield.text == usernameValues {
        } else {
            UserDefaults.standard.setValue(usernamefield.text, forKey: "authentication_username")
            
        }
    }
    @IBAction func passwordEndEditing(_ sender: Any) {
        passwordLabel.textColor = UIColor.white
        if passwordField.text == passwordValues {
        } else {
            UserDefaults.standard.setValue(passwordField.text, forKey: "authentication_password")
        }
    }
    @IBAction func apnEditingBegin(_ sender: Any) {
    }
    @IBAction func usernameEditingBegin(_ sender: Any) {
    }
    @IBAction func passwordEditingBegin(_ sender: Any) {
    }
    let none = "none"
    let noData = "no data"
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernamefield: UITextField!
    @IBOutlet weak var operatorButton: UIButton!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var apnTextField: UITextField!
    @IBOutlet weak var authenticationButton: UIButton!
    var roamingValue = ""
    var authValue = UserDefaults.standard.value(forKey: "mobileauthentication_value") as! String
    var apnValues = ""
    var usernameValues = ""
    var passwordValues = ""
    var headerHeight: CGFloat = 0.0
    //  var maindata = []
    
    @IBAction func switchButtonTapped(_ sender: Any) {
        if switchButton.isOn {
            roamingValue = "1"
        } else {
            roamingValue = "0"
        }
        UserDefaults.standard.setValue(roamingValue, forKey: "roaming_value")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        if UserDefaults.standard.value(forKey: "authentication_password") != nil {
            passwordValues = ""
        }
        if UserDefaults.standard.value(forKey: "authentication_username") != nil {
            usernameValues = ""
        }
        if UserDefaults.standard.value(forKey: "apn_value") != nil {
            apnValues = ""
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //       self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "background.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFill
        
        headerHeight = (tableView.frame.size.height - CGFloat(Int(70) * tableView.numberOfRows(inSection: 0))) / 2
        
        print(headerHeight, self.tableView.rowHeight)
        
        if (authValue.range(of: "No data") != nil) {
            authenticationButton.setTitle("None", for: .normal)
        } else {
            authenticationButton.setTitle(authValue, for: .normal)
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 102
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame: CGRect = tableView.frame
        let NextBut: UIButton = UIButton(frame: CGRect(x:frame.size.width - 130, y:0, width:200, height: headerHeight))
        let SkipBut: UIButton = UIButton(frame: CGRect(x:-70, y:0, width:200, height: headerHeight))
        SkipBut.setTitle("SKIP", for: .normal)
        SkipBut.backgroundColor = UIColor.clear
        SkipBut.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        SkipBut.addTarget(self, action: #selector(MobileWizardController.skipPressed(_:)), for: .touchUpInside)
        
        NextBut.setTitle("NEXT", for: .normal)
        NextBut.backgroundColor = UIColor.clear
        NextBut.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        NextBut.addTarget(self, action: #selector(MobileWizardController.pressed(_:)), for: .touchUpInside)
        let headerView: UIView = UIView(frame: CGRect(x:0, y:0, width: frame.size.height, height: headerHeight))
        headerView.addSubview(NextBut)
        headerView.addSubview(SkipBut)
        
        return headerView
    }
    
    
    func pressed(_ sender: UIButton!) {
        if self.delegate != nil {
            self.delegate?.passNextPageData2()
        }
    }
    
    func skipPressed(_ sender: UIButton!) {
        dismiss(animated: true, completion: nil)
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "MainVC")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //  cell.backgroundColor = UIColor(white: 0, alpha: 0.1)
        cell.backgroundColor = UIColor.clear
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var authenticationValue = authValue
        if authenticationValue.lowercased() == none || authenticationValue == noData {
            if indexPath.row == 4 || indexPath.row == 5 {
                usernamefield.text = ""
                passwordField.text = ""
                return 0
                
            } else {
                return 75
            }
        } else {
            return 75
            
        }
    }
    
    
    
}
