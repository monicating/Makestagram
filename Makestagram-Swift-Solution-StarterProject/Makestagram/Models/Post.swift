//
//  Post.swift
//  Makestagram
//
//  Created by Monica on 7/1/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse

// inherit from PFObject and implement PFSubclassing Protocol
class Post : PFObject, PFSubclassing {
    
    // properties this Parse class wants to access
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    var image: UIImage?
    var photoUploadTask: UIBackgroundTaskIdentifier?    // background task ID
    
    //MARK: PFSubclassing Protocol
    
    // create connection between Parse class and Swift class
    static func parseClassName() -> String {
        return "Post"
    }
    
    // boilerplate code - for any custom Parse class
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    
    func uploadPost() {
        // turn UIImage into NSData instance
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let imageFile = PFFile(data: imageData)
        
        // create background task with unique ID
        photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        
        // save imageFile
        imageFile.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            // called when image is finished uploading
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        
        // imageFile.saveInBackgroundWithBlock(nil)    // imageFile.save()
        
        // any uploaded post should be associated with the current user
        user = PFUser.currentUser()
        self.imageFile = imageFile
        saveInBackgroundWithBlock(nil)              //save()
    }
    
}