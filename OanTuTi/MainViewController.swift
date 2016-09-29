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
    
    var tableMatchData:FIRDatabaseReference!
    var tableUserStatus:FIRDatabaseReference!
    
    var arrayId:Array<String> = Array<String>()
    var arrayValue:Array<String> = Array<String>()
    var arrayUser:Array<String> = Array<String>()
    var status:Array<String> = Array<String>()
    var statusOpponent:Array<String> = Array<String>()
    var timer: NSTimer!
    var numberCount: Int! = 10
    
    
    @IBOutlet weak var numberCountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusOpponentLabel: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var unreadyButton: UIButton!
    
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
        arrayId.sortInPlace()
        let matchId:String = "\(arrayId[0])\(arrayId[1])"
        
        tableMatchData = ref.child("Match").child(matchId).child(activeUser.id)
        tableUserStatus = ref.child("UserStatus").child(matchId).child(activeUser.id)
        
        // Mặc định nếu không ra kết quả là 4.
        matchData(activeUser.id,value: "4")
        userStatus(activeUser.id,status: "Unready")
        self.statusOpponent.append("Unready")
        
        tableMatchData.observeEventType(.Value, withBlock: { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
            
            print("---------\(postDict)")
            if postDict != nil {
                
            }
        })
        
        tableUserStatus.observeEventType(.Value, withBlock: { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
            print(snapshot.value)
            print(snapshot.key)
            
            if (postDict != nil){
                
                if snapshot.key == activeUser.id {
                    self.status = []
                    self.status.append(postDict?["status"] as! String)
                    print("----------\(self.status[0])")
                }
                else {
                    self.statusOpponent = []
                    self.statusOpponent.append(postDict?["status"] as! String)
                    print(self.statusOpponent[0])
                }
            }

        })
        
        // Cập nhật trạng thái ban đầu của người chơi là chưa sẵn sàng.
        statusLabel.text = "Unready"
        unreadyButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func matchData(id:String, value:String) {
        let data:Dictionary<String, String> = ["value": value]
        tableMatchData.setValue(data)
        
    }
    func userStatus(id:String, status:String){
        let data:Dictionary<String, String> = ["status": status]
        tableUserStatus.setValue(data)
    }
    
    
    @IBAction func baoButton(sender: AnyObject) {
        matchData(activeUser.id, value: "1")
        chooseImage.image = UIImage(named: "bao")
    }
    @IBAction func buaButton(sender: AnyObject) {
        matchData(activeUser.id, value: "2")
        chooseImage.image = UIImage(named: "bua")
    }
    @IBAction func keoButton(sender: AnyObject) {
        matchData(activeUser.id, value: "3")
        chooseImage.image = UIImage(named: "keo")
    }
    
    // Nút sẵn sàng.
    @IBAction func readyButton(sender: AnyObject) {
        statusLabel.text = "Ready"
        statusLabel.textColor = UIColor(Hex: 0x05d327)
        readyButton.hidden = true
        unreadyButton.hidden = false
        
        userStatus(activeUser.id, status: "Ready")
    }
    // Nút chưa sẵn sàng.
    @IBAction func unreadyButton(sender: AnyObject) {
        statusLabel.text = "Unready"
        statusLabel.textColor = UIColor(Hex: 0xff0202)
        unreadyButton.hidden = true
        readyButton.hidden = false
        
        userStatus("\(activeUser.id)", status: "Unready")
    }
    
    func count() {
        numberCount = numberCount - 1
        numberCountLabel.text = "Time: \(numberCount)"
    }
    @IBAction func exitButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension UIColor {
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
