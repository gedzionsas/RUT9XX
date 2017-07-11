//
//  InputOutputController.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 05/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit
import TwicketSegmentedControl


class InputOutputController: UIViewController, TwicketSegmentedControlDelegate {

    
    var segmentValue: Int = 0

    
    func didSelect(_ segmentIndex: Int) {
        segmentValue = segmentIndex
        updateView()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false

        setupView()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    private func setupView() {
        setupSegmentedControl()
        
        
        updateView()
    }
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        
        
        let titles = ["Status", "Input", "Output"]
        let frame = CGRect(x: 5, y: view.frame.height / 2 - 20, width: view.frame.width - 10, height: 40)
        
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self
        view.addSubview(segmentedControl)
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.sliderBackgroundColor = UIColor.init(red: CGFloat(12/255.0), green: CGFloat(87/255.0), blue: CGFloat(168/255.0), alpha: CGFloat(1.0))
        
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        self.navigationItem.titleView = segmentedControl
        
        //        wirelessMobileSegment.removeAllSegments()
        //        wirelessMobileSegment.insertSegment(withTitle: "Mobile", at: 0, animated: false)
        //        wirelessMobileSegment.insertSegment(withTitle: "Wireless", at: 1, animated: false)
        //        wirelessMobileSegment.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        //
        //        // Select First Segment
        //        wirelessMobileSegment.selectedSegmentIndex = 0
    }
    
    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    
    
    private lazy var statusController: StatusController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "Status") as! StatusController
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var inputController: InputController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "Input") as! InputController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var outputController: OutputController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "Output") as! OutputController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        // Add Child View as Subview
        view.addSubview(viewController.view)
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    private func updateView() {
        if  segmentValue == 0 {
            remove(asChildViewController: inputController)
            add(asChildViewController: statusController)
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else if segmentValue == 1 {
            remove(asChildViewController: statusController)
            add(asChildViewController: inputController)
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
        } else {
            remove(asChildViewController: statusController)
            add(asChildViewController: outputController)
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    
    
}
