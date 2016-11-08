//
//  LoginViewController.swift
//  LoginView
//
//  Created by Phuc on 11/1/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

var myProfile:User = User()
var User_mail:String = String()

class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Mapped items
    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var wrapViewVerticalContraint: NSLayoutConstraint!
    
    //MARK: - Declarations
    var spaceTopFree:CGFloat!
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        //Listen login event from server
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientLoginRs) { (data, ack) in
            if let response: Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                if let isSuccess: Bool = response[Contants.Instance.isSuccess] as? Bool {
                    //-------CheckLogin----------------------------
                    if isSuccess {
                        //-------Get user infor-----------------------
                        User_mail = self.txtEmail.text!
                        //-------Textfield reset-----------------------
                        self.txtEmail.text = Contants.Instance.null
                        self.txtPassword.text = Contants.Instance.null
                        //---------------------------------------------
                        if let jsonUser:Dictionary<String, Any> = response[Contants.Instance.user] as? Dictionary<String, Any> {
                            myProfile = User(jsonUser)
                        }
                        //-------Dismiss loading alert-----------------
                        self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: Contants.Instance.segueMenu, sender: nil)
                    } else {
                        
                        //-------Dismiss loading alert-----------------
                        self.dismiss(animated: true) {
                            //-------Reset textfield password--------------
                            self.txtPassword.text = Contants.Instance.null
                            //-------Show message from server alert--------
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
        self.ViewsProperties()
        self.wrapView.scaleAnimation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.spaceTopFree = self.getTopFreeHeight(wrapView)
    }
    

    
    //MARK: - setup properties of view
    func ViewsProperties() {
        
        self.btnSignUp.lightBorder(with: 8)
    }
    
    //MARK: - Delegate keyboard
    //Show keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.wrapViewVerticalContraint.constant = -self.spaceTopFree
        UIView.animate(withDuration: 0.3) {
            self.view.layoutSubviews()
        }
        
    }
    //Hide keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.wrapViewVerticalContraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutSubviews()
        }
    }
    
    //Return button press
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            txtPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.btnLogin(UIButton())
        }
        
        return true
    }
    
    //MARK: - Login tasks
    @IBAction func btnLogin(_ sender: UIButton) {
        
        let email: String = self.txtEmail.text!
        let pass: String = self.txtPassword.text!
        
        if email != Contants.Instance.null && pass != Contants.Instance.null {
            //Waiting indicator
            self.waitingIndicator(with: indicator)
            let jsonData: Dictionary<String, Any> = [Contants.Instance.email: email, Contants.Instance.pass: pass]
            SocketIOManager.Instance.socketEmit(Commands.Instance.ClientLogin, jsonData)
            
        } else {
            self.showNotification(title: "Notice", message: "Please fill out information!")
        }
        
    }
    
    //MARK: - Delegate fill textfield email when back from register screen
    func userEmail(_ userEmail: String) {
        self.txtEmail.text = userEmail
    }
    //MARK: - Register tasks
    @IBAction func btnRegister(_ sender: AnyObject) {
        self.performSegue(withIdentifier: Contants.Instance.segueRegister, sender: nil)
    }
    
    //MARK: - Exit tasks
    @IBAction func exitButton(_ sender: UIBarButtonItem) {
        
        let alert:UIAlertController = UIAlertController(title: "Exit?", message: "Do you want to exit application?", preferredStyle: UIAlertControllerStyle.alert)
        let actionCacel:UIAlertAction = UIAlertAction(title: "Exit", style: UIAlertActionStyle.destructive) { (btn) in
            exit(0)
        }
        let actionBack:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(actionCacel)
        alert.addAction(actionBack)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

//MARK: - Prepare for segue
extension LoginViewController:ProtocolUserEmail {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Contants.Instance.segueRegister {
            let destinationVC:RegisterViewController = segue.destination as! RegisterViewController
            destinationVC.delegate = self
        }
    }
    
}

//MARK: - Make extension UIView
extension UIView {
    
    //Corner radius items
    func lightBorder(with radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func scaleAnimation() {
        
        self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.1)
        }) { (true) in
            UIView.animate(withDuration: 0.3, animations: {
                self.layer.transform = CATransform3DMakeScale(1, 1, 1)
            })
        }
    }
    
    func rotateXAxis() {
        self.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI/2), 0, 1, 0)
        
        UIView.animate(withDuration: 0.7) {
            self.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0)
        }
    }
    
}


//MARK: - Make extension UIViewController
extension UIViewController {
    
    //Get the height of top wrap view
    func getTopFreeHeight(_ wrapView: UIView) -> CGFloat {
        if let naviHeight = self.navigationController?.navigationBar.frame.height {
            return wrapView.frame.origin.y - naviHeight - 20 //20 is the height of status bar
        } else {
            return wrapView.frame.origin.y
        }
    }
    
    //Show notification with 1 button OK
    func showNotification(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOk: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(alertOk)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //Indicator waiting
    func waitingIndicator(with indicator: UIActivityIndicatorView) {
        
        let alert:UIAlertController = UIAlertController(title: "Loading\n", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let alertCancel: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(alertCancel)
        indicator.activityIndicatorViewStyle = .gray
        
        self.present(alert, animated: true) {
            //Properties
            indicator.frame = CGRect(x: alert.view.frame.width/2, y: alert.view.frame.height/2, width: 0, height: 0)
            alert.view.addSubview(indicator)
            indicator.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            indicator.startAnimating()
        }
    }
    
    //Hide keyboard when tap screen.
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // View pushed onto the keyboard is turned on
    func moveTextField(moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
//    func selectImage() {
//        resignFirstResponder()
//        
//        let imgPicker:UIImagePickerController = UIImagePickerController()
//        imgPicker.delegate = self
//        
//        //Action sheet to select the image source
//        let listSelectSource:UIAlertController = UIAlertController(title: "Choose source", message: "Photo Library or Camera", preferredStyle: .actionSheet)
//        
//        let photoLibrary:UIAlertAction = UIAlertAction(title: "Photo Library", style: .default) { (UIAlertAction) in
//            
//            imgPicker.sourceType = .photoLibrary
//            imgPicker.isEditing = true
//            self.present(imgPicker, animated: true, completion: nil)
//        }
//        
//        let camera:UIAlertAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//                imgPicker.sourceType = .camera
//                imgPicker.cameraCaptureMode = .photo
//                imgPicker.modalPresentationStyle = .fullScreen
//                imgPicker.allowsEditing = true
//                self.present(imgPicker, animated: true, completion: nil)
//            } else {
//                self.showNotification(title: "Notice", message: "Can't find your camera!")
//            }
//        }
//        
//        let cancel:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
//        }
//        
//        listSelectSource.addAction(photoLibrary)
//        listSelectSource.addAction(camera)
//        listSelectSource.addAction(cancel)
//        
//        present(listSelectSource, animated: true, completion: nil)
//    }
//    
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let imageSelected = info [UIImagePickerControllerOriginalImage] as? UIImage {
//            
//            let imageValue:CGFloat = max(imageSelected.size.height, imageSelected.size.width)
//            
//            if imageValue > 3000 {
//                imgData = UIImageJPEGRepresentation(imageSelected, 0.1)
//            }
//            if imageValue > 2000 {
//                imgData = UIImageJPEGRepresentation(imageSelected, 0.5)
//            } else {
//                imgData = UIImagePNGRepresentation(imageSelected)
//            }
//            
//            imgAvatar.image = UIImage(data: imgData)
//        }
//        self.dismiss(animated: true, completion: nil)
//    }

}


