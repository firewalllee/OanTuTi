//
//  WaitingForCreateViewController.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 10/26/16.
//  Copyright © 2016 Lee Nguyen. All rights reserved.
//

import UIKit

var winScore: Int = Int()

class WaitingForCreateViewController: UIViewController {

    @IBOutlet weak var roomIDLable: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var txtWinScore: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var opponentStatusLabel: UILabel!
    @IBOutlet weak var opponentAvatarImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = activeUser.nickName
        avatarImage.image = activeUser.avatarImage
        winScore = Int(txtWinScore.text!)!
        startButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButton(_ sender: AnyObject) {
        startButton.isEnabled = false
        winScore = Int(txtWinScore.text!)!
        if winScore <= 0 {
            let alert = UIAlertController(title: "Oops!", message: "Win score must be greater than 0", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
                self.startButton.isEnabled = true
            })
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        else {
            
        }
    }
    @IBAction func exitButton(_ sender: AnyObject) {
        
    }
}
