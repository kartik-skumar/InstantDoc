//
//  DashTabBarViewController.swift
//  InstantDoc
//
//  Created by Kartik's MacG on 11/05/18.
//  Copyright © 2018 kaTRIX. All rights reserved.
//

import Foundation
import UIKit

class DashTabBarViewController: UIViewController {
    
    enum TabIndex : Int {
        case dashboardTab = 0
        case profileTab = 1
    }
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var tabView: UISegmentedControl!
    
    var currentViewController: UIViewController?
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "dashboardVC")
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "profileVC")
        return secondChildTabVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabView.selectedSegmentIndex = TabIndex.dashboardTab.rawValue
        displayCurrentTab(TabIndex.dashboardTab.rawValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            vc.view.frame = self.baseView.bounds
            self.baseView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.dashboardTab.rawValue :
            vc = firstChildTabVC
        case TabIndex.profileTab.rawValue :
            vc = secondChildTabVC
        default:
            return nil
        }
        
        return vc
    }
}

