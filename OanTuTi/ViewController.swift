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
        //logining()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButton(sender: AnyObject) {
        
      // Xác nhận đăng nhập.
      FIRAuth.auth()?.signInWithEmail(txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if error == nil {
                self.switchSence()
            } else {
                // Thông báo đăng nhập thất bại.
                let alertFailToLogin = UIAlertController(title: "Notice!", message: "Maybe your email or password incorrect.", preferredStyle: .Alert)
                let tryButton = UIAlertAction(title: "Try again", style: .Cancel, handler: { (UIAlertAction) in
                })
                alertFailToLogin.addAction(tryButton)
                self.presentViewController(alertFailToLogin, animated: true, completion: nil)

            }
        }
    }

}

extension UIViewController {
    // Chuyển màn hình sau khi đăng nhập thành công.
    func switchSence(){
        let sence = self.storyboard?.instantiateViewControllerWithIdentifier("Menu")
        if sence != nil {
            self.presentViewController(sence!, animated: true, completion: nil)
        }
    }
    
    // Kiểm tra đang tài khoản có đang login hay không.
    func logining() {
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { (auth, user) in
            if auth.currentUser == user {
                self.switchSence()
            }
            else {
            }
        }
    }
    
}