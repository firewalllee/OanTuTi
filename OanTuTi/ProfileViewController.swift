//
//  ProfileViewController.swift
//  OanTuTi
//
//  Created by Phuc on 11/6/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {

    //MARK:- Mapped items
    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var lblWins: UILabel!
    @IBOutlet weak var lblLosts: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var wrapTextfield: UIView!
    @IBOutlet weak var txtDisplayName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var wrapTextfieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet var tapImage: UITapGestureRecognizer!
    
    //MARK: - Declarations
    var isUpdating:Bool = false
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var imgData: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        
        //Listen Update event from server
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientUpdateProfileRs) { (data, ack) in
            
            if let response: Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                if let isSuccess: Bool = response[Contants.Instance.isSuccess] as? Bool {
                    //-------CheckUpdate----------------------------
                    if isSuccess {
                        if let newAvatarUrl: String = response[Contants.Instance.newAvatarUrl] as? String {
                            myProfile.update(name: self.txtDisplayName.text!, avatar: newAvatarUrl)
                            self.lblDisplayName.text = myProfile.name
                        }
                        //-------Clean textfield password--------------
                        self.txtPassword.text = Contants.Instance.null
                        self.txtNewPassword.text = Contants.Instance.null
                        self.isUpdating = false
                        //-------Dismiss loading alert-----------------
                        self.dismiss(animated: true) {
                            self.showNotification(title: "Notice!", message: "Update successful!")
                        }
                    } else {
                        //-------Dismiss loading alert-----------------
                        self.dismiss(animated: true) {
                            //-------Clean textfield password--------------
                            self.txtPassword.text = Contants.Instance.null
                            self.txtNewPassword.text = Contants.Instance.null
                            self.isUpdating = false
                            if let message: String = response[Contants.Instance.message] as? String {
                                self.showNotification(title: "Notice!", message: message)
                            }
                            
                        }
                    }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        //Init 3 textfield will hide and scale to 0.1 belong y coordinate

        if !self.isUpdating {
            self.wrapTextfieldHeightConstraint.constant = 0
            self.wrapTextfield.isHidden = true
            self.tapImage.isEnabled = false
            self.wrapTextfield.layer.transform = CATransform3DMakeScale(1, 0.1, 1)
        }
        //Load user infor
        self.loadInfo()
        //Make scale animation
        self.wrapView.rotateXAxis()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.imgAvatar.clipsToBounds = true
    }
    
    func viewProperties(){
        self.btnEdit.lightBorder(with: 8)
        self.imgAvatar.lightBorder(with: 4)
    }
    
    //MARK: - Textfield delegate
    //Return keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            self.txtPassword.becomeFirstResponder()
        } else if textField.tag == 1 {
            self.txtNewPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.btnEditUpdate(self.btnEdit)
        }
        return true
    }
    //Begin edit
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            moveTextField(moveDistance: -35, up: true)
        } else if textField.tag == 2 {
            moveTextField(moveDistance: -85, up: true)
        }
    }
    //End edit
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            moveTextField(moveDistance: -35, up: false)
        } else if textField.tag == 2 {
            moveTextField(moveDistance: -85, up: false)
        }
    }

    //Load information of user when view have loaded
    func loadInfo() {
        if let name: String = myProfile.name {
            self.lblDisplayName.text = name
            self.txtDisplayName.text = name
        }
        if let coins: Int = myProfile.coin_card {
            self.lblCoins.text = "\(coins)"
        }
        if let wins: Int = myProfile.statis?.wins {
            self.lblWins.text = "\(wins) Wins"
        }
        if let losts: Int = myProfile.statis?.wins {
            self.lblLosts.text = "\(losts) Lost"
        }
        self.lblEmail.text = User_mail
        if imgData != nil {
            self.imgAvatar.image = UIImage(data: imgData)
        } else if let myAvatar:String = myProfile.avatar {
            imgAvatar.loadAvatar(myAvatar)
        }
    }
    
    
    //MARK: - Edit tasks
    @IBAction func btnEditUpdate(_ sender: UIButton) {
        
        //isUpdating:true =
        if self.isUpdating {
            UIView.animate(withDuration: 0.3, animations: {
                self.wrapTextfield.layer.transform = CATransform3DMakeScale(1, 0.1, 1)
                
                }, completion: { (true) in
                    UIView.animate(withDuration: 0.3, animations: {
                        //height of 3 textfield will be 0
                        self.wrapTextfieldHeightConstraint.constant = 0
                        self.view.layoutIfNeeded()
                        self.wrapTextfield.isHidden = true
                        self.wrapTextfield.isUserInteractionEnabled = false
                        self.tapImage.isEnabled = false
                        self.btnEdit.setTitle("Edit", for: .normal)
                    })
                    
            })
            self.emitUpdate()
//            self.isUpdating = false
        } else {
            self.wrapTextfield.isHidden = false
            self.wrapTextfield.isUserInteractionEnabled = true
            self.tapImage.isEnabled = true
            UIView.animate(withDuration: 0.3, animations: {
                self.wrapTextfield.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (true) in
                    //height of 3 textfield will be defaults
                    self.wrapTextfieldHeightConstraint.constant = 130
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                        self.btnEdit.setTitle("Update", for: .normal)
                    }
            })
            self.isUpdating = true

        }
        
    }
    
    func emitUpdate() {
        
        let email: String = User_mail
        let nickname: String = self.txtDisplayName.text!
        let oldPass: String = self.txtPassword.text!
        let newPass: String = self.txtNewPassword.text!
        
        if oldPass == Contants.Instance.null {
            self.isUpdating = false
        } else if newPass.characters.count != 0 && newPass.characters.count < 6 {
            self.showNotification(title: "Password!", message: "Your new password must be at least 6 characters")
        } else if nickname == Contants.Instance.null {
            self.showNotification(title: "Nickname!", message: "Please fill out your Nickname")
        } else if newPass == Contants.Instance.null {
            //Waiting indicator
            self.waitingIndicator(with: indicator)
            if self.imgData == nil {
                self.imgData = UIImagePNGRepresentation(imgAvatar.image!)
            }
            let jsonData: Dictionary<String, Any> = [Contants.Instance.email: email, Contants.Instance.oldPass: oldPass, Contants.Instance.newPass: oldPass, Contants.Instance.file: self.imgData, Contants.Instance.nickname: nickname]
            SocketIOManager.Instance.socketEmit(Commands.Instance.ClientUpdateProfile, jsonData)
        } else {
            self.waitingIndicator(with: self.indicator)
            if self.imgData == nil {
                self.imgData = UIImagePNGRepresentation(imgAvatar.image!)
            }
            let jsonData: Dictionary<String, Any> = [Contants.Instance.email: email, Contants.Instance.oldPass: oldPass, Contants.Instance.newPass: newPass, Contants.Instance.file: self.imgData, Contants.Instance.nickname: nickname]
            SocketIOManager.Instance.socketEmit(Commands.Instance.ClientUpdateProfile, jsonData)
        }
    }
    
    //MARK: - Select Image tasks
    @IBAction func tapToSelectImage(_ sender: UITapGestureRecognizer) {
        
        resignFirstResponder()
        
        let imgPicker:UIImagePickerController = UIImagePickerController()
        imgPicker.delegate = self
        
        let alert:UIAlertController = self.selectImageFromDevice(imgPicker)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Make extension ProfileViewController
extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // Reduce size photos before uploading
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageSelected = info [UIImagePickerControllerOriginalImage] as? UIImage {
            
            let imageValue:CGFloat = max(imageSelected.size.height, imageSelected.size.width)
            
            if imageValue > 3000 {
                imgData = UIImageJPEGRepresentation(imageSelected, 0.1)
            }
            if imageValue > 2000 {
                imgData = UIImageJPEGRepresentation(imageSelected, 0.5)
            } else {
                imgData = UIImagePNGRepresentation(imageSelected)
            }
            
            imgAvatar.image = UIImage(data: imgData)
            self.isUpdating = true
            self.wrapTextfield.isUserInteractionEnabled = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}


