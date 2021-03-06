//
//  FwUpdateController.swift
//  rutxxx_IOS
//
//  Created by Gedas Urbonas on 15/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class FwUpdateController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var fwUpdateData = [dataToShow]()
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var refresh: UIRefreshControl!
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        fwDownloadFwUpdate().fwDownloadUpdateTask(){ () in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
    }
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        refresh = UIRefreshControl()
        tableView.addSubview(refresh)
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(FwUpdateController.refreshData), for: UIControlEvents.valueChanged)
        
        
        updateButton.layer.cornerRadius = 15
        updateButton.isHidden = true
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        FwUpdateModel().fwUpdateTask(){ (result) in
            var newFwVersion = result[2].lowercased()
            if (newFwVersion.range(of: "No".lowercased()) != nil) || (newFwVersion.range(of: "n/a".lowercased()) != nil){
                self.updateButton.isHidden = true
            } else {
                self.updateButton.isHidden = false
            }
            UserDefaults.standard.setValue(result, forKey: "fwupdate_array")
            self.updateUI(array: UserDefaults.standard.array(forKey: "fwupdate_array") as! [String])
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func refreshData() {
        
        
        FwUpdateModel().fwUpdateTask(){ (result) in
            self.fwUpdateData.removeAll()
            var newFwVersion = result[2].lowercased()
            if (newFwVersion.range(of: "No".lowercased()) != nil) || (newFwVersion.range(of: "n/a".lowercased()) != nil){
                self.updateButton.isHidden = true
            } else {
                self.updateButton.isHidden = false
            }
            UserDefaults.standard.setValue(result, forKey: "fwupdate_array")
            self.updateUI(array: UserDefaults.standard.array(forKey: "fwupdate_array") as! [String])
            
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fwUpdateData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "fwUpdateCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? fwUpdateCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let row = fwUpdateData[indexPath.row]
        
        cell.nameOfCell.text = row.name
        cell.valueOfCell.text = row.value
        
        return cell
    }
    
    
    private func updateUI(array: [String]) {
        guard let row1 = dataToShow(name: "FW version", value: (UserDefaults.standard.value(forKey: "devicefirmware_number") as? String)!) else {
            fatalError("Unable to instantiate row1")
        }
        guard let row2 = dataToShow(name: "Build data", value: array[0]) else {
            fatalError("Unable to instantiate row2")
        }
        guard let row3 = dataToShow(name: "Kernel version", value: array[1]) else {
            fatalError("Unable to instantiate row3")
        }
        guard let row4 = dataToShow(name: "New version", value: array[2]) else {
            fatalError("Unable to instantiate row4")
        }
        fwUpdateData += [row1, row2, row3, row4]
        tableView.reloadData()
    }
    
    
}
