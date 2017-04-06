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
    @IBAction func switchButtonAction(_ sender: UISwitch) {
        var checked = ""
        let point = sender.superview?.convert(sender.center, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: point!) {
            let row = routerServices[indexPath.row]
            row.value = sender.isOn ? "Enabled" : "Disabled"
            routerServices[indexPath.row] = row
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        

        if ((sender as AnyObject).isOn == true)
        {
        let point = sender.superview?.convert(sender.center, to: self.tableView)
        var stringRowNumber = String(indexPath.row)
                checked = "1"
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            Rut9xxServicesSetData().routerServicesSetDataModel(params: [stringRowNumber, checked]){ (result) in
                print("asdsa", result)
                if !(result == "") {
                  //  self.showAlert(error: result)
                    let alert = UIAlertController(title: "", message: result, preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)})

                    DispatchQueue.main.async {
                        let row = self.routerServices[indexPath.row]
                        row.value = sender.isOn ? "Enabled" : "Disabled"
                        self.routerServices[indexPath.row] = row
                        self.tableView.reloadRows(at: [indexPath], with: .automatic) 
                    }
                }
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            
        } else {
        checked = "0"
            print("gaidus", checked)
let point = sender.superview?.convert(sender.center, to: self.tableView)
                var stringRowNumber = String(indexPath.row)
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
            Rut9xxServicesSetData().routerServicesSetDataModel(params: [stringRowNumber, checked]){ (result) in
                if !(result == "") {
                    let alert = UIAlertController(title: "", message: result, preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)})
                    DispatchQueue.main.async {
                        let row = self.routerServices[indexPath.row]
                        row.value = sender.isOn ? "Enabled" : "Disabled"
                        self.routerServices[indexPath.row] = row
                        self.tableView.reloadRows(at: [indexPath], with: .automatic) 
                    }                }
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                }
        
            
    }
        }
    }
    
        
    @IBAction func restartAction(_ sender: UIButton) {
        let point = (sender as AnyObject).superview??.convert((sender as AnyObject).center, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: point!) {
            var stringRowNumber = String(indexPath.row)
            print(stringRowNumber)
        Rut9xxServicesRestartTask().routerRestartModel(params: stringRowNumber) { () in
            }
        }}
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
            
            print(result)
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

        if row.value.isEmpty {
            cell.switchButton.isHidden = true
        } else {
            cell.switchButton.isHidden = false
            cell.switchButton.isOn = (row.value == "Enabled")
        }
        
        cell.restartButton.isEnabled = cell.switchButton.isOn
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellheight = 70
        if ((UserDefaults.standard.value(forKey: "routerservices_status") as? Bool) == false) {
        if indexPath.row == 8 || indexPath.row == 17 {
            return 0
            }
        }
        
        return CGFloat(cellheight) 
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
    
    func showAlert(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)})
    }
}
