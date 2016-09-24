//
//  MainViewController.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 9/21/16.
//  Copyright © 2016 Lee Nguyen. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    var arrayId:Array<String> = Array<String>()
    var arrayValue:Array<String> = Array<String>()
    var arrayUser:Array<String> = Array<String>()
    
    var tableMatchData:FIRDatabaseReference!
    var tableUserData:FIRDatabaseReference!
    
    
    @IBOutlet weak var opponentAvatarImage: UIImageView!
    @IBOutlet weak var opponentName: UILabel!
    @IBOutlet weak var opponentChooseImage: UIImageView!
    
    
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var chooseImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        opponentAvatarImage.image = opponent.avatarImage
        opponentName.text = opponent.nickName
        
        avatarImage.image = activeUser.avatarImage
        name.text = activeUser.nickName
        
        arrayId.append(activeUser.id)
        arrayId.append(opponent.id)
        arrayId.sort()
        let matchId:String = "\(arrayId[0])\(arrayId[1])"
        
        tableMatchData = ref.child("Match").child(matchId)
        
        // Mặc định nếu không ra kết quả là 4.
        matchData("4")
        
        tableMatchData.observeEventType(.ChildAdded, withBlock: { (Snapshot) in
            let postDict = Snapshot.value as? [String:AnyObject ]
            
            if postDict != nil {
                
            }
        })
//        tableUserData = ref.child("User")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func matchData(value:String) {
        let data:Dictionary<String, String> = ["Id": activeUser.id, "Value": value]
        tableMatchData.setValue(data)
        
    }
    
    
    @IBAction func baoButton(sender: AnyObject) {
        matchData("1")
        chooseImage.image = UIImage(named: "bao")
    }
    @IBAction func buaButton(sender: AnyObject) {
        matchData("2")
        chooseImage.image = UIImage(named: "bua")
    }
    @IBAction func keoButton(sender: AnyObject) {
        matchData("3")
        chooseImage.image = UIImage(named: "keo")
    }

}
