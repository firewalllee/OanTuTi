//
//  ViewController.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 9/13/16.
//  Copyright © 2016 Lee Nguyen. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 

        // Kiểm tra tài khoản có đang đăng nhập hay không.
        if (FIRAuth.auth()?.currentUser) != nil {
            switchSence()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButton(_ sender: AnyObject) {
        
        let alertActivity = UIAlertController(title: "\n\n" + "Loading", message: "", preferredStyle: .alert)
        let activity = UIActivityIndicatorView(frame: alertActivity.view.bounds)
        activity.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        activity.color = UIColor.gray
        activity.isUserInteractionEnabled = false
        activity.startAnimating()
        
        alertActivity.view.addSubview(activity)
        present(alertActivity, animated: true, completion: nil)
        
        // Xác nhận đăng nhập.
        FIRAuth.auth()?.signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if error == nil {
                if user?.isEmailVerified == true {
                    activity.stopAnimating()
                    alertActivity.dismiss(animated: true, completion: nil)
                    self.switchSence()
                }
                else {
                    activity.stopAnimating()
                    alertActivity.dismiss(animated: true, completion: nil)
                    
                    let verifiedAlert = UIAlertController (title: "Go to email", message: "Hey! We see your email has not been verified. Please verify your email to login.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                    })
                    verifiedAlert.addAction(ok)
                    self.present(verifiedAlert, animated: true, completion: nil)
                }
            } else {
                activity.stopAnimating()
                alertActivity.dismiss(animated: true, completion: nil)
                // Thông báo đăng nhập thất bại.
                let alertFailToLogin = UIAlertController(title: "Notice!", message: "Maybe your email or password incorrect.", preferredStyle: .alert)
                let tryButton = UIAlertAction(title: "Try again", style: .cancel, handler: { (UIAlertAction) in
                })
                alertFailToLogin.addAction(tryButton)
                self.present(alertFailToLogin, animated: true, completion: nil)

            }
        }
    }
    
    // Keyboard show.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtEmail {
            moveTextField(textField: textField, moveDistance: -70, up: true)
        }
        if textField == txtPassword {
            moveTextField(textField: textField, moveDistance: -50, up: true)
        }
    }
    // Keyboard hide.
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtEmail {
            moveTextField(textField: textField, moveDistance: -70, up: false)
        }
        if textField == txtPassword {
            moveTextField(textField: textField, moveDistance: -50, up: false)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension UIViewController {
    // Chuyển màn hình sau khi đăng nhập thành công.
    func switchSence(){
        if let sence = self.storyboard?.instantiateViewController(withIdentifier: "Menu")  {
        //if sence != nil {
            self.present(sence, animated: true, completion: nil)
        }
    }
    
    // Kiểm tra đang tài khoản có đang login hay không.
    func logining() {
        
        FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
            if auth.currentUser == user {
                self.switchSence()
            }
            else {
            }
        }
    }
    
    // Hàm ẩn keyboard.
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Hàm di chuyển textfield khi bàn phím được bật lên. 
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
