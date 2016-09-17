//
//  RegisterViewController.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 9/16/16.
//  Copyright © 2016 Lee Nguyen. All rights reserved.
//

import UIKit
import Firebase

let storage = FIRStorage.storage()
let storageRef = storage.referenceForURL("gs://oan-tu-ti.appspot.com")

class RegisterViewController: UIViewController{

    var imageData:NSData!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtNickname: UITextField!
    @IBOutlet weak var avatarImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageData = UIImagePNGRepresentation(UIImage(named: "avatar")!)
        logining()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        // kiem tra nhap mat khau tren 6 ki tu va nickname tren 4 ki tu.
        if txtPassword.text?.characters.count < 6 && txtNickname.text?.characters.count < 4 {
            let alertPasswordTooShort = UIAlertController(title: "Come on!", message: "Your password(<6) or Nickname(<4) so short, let's try again!", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Try again", style: .Cancel, handler: { (UIAlertAction) in
            })
            alertPasswordTooShort.addAction(ok)
            presentViewController(alertPasswordTooShort, animated: true, completion: nil)
            
        }
        else {
            FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                if error == nil {
                    FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
                    })
                    // Upload avatar lên storage.
                    let avatarRef = storageRef.child("AvatarImage/\(email).jpg")
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
                                changeRequest.displayName = self.txtNickname.text!
                                changeRequest.photoURL = downloadURL
                                changeRequest.commitChangesWithCompletion({ (error) in
                                    if error == nil {
                                        self.switchSence()
                                    }
                                })
                            }
                        }
                    }
                    uploadTask.resume()
                    
                }
                else {
                    // Thông báo đăng kí tài khoản thất bại.
                    let alertFailToCreateAccount = UIAlertController(title: "Email", message: "Your email has been existing", preferredStyle: .Alert)
                    let okButton3 = UIAlertAction(title: "Ok", style: .Cancel, handler: { (UIAlertAction) in
                    })
                    alertFailToCreateAccount.addAction(okButton3)
                    self.presentViewController(alertFailToCreateAccount, animated: true, completion: nil)
                }
            }
        }
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
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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