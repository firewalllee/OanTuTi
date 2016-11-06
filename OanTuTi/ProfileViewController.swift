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
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var lblWins: UILabel!
    @IBOutlet weak var lblLosts: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var wrapTextfield: UIView!
    @IBOutlet weak var txtDisplayName: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var wrapTextfieldHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Declarations
    var isUpdating:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Init 3 textfield will hide and scale to 0.1 belong y coordinate
        self.wrapTextfieldHeightConstraint.constant = 0
        self.wrapTextfield.isHidden = true
        self.wrapTextfield.layer.transform = CATransform3DMakeScale(1, 0.1, 1)
        //Make scale animation
        self.wrapView.scaleAnimation()
        
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
                        self.btnEdit.setTitle("Edit", for: .normal)
                    })
            })
            
            self.isUpdating = false
        } else {
            self.wrapTextfield.isHidden = false
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
    
    
}
