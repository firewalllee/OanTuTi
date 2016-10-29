//
//  WaitingForJoinViewController.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 10/26/16.
//  Copyright © 2016 Lee Nguyen. All rights reserved.
//

import UIKit

class WaitingForJoinViewController: UIViewController {

    @IBOutlet weak var roomIDLable: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var winScore: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var unreadyButton: UIButton!
    
    
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var opponentAvatarImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = activeUser.nickName
        avatarImage.image = activeUser.avatarImage
        unreadyButton.isHidden = true
        statusLabel.text = "Unready"
        statusLabel.textColor = UIColor(Hex: 0xff0202)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func readyButton(_ sender: AnyObject) {
        unreadyButton.isHidden = false
        statusLabel.text = "Ready"
        statusLabel.textColor = UIColor(Hex: 0x05d327)
    }
    @IBAction func unreadyButton(_ sender: AnyObject) {
        readyButton.isHidden = false
        statusLabel.text = "Unready"
        statusLabel.textColor = UIColor(Hex: 0xff0202)
    }
}
