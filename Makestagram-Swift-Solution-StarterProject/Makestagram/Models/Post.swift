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
        imageFile.save()
        
        self.imageFile = imageFile
        save()
    }
    
}