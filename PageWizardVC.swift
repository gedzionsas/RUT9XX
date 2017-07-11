//
//  PageWizardVC.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 14/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

class PageWizardVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, PassNextdataDelegate, PassNextdataDelegate2, PassNextdataDelegate3 {
    
    let token = UserDefaults.standard.value(forKey: "saved_token")
    let SIM_PIN_UNREGISTERED_STATE = "pin required"
    let SIM_CARD_INSERTED_STATE = "inserted"
    
    func passNextPageData() {
        self.pageControl.currentPage = 1
         let controller = VCArr[1]
         setViewControllers([controller], direction: .forward, animated: true, completion: nil)

    }
    func passNextPageData3() {
        self.pageControl.currentPage = 3
        let controller = VCArr[3]
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        
    }
    func passNextPageData2() {
        self.pageControl.currentPage = 2
        let controller = VCArr[2]
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        
    }
    
    
    lazy var VCArr: [UIViewController] = {
        return [self.VCInstance(name: "PinVC"), self.VCInstance(name: "MobileVC"), self.VCInstance(name: "WirelessVC"), self.VCInstance(name: "RouterPassVC")]
    }()

    var pageControl = UIPageControl()
    
    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:name)
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
         self.dataSource = self
         self.delegate = self
        
        
    //    self.pageControl.backgroundColor = .clear
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        if let firstVC = VCArr.first {
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        (VCArr[0] as! SimPinController).delegate = self
        (VCArr[1] as! MobileWizardController).delegate = self
        (VCArr[2] as! WirelessWizardController).delegate = self


        configurePageControl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //       self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        performSimCardCheckTask(){ (result) in
        print(result, "dasresa")
            
        
        if result[1] == self.SIM_CARD_INSERTED_STATE {
            if result[0] == self.SIM_PIN_UNREGISTERED_STATE
            {
                self.delegate = nil
                self.dataSource = nil
            }
        } else {
            self.setViewControllers([self.VCArr[1]], direction: .forward, animated: true, completion: nil)
            self.pageControl.currentPage = self.VCArr.index(of: self.VCArr[1])!

            }
        
        }
        
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return VCArr.last
        }
        
        guard VCArr.count > previousIndex else {
            return nil
        }
        
        return VCArr[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VCArr.count else {
            return VCArr.first
        }
        
        guard VCArr.count > nextIndex else {
            return nil
        }
        var vc = VCArr[nextIndex]
        switch(nextIndex) {
        case 0: (vc as! SimPinController).delegate = self
        case 1: (vc as! MobileWizardController).delegate = self
        case 2: (vc as! WirelessWizardController).delegate = self
        default: break
        
        }
        return vc 
    }

    func configurePageControl() {
        // The total number of pages that are available
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = VCArr.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.blue
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black

        self.pageControl.backgroundColor = UIColor.clear
        self.view.addSubview(pageControl)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = VCArr.index(of: pageContentViewController)!
    }
    
    
    func performSimCardCheckTask(complete: @escaping ([String])->()){
        Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: "-u") { (json) in
            MethodsClass().processJsonStdoutOutput(response_data: json){ (checkIfSimPinIsEntered) in
                print(checkIfSimPinIsEntered)
                Json().aboutDevice(token: self.token as! String, command: "gsmctl", parameter: "-z") { (json1) in
                    MethodsClass().processJsonStdoutOutput(response_data: json1){ (simCardStateResult) in
                        print(simCardStateResult)
                        var array = [checkIfSimPinIsEntered, simCardStateResult]
                        complete (array)
                    }}}}
    }

    
    
    
    
    
    
    
}
