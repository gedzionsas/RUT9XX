//
//  Rut9xxServices.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 29/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class Rut9xxServices: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
var routerServices = [dataToShow]()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func switchButtonAction(_ sender: Any) {
        
        
    }
    @IBAction func restartAction(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
        Rut9xxServicesModel().routerServicesModel(){ (result) in

        var arraysOfNames: [String] = []
            
        if let path = Bundle.main.path(forResource: "Strings", ofType: "plist") {
            if let array = NSArray(contentsOfFile: path) as? [String] {
                for arrays in array {
                    arraysOfNames.append(arrays)
                    }}
            }
            
            print(arraysOfNames)
            
     //   UserDefaults.standard.setValue(result, forKey: "routerdetails_array")
            self.updateUI(names: arraysOfNames, array: result )
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routerServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "routerServicesCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ServicesCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let row = routerServices[indexPath.row]
        
        cell.servicesName.text = row.name
   //     cell.stateServices.s .valueOfInformation.text = row.value
        if row.value.isEmpty {
         ServicesCell().switchButton.isHidden = true
        } else {
            if checkIfSwitchIsOn(value: row.value) == true {
            } else {
                
            }

        }
        
        return cell
    }

    
    private func checkIfSwitchIsOn (value: String)-> (Bool){
        var result = false
        if value == "Enabled"  { result = true
            ServicesCell().switchButton.setOn(true, animated: false)
        }
        ServicesCell().switchButton.setOn(true, animated: false)
        return result
    }
    
    
    private func updateUI(names: [String], array: [String]) {
        var j = array.count
        var i = 0
        
        for valueArray in array {
        guard let row = dataToShow(name: names[i], value: array[i]) else {
            fatalError("Unable to instantiate row1")
            }
           routerServices += [row]
            i += 1
        }
        
        
        tableView.reloadData()
    }
    
}
