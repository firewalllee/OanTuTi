//
//  ProfileViewController.swift
//  OanTuTi
//
//  Created by Phuc on 11/6/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK:- Mapped items
    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var containerView: UIView!
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
    @IBOutlet weak var bottomContainerContraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Declarations
    private var isUpdating:Bool = false
    private let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    private var sum:CGFloat!
    
    //MARK: - Define 
    private let textFieldHeight:CGFloat = 30
    private let defaultHeightUIViewContraint:CGFloat = 0
    private let limitationDistanceKeyboardAndTextField:CGFloat = 10
    private let wrapTextfieldHeight:CGFloat = 130
    private let durationUIViewAnimate:TimeInterval = 0.3
    private let emptyCharacters:Int = 0
    private let minimumCharacters:Int = 6
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        //Add observation from Listener class
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveEvent), name: NotificationCommands.Instance.profileDelegate, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.hideKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        //Init 3 textfield will hide and scale to 0.1 belong y coordinate

        if !self.isUpdating {
            self.wrapTextfieldHeightConstraint.constant = defaultHeightUIViewContraint
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
        self.imgAvatar.lightBorder(with: 8)
    }
    
    //MARK: - Listen function from Listener class - Main function -> Solve Profile tasks
    func receiveEvent(notification: Notification) {

        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            if let isSuccess: Bool = response[Contants.Instance.isSuccess] as? Bool {
                //-------CheckUpdate----------------------------
                if isSuccess {
                    if let newAvatarUrl: String = response[Contants.Instance.newAvatarUrl] as? String {
                        //myProfile.update(name: self.txtDisplayName.text!, avatar: newAvatarUrl)
                        MyProfile.Instance.name = self.txtDisplayName.text!
                        if let url:URL = URL(string: newAvatarUrl) {
                            do {
                                MyProfile.Instance.imgData = try Data(contentsOf: url)
                            } catch {
                                MyProfile.Instance.imgData = nil
                            }
                        }
                        
                        self.lblDisplayName.text = MyProfile.Instance.name
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

    @IBAction func txt_EditingBeign(_ sender: AnyObject) {
        
        let txt:UITextField = sender as! UITextField
        sum = wrapView.frame.origin.y + wrapTextfield.frame.origin.y + txt.frame.origin.y + textFieldHeight
    }
    

    //Load information of user when view have loaded
    func loadInfo() {
        if let name: String = MyProfile.Instance.name {
            self.lblDisplayName.text = name
            self.txtDisplayName.text = name
        }
        if let coins: Int = MyProfile.Instance.coin_card {
            self.lblCoins.text = "\(coins)"
        }
        if let wins: Int = MyProfile.Instance.statis?.wins {
            self.lblWins.text = "\(wins) Wins"
        }
        if let losts: Int = MyProfile.Instance.statis?.wins {
            self.lblLosts.text = "\(losts) Lost"
        }
        self.lblEmail.text = MyProfile.Instance.UserEmail
//        if imgData != nil {
//            self.imgAvatar.image = UIImage(data: imgData)
//        } else if let myAvatar:String = MyProfile.Instance.avatar {
//            imgAvatar.loadAvatar(myAvatar)
//        }
        
        if let imgData:Data = MyProfile.Instance.imgData {
            self.imgAvatar.image = UIImage(data: imgData)
        }
        
    }
    
    
    //MARK: - Edit tasks
    @IBAction func btnEditUpdate(_ sender: UIButton) {
        
        //isUpdating:true =
        if self.isUpdating {
            UIView.animate(withDuration: self.durationUIViewAnimate, animations: {
                self.wrapTextfield.layer.transform = CATransform3DMakeScale(1, 0.1, 1)
                
                }, completion: { (true) in
                    UIView.animate(withDuration: self.durationUIViewAnimate, animations: {
                        //height of 3 textfield will be 0
                        self.wrapTextfieldHeightConstraint.constant = self.defaultHeightUIViewContraint
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
            UIView.animate(withDuration: self.durationUIViewAnimate, animations: {
                self.wrapTextfield.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (true) in
                    //height of 3 textfield will be defaults
                    self.wrapTextfieldHeightConstraint.constant = self.wrapTextfieldHeight
                    UIView.animate(withDuration: self.durationUIViewAnimate) {
                        self.view.layoutIfNeeded()
                        self.btnEdit.setTitle("Update", for: .normal)
                    }
            })
            self.isUpdating = true

        }
        
    }
    
    func emitUpdate() {
        
        let email:String = MyProfile.Instance.UserEmail
        let nickname: String = self.txtDisplayName.text!
        let oldPass: String = self.txtPassword.text!
        let newPass: String = self.txtNewPassword.text!
        
        if oldPass == Contants.Instance.null {
            self.isUpdating = false
        } else if newPass.characters.count != emptyCharacters && newPass.characters.count < minimumCharacters {
            self.showNotification(title: "Password!", message: "Your new password must be at least 6 characters")
        } else if nickname == Contants.Instance.null {
            self.showNotification(title: "Nickname!", message: "Please fill out your Nickname")
        } else if newPass == Contants.Instance.null {
            //Waiting indicator
            self.waitingIndicator(with: indicator)
            if let imgData:Data = MyProfile.Instance.imgData {
                let jsonData: Dictionary<String, Any> = [Contants.Instance.email: email, Contants.Instance.oldPass: oldPass, Contants.Instance.newPass: oldPass, Contants.Instance.file: imgData, Contants.Instance.nickname: nickname]
                SocketIOManager.Instance.socketEmit(Commands.Instance.ClientUpdateProfile, jsonData)
            }
        } else {
            self.waitingIndicator(with: self.indicator)
            if let imgData:Data = MyProfile.Instance.imgData {
                let jsonData: Dictionary<String, Any> = [Contants.Instance.email: email, Contants.Instance.oldPass: oldPass, Contants.Instance.newPass: newPass, Contants.Instance.file: imgData, Contants.Instance.nickname: nickname]
                SocketIOManager.Instance.socketEmit(Commands.Instance.ClientUpdateProfile, jsonData)
            }
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
    
    // Scroll view up when keyboard popup.
    func showKeyboard(_ notification:Notification) {
        
        let keyboard:NSValue = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let heightKeyboard:CGFloat = keyboard.cgRectValue.height
        
        let distance = containerView.frame.height - (sum + heightKeyboard)
        
        if distance < limitationDistanceKeyboardAndTextField {
            
            bottomContainerContraint.constant = abs(distance) + 20
            let point:CGPoint = CGPoint(x: 0, y: bottomContainerContraint.constant)
            scrollView.setContentOffset(point, animated: true)
        }
    }
    // Scroll view down when keyboard popdown.
    func hideKeyboard(_ notification:Notification) {
        bottomContainerContraint.constant = defaultHeightUIViewContraint
    }
    
}

//MARK: - Make extension ProfileViewController
extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // Reduce size photos before uploading
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageSelected = info [UIImagePickerControllerOriginalImage] as? UIImage {
            
            let imageValue:CGFloat = max(imageSelected.size.height, imageSelected.size.width)
            
            if imageValue > 3000 {
                MyProfile.Instance.imgData = UIImageJPEGRepresentation(imageSelected, 0.1)
            }
            if imageValue > 2000 {
                MyProfile.Instance.imgData = UIImageJPEGRepresentation(imageSelected, 0.5)
            } else {
                MyProfile.Instance.imgData = UIImagePNGRepresentation(imageSelected)
            }
            if let imgData:Data = MyProfile.Instance.imgData {
                imgAvatar.image = UIImage(data: imgData)
            }
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}


