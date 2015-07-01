//
//  PhotoTakingHelper.swift
//  Makestagram
//
//  Created by Monica on 7/1/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

// typealias provides function signature with name - signature of PhotoTakingHelper's callback
typealias PhotoTakingHelperCallback = UIImage? -> Void

class PhotoTakingHelper : NSObject {
    
    /** View controller on which AlertViewController and UIImagePickerController are presented */
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
        // Allow user to choose between photo library and camera; .ActionSheet popup displayed at bottom of screen
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
        
        // 3 UIAlertActions - 3 buttons on popup
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Only show camera option if rear camera is available
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default) { (action) in
                self.showImagePickerController(.Camera)
            }
            
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) { (action) in
            self.showImagePickerController(.PhotoLibrary)
        }
        
        alertController.addAction(photoLibraryAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        // sourceType is specified - camera or photo library
        imagePickerController!.sourceType = sourceType
        // extend to set up delegate property of imagePickerController
        imagePickerController!.delegate = self
        
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
    
}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // implement 2 different delegate methods
    
    // image is selected
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        callback(image)
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // cancel button tapped - hide Image Picker Controller
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
