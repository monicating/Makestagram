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
    
    var posts: [Post] = []
    var photoTakingHelper: PhotoTakingHelper?

    override func viewDidLoad() {
        super.viewDidLoad()
        // set TimelineViewController to tabBarController's delegate
        self.tabBarController?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1 - create query for people the current user follows
        let followingQuery = PFQuery(className: "Follow")
        followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
        
        // 2 - create query for posts created by people current user follows
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers!.whereKey("user", matchesKey: "toUser", inQuery: followingQuery)
        
        // 3 - create query for posts current user created
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        // 4 - combined query of 2 and 3
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        // 5 - combined query includes user associated with post
        query.includeKey("user")
        // 6 - results displayed in chronological order
        query.orderByDescending("createdAt")
        
        // 7 - kick off network request
        query.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            // 8 - store posts in array of type [Post]
            self.posts = result as? [Post] ?? []
            
            // loop through posts from timeline query
            for post in self.posts {
                let data = post.imageFile?.getData()            // download image file
                post.image = UIImage(data: data!, scale:1.0)    // turn into UIImage instance and store in image property of post
            }
            
            // 9 - refresh tableView
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

extension TimelineViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count         // # of rows = # of posts
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell

        // cell.textLabel!.text = "Post"
        cell.postImageView.image = posts[indexPath.row].image
        return cell
    }
}
