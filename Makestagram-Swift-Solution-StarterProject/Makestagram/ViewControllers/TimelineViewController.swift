//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Monica on 6/29/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

var photoTakingHelper: PhotoTakingHelper?

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
            takePhoto()
            return false
        } else {
            return true
        }
    }
    
    func takePhoto() {
        // instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            // code for closure - function without a name
            // println("received a callback")

            let post = Post()
            post.image = image
            post.uploadPost()
        }
        
        /* alternative way of writing without trailing closure
        PhotoTakingHelper(viewController: self.tabBarController!, callback: { (image: UIImage?) in
            // don't do anything, yet...
        })
        */

    }
    
}
