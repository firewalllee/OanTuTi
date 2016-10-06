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
let storageRef = storage.reference(forURL: "gs://oan-tu-ti.appspot.com")

class RegisterViewController: UIViewController{

    var imageData:Data!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtNickname: UITextField!
    @IBOutlet weak var avatarImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        
        imageData = UIImagePNGRepresentation(UIImage(named: "avatar")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func registerButton(_ sender: UIButton) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        // kiem tra nhap mat khau tren 6 ki tu va nickname tren 4 ki tu.
        if (txtPassword.text?.characters.count)! < 6 && (txtNickname.text?.characters.count)! < 4 {
            let alertPasswordTooShort = UIAlertController(title: "Come on!", message: "Your password(<6) or Nickname(<4) so short, let's try again!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Try again", style: .cancel, handler: { (UIAlertAction) in
            })
            alertPasswordTooShort.addAction(ok)
            present(alertPasswordTooShort, animated: true, completion: nil)
            
        }
        else {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    })
                    // Upload avatar lên storage.
                    let avatarRef = storageRef.child("AvatarImage/\(email).jpg")
                    let uploadTask = avatarRef.put(self.imageData, metadata: nil){ (metadata, error) in
                        if error != nil {
                            // Thông báo upload avatar thất bại.
                            let alertFailToUploadAvatar = UIAlertController(title: ":'(", message: "Upload avatar fail, can try later!", preferredStyle: .alert)
                            let okButton2 = UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                            })
                            alertFailToUploadAvatar.addAction(okButton2)
                            self.present(alertFailToUploadAvatar, animated: true, completion: nil)
                            
                        }
                        else {
                            // Upload ảnh lên và cập nhật thông tin profile.
                            let downloadURL = metadata!.downloadURL()
                            let user = FIRAuth.auth()?.currentUser
                            
                            if let user = user {
                                let changeRequest = user.profileChangeRequest()
                                changeRequest.displayName = self.txtNickname.text!
                                changeRequest.photoURL = downloadURL
                                changeRequest.commitChanges(completion: { (error) in
                                    if error == nil {
                                        let alertRegisterSuccessful = UIAlertController(title: "Successfull :)", message: "Your account has been create", preferredStyle: .alert)
                                        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                                            self.switchSence()
                                        })
                                        alertRegisterSuccessful.addAction(ok)
                                        self.present(alertRegisterSuccessful, animated: true, completion: nil)
                                    }
                                })
                            }
                        }
                    }
                    uploadTask.resume()
                    
                }
                else {
                    // Thông báo đăng kí tài khoản thất bại.
                    let alertFailToCreateAccount = UIAlertController(title: "Email", message: "Your email has been existing", preferredStyle: .alert)
                    let okButton3 = UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                    })
                    alertFailToCreateAccount.addAction(okButton3)
                    self.present(alertFailToCreateAccount, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func tapToSelectImage(_ sender: UITapGestureRecognizer) {
        resignFirstResponder()
        
        let imagePicker = UIImagePickerController()
        
        // Action sheeet để chọn nguồn ảnh.
        let listSelectSource = UIAlertController(title: "Choose source", message: "Phot Library or Camera", preferredStyle: .actionSheet)
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
        }
        
        listSelectSource.addAction(photoLibrary)
        listSelectSource.addAction(camera)
        listSelectSource.addAction(cancel)
        
        present(listSelectSource, animated: true, completion: nil)
    }

}


extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // Giảm kích thước ảnh trước khi upload.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
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
        
        dismiss(animated: true, completion: nil)
    }
    
}
