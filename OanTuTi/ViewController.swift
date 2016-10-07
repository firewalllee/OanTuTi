//
//  ViewController.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 9/13/16.
//  Copyright © 2016 Lee Nguyen. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        //logining()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginButton(_ sender: AnyObject) {
        
      // Xác nhận đăng nhập.
      FIRAuth.auth()?.signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if error == nil {
                self.switchSence()
            } else {
                // Thông báo đăng nhập thất bại.
                let alertFailToLogin = UIAlertController(title: "Notice!", message: "Maybe your email or password incorrect.", preferredStyle: .alert)
                let tryButton = UIAlertAction(title: "Try again", style: .cancel, handler: { (UIAlertAction) in
                })
                alertFailToLogin.addAction(tryButton)
                self.present(alertFailToLogin, animated: true, completion: nil)

            }
        }
    }

}

extension UIViewController {
    // Chuyển màn hình sau khi đăng nhập thành công.
    func switchSence(){
        let sence = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
        if sence != nil {
            self.present(sence!, animated: true, completion: nil)
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
    
}
