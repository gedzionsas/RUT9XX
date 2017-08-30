//
//  Rut8xxSystemRouterDetails.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 08/08/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class Rut8xxSystemRouterDetails: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var refresh: UIRefreshControl!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var routerDetails = [dataToShow]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh = UIRefreshControl()
        tableView.addSubview(refresh)
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(Rut8xxSystemRouterDetails.refreshData), for: UIControlEvents.valueChanged)
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        tableView.delegate = self
        tableView.dataSource = self
        
        Rut9xxRouterDetailsModel().routerDetailsModel(){ (result) in
            print("reiksmes", result)
            var finalResult = result
            finalResult.remove(at: 1)
            UserDefaults.standard.setValue(finalResult, forKey: "routerdetails_array")
            self.updateUI(array: UserDefaults.standard.array(forKey: "routerdetails_array") as! [String])
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }

        self.tableView.tableFooterView = UIView()

    }

    func refreshData() {
        Rut9xxRouterDetailsModel().routerDetailsModel(){ (result) in
            self.routerDetails.removeAll()
            var finalResult = result
            finalResult.remove(at: 1)
            UserDefaults.standard.setValue(finalResult, forKey: "routerdetails_array")
            self.updateUI(array: UserDefaults.standard.array(forKey: "routerdetails_array") as! [String])
            
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routerDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "systemCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Rut8xxRouterDetailssystemCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let row = routerDetails[indexPath.row]
        
        cell.name.text = row.name
        cell.value.text = row.value
        
        return cell
    }
    
    
    private func updateUI(array: [String]) {
        guard let row1 = dataToShow(name: "Serial", value: array[0]) else {
            fatalError("Unable to instantiate row1")
        }
        guard let row2 = dataToShow(name: "IMEI", value: array[1]) else {
            fatalError("Unable to instantiate row2")
        }
        guard let row4 = dataToShow(name: "WLAN MAC", value: array[3]) else {
            fatalError("Unable to instantiate row4")
        }
        guard let row5 = dataToShow(name: "FW version", value: array[2]) else {
            fatalError("Unable to instantiate row5")
        }
        routerDetails += [row1, row2, row4, row5]
        tableView.reloadData()
    }

}

