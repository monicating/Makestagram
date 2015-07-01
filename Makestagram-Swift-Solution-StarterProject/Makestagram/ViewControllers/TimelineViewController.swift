//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Monica on 6/29/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var photoTakingHelper: PhotoTakingHelper?

    override func viewDidLoad() {
        super.viewDidLoad()
        // set TimelineViewController to tabBarController's delegate
        self.tabBarController?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1
        let followingQuery = PFQuery(className: "Follow")
        followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
        
        // 2
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers!.whereKey("user", matchesKey: "toUser", inQuery: followingQuery)
        
        // 3
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        // 4
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        // 5
        query.includeKey("user")
        // 6
        query.orderByDescending("createdAt")
        
        // 7
        query.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            // 8
            self.posts = result as? [Post] ?? []
            // 9
            self.tableView.reloadData()
        }
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
