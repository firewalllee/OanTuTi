//
//  extensionUIViewController.swift
//  OanTuTi
//
//  Created by Phuc on 11/10/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Extension UIViewController
extension UIViewController {
    func selectImageFromDevice(_ imgPicker: UIImagePickerController) -> UIAlertController {
        
        //Action sheet to select the image source
        let listSelectSource:UIAlertController = UIAlertController(title: "Choose source", message: "Photo Library or Camera", preferredStyle: .actionSheet)
        
        let photoLibrary:UIAlertAction = UIAlertAction(title: "Photo Library", style: .default) { (UIAlertAction) in
            
            imgPicker.sourceType = .photoLibrary
            imgPicker.isEditing = true
            self.present(imgPicker, animated: true, completion: nil)
        }
        
        let camera:UIAlertAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                imgPicker.sourceType = .camera
                imgPicker.cameraCaptureMode = .photo
                imgPicker.modalPresentationStyle = .fullScreen
                imgPicker.allowsEditing = true
                self.present(imgPicker, animated: true, completion: nil)
            } else {
                self.showNotification(title: "Notice", message: "Can't find your camera!")
            }
        }
        
        let cancel:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
        }
        
        listSelectSource.addAction(photoLibrary)
        listSelectSource.addAction(camera)
        listSelectSource.addAction(cancel)
        
        return listSelectSource
    }
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
}

//MARK: - Extension UIView
extension UIView {
    
    //Corner radius items
    func lightBorder(with radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    //-----Scale animation
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
    ////---------Rotate x axis-----------
    func rotateXAxis() {
        self.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI/2), 0, 1, 0)
        
        UIView.animate(withDuration: 0.7) {
            self.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0)
        }
    }
    
    ////---------Rotate x axis-----------
    func rotateYAxis() {
        self.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI/2), 1, 0, 0)
        
        UIView.animate(withDuration: 0.7) {
            self.layer.transform = CATransform3DMakeRotation(0, 1, 0, 0)
        }
    }
    
    
}

//MARK: - Extension UITextField
extension UITextField {
    
    func standardTextField(borderColor: CGColor, placeHolder: String) {
        self.layer.borderColor = borderColor
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 3
        self.placeholder = placeHolder
        self.textAlignment = NSTextAlignment.center
        self.spellCheckingType = UITextSpellCheckingType.no
        self.autocorrectionType = UITextAutocorrectionType.no
    }
    
}

// MARK: Make extension for UIColor
extension UIColor {
    
    // Change color with hexa code.
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(Hex:Int) {
        self.init(red:(Hex >> 16) & 0xff, green:(Hex >> 8) & 0xff, blue:Hex & 0xff)
    }
}

//MARK: - Make extension UIImageView
extension UIImageView {
    
    // Download image from url with Multithread
    func loadAvatar (_ link:String) {
        
        // Properties indicator activity
        let queue = DispatchQueue(label: "LoadImage", attributes: DispatchQueue.Attributes.concurrent, target: nil)
        let activity:UIActivityIndicatorView = UIActivityIndicatorView(frame: self.bounds)
        activity.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.color = UIColor.gray
        self.addSubview(activity)
        activity.startAnimating()
        
        queue.async {
            if let url:URL = URL(string: link) {
                do {
                    let data:Data = try Data(contentsOf: url)
                    DispatchQueue.main.async(execute: {
                        activity.stopAnimating()
                        self.image = UIImage(data: data)
                    })
                } catch {
                    activity.stopAnimating()
                }
            } else {
                activity.stopAnimating()
            }
        }
    }
}

//MARK: - Extension UIApplication
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController , top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}

