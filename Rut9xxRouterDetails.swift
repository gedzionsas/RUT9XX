//
//  Rut9xxRouterDetails.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 28/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class Rut9xxRouterDetails: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var routerDetails = [dataToShow]()

    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var tableView: UITableView!
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
        
        Rut9xxRouterDetailsModel().routerDetailsModel(){ (result) in
            
        
        UserDefaults.standard.setValue(result, forKey: "routerdetails_array")
        self.updateUI(array: UserDefaults.standard.array(forKey: "routerdetails_array") as! [String])
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
        return routerDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "routerDetailsCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RouterDetailsCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let row = routerDetails[indexPath.row]
        
        cell.nameOfInformation.text = row.name
        cell.valueOfInformation.text = row.value
        
        return cell
    }
    
    
    private func updateUI(array: [String]) {
        guard let row1 = dataToShow(name: "Serial", value: array[0]) else {
            fatalError("Unable to instantiate row1")
        }
        guard let row2 = dataToShow(name: "IMEI", value: array[2]) else {
            fatalError("Unable to instantiate row2")
        }
        guard let row3 = dataToShow(name: "LAN MAC", value: array[1]) else {
            fatalError("Unable to instantiate row3")
        }
        guard let row4 = dataToShow(name: "WLAN MAC", value: array[4]) else {
            fatalError("Unable to instantiate row4")
        }
        guard let row5 = dataToShow(name: "FW version", value: array[3]) else {
            fatalError("Unable to instantiate row5")
        }
        routerDetails += [row1, row2, row3, row4, row5]
        tableView.reloadData()
    }

}
