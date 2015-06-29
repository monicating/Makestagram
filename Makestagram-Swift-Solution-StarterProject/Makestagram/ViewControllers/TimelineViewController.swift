//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Monica on 6/29/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set TimelineViewController to tabBarController's delegate
        self.tabBarController?.delegate = self
    }
    
}

// MARK: Tab Bar Delegate

extension TimelineViewController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController is PhotoViewController) {
            println("Take Photo")
            return false
        } else {
            return true
        }
    }
    
}
