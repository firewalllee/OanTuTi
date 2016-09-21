//
//  ProfileViewController.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 9/20/16.
//  Copyright © 2016 Lee Nguyen. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

     var imageData:NSData!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtNickName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func updateButton(sender: AnyObject) {
        let password = txtPassword.text!

        txtEmail.text = FIRAuth.auth()?.currentUser?.email
        txtNickName.text = FIRAuth.auth()?.currentUser?.displayName
        
        
        // Upload avatar lên storage.
        let avatarRef = storageRef.child("AvatarImage/\(FIRAuth.auth()?.currentUser?.email).jpg")
        let uploadTask = avatarRef.putData(self.imageData, metadata: nil){ (metadata, error) in
            if error != nil {
                // Thông báo upload avatar thất bại.
                let alertFailToUploadAvatar = UIAlertController(title: ":'(", message: "Upload avatar fail, can try later!", preferredStyle: .Alert)
                let okButton2 = UIAlertAction(title: "Ok", style: .Cancel, handler: { (UIAlertAction) in
                })
                alertFailToUploadAvatar.addAction(okButton2)
                self.presentViewController(alertFailToUploadAvatar, animated: true, completion: nil)
                
            }
            else {
                // Upload ảnh lên và cập nhật thông tin profile.
                let downloadURL = metadata!.downloadURL()
                let user = FIRAuth.auth()?.currentUser
                
                if let user = user {
                    let changeRequest = user.profileChangeRequest()
                    FIRAuth.auth()?.currentUser?.updatePassword(password, completion: nil)
                    changeRequest.displayName = self.txtNickName.text!
                    changeRequest.photoURL = downloadURL
                    changeRequest.commitChangesWithCompletion({ (error) in
                        if error == nil {
                            let alertUpdateSuccessful = UIAlertController(title: ":'(", message: "Update profile successful!", preferredStyle: .Alert)
                            let okButton3 = UIAlertAction(title: "Ok", style: .Cancel, handler: { (UIAlertAction) in
                            })
                            alertUpdateSuccessful.addAction(okButton3)
                            self.presentViewController(alertUpdateSuccessful, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
        uploadTask.resume()
    }
    
    @IBAction func tapToSelectImage(sender: UITapGestureRecognizer) {
        resignFirstResponder()
        
        let imagePicker = UIImagePickerController()
        
        // Action sheeet để chọn nguồn ảnh.
        let listSelectSource = UIAlertController(title: "Choose source", message: "Phot Library or Camera", preferredStyle: .ActionSheet)
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .Default) { (UIAlertAction) in
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        let camera = UIAlertAction(title: "Camera", style: .Default) { (UIAlertAction) in
            imagePicker.sourceType = .Camera
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (UIAlertAction) in
        }
        
        listSelectSource.addAction(photoLibrary)
        listSelectSource.addAction(camera)
        listSelectSource.addAction(cancel)
        
        presentViewController(listSelectSource, animated: true, completion: nil)
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // Giảm kích thước ảnh trước khi upload.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageSelected = info [UIImagePickerControllerOriginalImage] as! UIImage
        
        let imageValue = max(imageSelected.size.height, imageSelected.size.width)
        
        if imageValue > 3000 {
            imageData = UIImageJPEGRepresentation(imageSelected, 0.1)
        }
        if imageValue > 2000 {
            imageData = UIImageJPEGRepresentation(imageSelected, 0.5)
        }
        else {
            imageData = UIImagePNGRepresentation(imageSelected)
        }
        
        avatarImage.image = UIImage(data: imageData)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}