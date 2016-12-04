//
//  RegisterViewController.swift
//  LoginView
//
//  Created by Phuc on 11/3/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

//Protocol Get user's email
protocol ProtocolUserEmail:class {
    func userEmail(_ userEmail:String)
}

class RegisterViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Mapped items
    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtNickname: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var wrapViewVerticalContraint: NSLayoutConstraint!
    
    //MARK: - Declarations
    private var spaceTopFree: CGFloat!
    fileprivate var imgData: Data!
    weak var delegate:ProtocolUserEmail? = nil
    private let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        //Add observation from Class ListenRegisterEvent
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveEvent), name: NotificationCommands.Instance.signupDelegate, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.viewsProperties()
        self.wrapView.scaleAnimation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //Get free top space to scroll up when keyboard will show or hiden
        self.spaceTopFree = self.getTopFreeHeight(wrapView)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        ///Remove observation when leave this screen
        //NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Setting some properties of views
    func viewsProperties() {
        
        self.btnRegister.lightBorder(with: 8)
        self.imgAvatar.lightBorder(with: 4)
        
    }
    
    //MARK: - Receive event function from class Listener
    func receiveEvent(notification: Notification) {
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            if let isSuccess:Bool = response[Contants.Instance.isSuccess] as? Bool {
                //Register successfully
                if isSuccess {
                    if self.delegate != nil {
                        self.delegate?.userEmail(self.txtEmail.text!)
                        //------------Reset textfield------------------
                        self.txtEmail.text = Contants.Instance.null
                        self.txtPassword.text = Contants.Instance.null
                        self.txtNickname.text = Contants.Instance.null
                        //-------Dismiss loading alert-----------------
                        //--Fix: bring this code to completion--->
                        //self.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true) {
                        //-----------Back to login screen--------------
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                } else {    //Login failed
                    //-------Dismiss loading alert-----------------
                    self.dismiss(animated: true) {
                        //-------Show message from server alert--------
                        if let message:String = response[Contants.Instance.message] as? String {
                            self.showNotification(title: "Notice", message: message)
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
            self.txtNickname.becomeFirstResponder()
        } else if textField.tag == 2 {
            textField.resignFirstResponder()
            self.btnRegister(self)
        }
        return true
    }
    //Begin edit
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.wrapViewVerticalContraint.constant = -(self.spaceTopFree + 35)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutSubviews()
        }
    }
    //End edit
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.wrapViewVerticalContraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutSubviews()
        }
    }
    
    //MARK: - Register tasks
    @IBAction func btnRegister(_ sender: AnyObject) {
        
        let email: String = self.txtEmail.text!
        let pass: String = self.txtPassword.text!
        let nickname: String = self.txtNickname.text!
        
        if pass.characters.count < 6 {
            self.showNotification(title: "Password!", message: "Your password must be at least 6 characters")
        } else {
            if nickname == Contants.Instance.null {
                self.showNotification(title: "Nickname!", message: "Please fill out your Nickname")
            } else {
                //Waiting indicator
                self.waitingIndicator(with: indicator)
                
                if imgData == nil {
                    imgData = UIImagePNGRepresentation(UIImage(named: "avatar")!)
                }
                
                let jsonData: Dictionary<String, Any> = [Contants.Instance.email: email, Contants.Instance.pass: pass, Contants.Instance.nickname: nickname, Contants.Instance.file: imgData]
                SocketIOManager.Instance.socketEmit(Commands.Instance.ClientSignUp, jsonData)
            }
        }
    }
    
    //MARK: - Select Image tasks
    @IBAction func tapToSelectImage(_ sender: UITapGestureRecognizer) {
        
        resignFirstResponder()
        
        let imgPicker:UIImagePickerController = UIImagePickerController()
        imgPicker.delegate = self
        
        let alert:UIAlertController = self.selectImageFromDevice(imgPicker)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
}

//MARK: - Make extension RegisterViewController
extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}


