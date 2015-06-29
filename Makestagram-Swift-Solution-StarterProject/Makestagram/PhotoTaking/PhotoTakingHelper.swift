//
//  PhotoTakingHelper.swift
//  Makestagram
//
//  Created by Monica on 6/29/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

// callback of PhotoTakingHelper must have this signature
typealias PhotoTakingHelperCallback = UIImage? -> Void

class PhotoTakingHelper: NSObject {
    
    /** View controller on which AlertViewController and UIImagePicker are presented */
    weak var viewController: UIViewController!
    var callback: PhotoTakingHelperCallback
    var imagePickerController: UIImagePickerController?
    
    init(viewController: UIViewController, callback: PhotoTakingHelperCallback) {
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection() {
        // Allow user to choose between photo library and camera - Actionsheet displays popup at bottom of screen
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
        
        // Add 3 UIAlertActions to Alert Controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Only show camera option if rear camera is available
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default) { (action) in
                // do nothing yet...
            }
            
            alertController.addAction(cameraAction)
        }
        
        // Allow user to pick image from library
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) { (action) in
            // do nothing yet...
        }
        
        alertController.addAction(photoLibraryAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
        
    }
   
}
