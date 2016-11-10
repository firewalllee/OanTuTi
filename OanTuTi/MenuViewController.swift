//
//  MenuViewController.swift
//  OanTuTi
//
//  Created by Phuc on 11/4/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    //MARK: - Mapped items
    @IBOutlet weak var btnLogout: UIBarButtonItem!
    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgCoin: UIImageView!
    @IBOutlet weak var lblNickname: UILabel!
    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnAbout: UIButton!
    
    //MARK: - Declarations
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let myName:String = myProfile.name {
            lblNickname.text = myName
        }
        if let myCoin_card:Int = myProfile.coin_card {
            lblCoin.text = String(myCoin_card)
        }
        if let myAvatar:String = myProfile.avatar {
            imgAvatar.loadAvatar(myAvatar)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.viewPropeties()
        self.wrapView.scaleAnimation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
    //MARK: Setting some properties of views
    func viewPropeties() {
        
        self.btnLogout.tintColor = UIColor.red
        self.btnPlay.lightBorder(with: 8)
        self.btnProfile.lightBorder(with: 8)
        self.btnAbout.lightBorder(with: 8)
        self.imgAvatar.lightBorder(with: 4)
        self.lblCoin.textColor = UIColor.yellow
    }
    
    //MARK: - Play tasks
    @IBAction func btnPlay(_ sender: AnyObject) {
        
    }
    
    //MARK: - Profile tasks
    @IBAction func btnProfile(_ sender: AnyObject) {
        self.performSegue(withIdentifier: Contants.Instance.segueProfile, sender: nil)
        
    }
    
    //MARK: - signout tasks
    @IBAction func btnLogout(_ sender: UIBarButtonItem) {
        if let uid:String = myProfile.uid {
            let jsonUID:Dictionary<String, Any> = [Contants.Instance.uid: uid]
            SocketIOManager.Instance.disconnect(jsonUID)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

}
