//
//  UpdateViewController.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 10/15/16.
//  Copyright © 2016 Lee Nguyen. All rights reserved.
//

import UIKit
import Firebase

class UpdateViewController: UIViewController, UITextFieldDelegate {

    var imageData:Data!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtNickname: UITextField!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet var tapImage: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
            updateButton.isHidden = true
            txtEmail.isEnabled = false
            txtEmail.backgroundColor = UIColor(Hex: 0xe3e3e3)
            txtPassword.isEnabled = false
            txtPassword.backgroundColor = UIColor(Hex: 0xe3e3e3)
            txtNewPassword.isEnabled = false
            txtNewPassword.backgroundColor = UIColor(Hex: 0xe3e3e3)
            txtNickname.isEnabled = false
            txtNickname.backgroundColor = UIColor(Hex: 0xe3e3e3)
            tapImage.isEnabled = false
            
            txtEmail.text = FIRAuth.auth()?.currentUser?.email
            txtNickname.text = FIRAuth.auth()?.currentUser?.displayName
            avatarImage.loadUpdateAvatar((FIRAuth.auth()?.currentUser?.photoURL)!)

            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func updateButton(_ sender: AnyObject) {
        
        updateButton.isEnabled = false
        
        let alertActivity = UIAlertController(title: "\n\n" + "Loading", message: "", preferredStyle: .alert)
        let activity = UIActivityIndicatorView(frame: alertActivity.view.bounds)
        activity.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        activity.isUserInteractionEnabled = false
        activity.color = UIColor.gray
        alertActivity.view.addSubview(activity)
        
        if ((txtNewPassword.text?.characters.count)! > 0 && (txtNewPassword.text?.characters.count)! < 6) || (txtNickname.text?.characters.count)! < 4 {
            let alertPasswordTooShort = UIAlertController(title: "Come on!", message: "Your password(<6) or Nickname(<4) so short, let's try again!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Try again", style: .cancel, handler: { (UIAlertAction) in
                self.updateButton.isEnabled = true
            })
            alertPasswordTooShort.addAction(ok)
            present(alertPasswordTooShort, animated: true, completion: nil)

            
        } else {
 
            FIRAuth.auth()?.signIn(withEmail: txtEmail.text!, password: txtPassword.text!, completion: { (user, error) in
                if error == nil {
                    activity.startAnimating()
                    self.present(alertActivity, animated: true, completion: nil)
                    
                    // Thay đổi password.
                    if self.txtNewPassword.text?.characters.count != 0 {
                        user?.updatePassword(self.txtNewPassword.text!, completion: { (Error) in
                        })
                    }
                    
                    let avatarRef = storageRef.child("AvatarImage/\(self.txtEmail.text).jpg")
                    let uploadTask = avatarRef.put(self.imageData, metadata: nil){ (metadata, error) in
                        if error != nil {
                            // Thông báo upload avatar thất bại.
                            let alertFailToUploadAvatar = UIAlertController(title: ":'(", message: "Upload avatar fail, can try later!", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                            })
                            alertFailToUploadAvatar.addAction(ok)
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
                                        activity.stopAnimating()
                                        alertActivity.dismiss(animated: true, completion: nil)
                                        
                                        let alertRegisterSuccessful = UIAlertController(title: "Successfull :)", message: "Your account has been updated", preferredStyle: .alert)
                                        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                                            
                                            self.updateButton.isEnabled = true
                                            self.updateButton.isHidden = true
                                            self.editButton.isHidden = false
                                            self.txtPassword.isEnabled = false
                                            self.txtPassword.text = ""
                                            self.txtPassword.backgroundColor = UIColor(Hex: 0xe3e3e3)
                                            self.txtNewPassword.isEnabled = false
                                            self.txtNewPassword.text = ""
                                            self.txtNewPassword.backgroundColor = UIColor(Hex: 0xe3e3e3)
                                            self.txtNickname.isEnabled = false
                                            self.txtNickname.backgroundColor = UIColor(Hex: 0xe3e3e3)
                                            
                                            
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
                    let alertPasswordNotMatch = UIAlertController(title: "Sorry!", message: "Your password incorrect", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                        self.updateButton.isEnabled = true
                    })
                    alertPasswordNotMatch.addAction(ok)
                    self.present(alertPasswordNotMatch, animated: true, completion: nil)

                }
            })
            

            
        }
        
    }
    
    @IBAction func editButton(_ sender: AnyObject) {
        updateButton.isHidden = false
        editButton.isHidden = true
        txtPassword.isEnabled = true
        txtPassword.backgroundColor = UIColor(Hex: 0xffffff)
        txtNewPassword.isEnabled = true
        txtNewPassword.backgroundColor = UIColor(Hex: 0xffffff)
        txtNickname.isEnabled = true
        txtNickname.backgroundColor = UIColor(Hex: 0xffffff)
        tapImage.isEnabled = true
        imageData = UIImagePNGRepresentation(avatarImage.image!)
    }

    @IBAction func tapToSelectImage(_ sender: AnyObject) {
        resignFirstResponder()
        
        let imagePicker = UIImagePickerController()
        
        // Action sheeet để chọn nguồn ảnh.
        let listSelectSource = UIAlertController(title: "Choose source", message: "Photo Library or Camera", preferredStyle: .actionSheet)
        
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
    
    // Back button
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Keyboard show.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtNickname {
            moveTextField(textField: textField, moveDistance: -70, up: true)
        }
        if textField == txtPassword {
            moveTextField(textField: textField, moveDistance: -85, up: true)
        }
        if textField == txtNewPassword {
            moveTextField(textField: textField, moveDistance: -155, up: true)
        }
    }
    
    // Keyboard hide.
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtNickname {
            moveTextField(textField: textField, moveDistance: -70, up: false)
        }
        if textField == txtPassword {
            moveTextField(textField: textField, moveDistance: -85, up: false)
        }
        if textField == txtNewPassword {
            moveTextField(textField: textField, moveDistance: -155, up: false)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension UpdateViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
