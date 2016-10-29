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
    var timer = Timer()
    var numberCount:Int! = 10
    
    
    var status:Array<String> = Array<String>()
    var value:Array<String> = Array<String>()
    var submitted:Array<String> = Array<String>()
    var score:Int! = 0
    var opponentStatus:Array<String> = Array<String>()
    var opponentValue:Array<String> = Array<String>()
    var opponentsubmitted:Array<String> = Array<String>()
    var opponentScore:Int! = 0
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var unreadyButton: UIButton!
    @IBOutlet weak var matchStatusLabel: UILabel!
    @IBOutlet weak var baoButton: UIButton!
    @IBOutlet weak var buaButton: UIButton!
    @IBOutlet weak var keoButton: UIButton!
    
    @IBOutlet weak var opponentStatusLabel: UILabel!
    @IBOutlet weak var opponentAvatarImage: UIImageView!
    @IBOutlet weak var opponentName: UILabel!
    @IBOutlet weak var opponentChooseImage: UIImageView!
    @IBOutlet weak var opponentScoreLabel: UILabel!
    
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var chooseImage: UIImageView!
    @IBOutlet weak var scorelabel: UILabel!
    
    
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
        
        tableMatchData = ref.child("Match").child(activeUser.id).child(matchId).child("MatchData")
        tableUserStatus =  ref.child("Match").child(activeUser.id).child(matchId).child("UserStatus")

        
        
        // Thiết lập một số giá trị mặc định trước khi vào trận đấu
        matchData(activeUser.id, value: "4", submitted: "no")
        userStatus(activeUser.id,status: "Unready")
        self.opponentStatus.append("Unready")
        submitButton.isEnabled = false
        
        // Xóa thông tin trận đấu của User khi thoát khỏi trận đấu.
//        tableMatchData.onDisconnectRemoveValue()
//        tableUserStatus.onDisconnectRemoveValue()
        
        // Lấy về dữ liệu trận đấu của User.
        ref.child("Match").child(activeUser.id).child(matchId).child("UserStatus").observe(.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
           
            if postDict != nil {
                if postDict?["id"] as! String == activeUser.id {
                    self.status = []
                    self.status.append(postDict?["status"] as! String)
//                    print("----------\(self.status[0])")
                }
            }
            
        })
        
        ref.child("Match").child(activeUser.id).child(matchId).child("MatchData").observe(.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]

            if postDict != nil {
                if postDict?["id"] as! String == activeUser.id {
                    self.value = []
                    self.submitted = []
                    self.value.append(postDict?["value"] as! String)
                    self.submitted.append(postDict?["submitted"] as! String)
//                    print("----------\(self.value[0])")
                }
            }
            
        })
        
        
        // Lấy về dữ liệu trận đấu của đối thủ.
        ref.child("Match").child(opponent.id).child(matchId).child("MatchData").observe(.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
            
            if postDict != nil {
                if postDict?["id"] as! String == opponent.id {
                    self.opponentValue = []
                    self.opponentsubmitted = []
                    self.opponentValue.append(postDict?["value"] as! String)
                    self.opponentsubmitted.append(postDict?["submitted"] as! String)
//                    print(self.opponentValue[0])
                }
            }
        })
        ref.child("Match").child(opponent.id).child(matchId).child("UserStatus").observe(.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
        
            if postDict != nil {
                if postDict?["id"] as! String == opponent.id {
                    self.opponentStatus = []
                    self.opponentStatus.append(postDict?["status"] as! String)
//                    print("----------++++\(self.opponentStatus[0])")
                }
            }
        })
        

        // Hàm cập nhật xử lý những thay đổi thông tin trận đấu.
        ref.child("Match").observe(.value, with: {(snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
            if postDict != nil {
                if self.status[0] == "Ready" {
                    self.unreadyButton.isHidden = false
                    self.readyButton.isHidden = true
                    self.statusLabel.textColor = UIColor(Hex: 0x05d327)
                    self.statusLabel.text = "Ready"
                    if self.opponentStatus[0] == "Ready" {
                        self.opponentStatusLabel.textColor = UIColor(Hex: 0x05d327)
                        self.opponentStatusLabel.text = "Ready"
                        self.opponentChooseImage.image = UIImage()
                        self.baoButton.isEnabled = true
                        self.buaButton.isEnabled = true
                        self.keoButton.isEnabled = true
                        
                        if self.value[0] == "4" && self.opponentValue[0] == "4" {
                            if self.numberCount != 10 {
                                self.numberCount = 10
                            }
                            self.timer.invalidate()
                            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainViewController.count), userInfo: nil, repeats: true)
                        }
                        if self.submitted[0] == "yes" {
                            self.baoButton.isEnabled = false
                            self.buaButton.isEnabled = false
                            self.keoButton.isEnabled = false
                            if self.opponentsubmitted[0] == "yes" {
                                self.numberCount = 1
                                self.timer.invalidate()
                                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainViewController.count), userInfo: nil, repeats: true)
                            }
                        }
                    }
                    else {
                        self.opponentStatusLabel.textColor = UIColor(Hex: 0xff0202)
                        self.opponentStatusLabel.text = "Unready"
                        self.opponentChooseImage.image = UIImage()
                        self.baoButton.isEnabled = false
                        self.buaButton.isEnabled = false
                        self.keoButton.isEnabled = false
                        
                        self.timer.invalidate()
                        self.timeLabel.text = "Time: 10"
                        self.matchData(activeUser.id, value: "4", submitted: "no")
                        
                        
                        
                    }
                }
                else {
                    if self.opponentStatus[0] == "Ready"{
                        self.opponentStatusLabel.textColor = UIColor(Hex: 0x05d327)
                        self.opponentStatusLabel.text = "Ready"
                    }
                    else {
                        self.opponentStatusLabel.textColor = UIColor(Hex: 0xff0202)
                        self.opponentStatusLabel.text = "Unready"
                    }
                    self.statusLabel.text = "Unready"
                    self.statusLabel.textColor = UIColor(Hex: 0xff0202)
                    self.unreadyButton.isHidden = true
                    self.readyButton.isHidden = false
                    self.baoButton.isEnabled = false
                    self.buaButton.isEnabled = false
                    self.keoButton.isEnabled = false
                    
                    self.timer.invalidate()
                    self.timeLabel.text = "Time: 10"
                    self.matchData(activeUser.id, value: "4", submitted: "no")
                }
                
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func matchData(_ id:String, value:String, submitted:String) {
        let data:Dictionary<String, String> = ["id": id, "value": value, "submitted": submitted]
        tableMatchData.setValue(data)
        
    }
    func userStatus(_ id:String, status:String){
        let data:Dictionary<String, String> = ["id": id, "status": status]
        tableUserStatus.setValue(data)
    }

    // Hàm xử lý thông tin giá tri trận đấu.
    func processMatch(_ value1: String, value2: String) {
        let a:Int? = Int(value1)
        let b:Int? = Int(value2)
        let c:Int? = a! - b!
        if a == 4 && b == 4 {
            matchStatusLabel.textColor = UIColor(Hex: 0xfff600)
            matchStatusLabel.text = "Draw"
        }
        if a == 4 || b == 4 {
            if a == 4 && b != 4 {
                opponentScore = opponentScore + 1
                opponentScoreLabel.text = "\(opponentScore!)"
                
                matchStatusLabel.textColor = UIColor(Hex: 0xff0202)
                matchStatusLabel.text = "Lose"
            }
            if a != 4 && b == 4 {
                score = score + 1
                scorelabel.text = "\(score!)"
                
                matchStatusLabel.textColor = UIColor(Hex: 0x05d327)
                matchStatusLabel.text = "Win"
            }
        }
        else {
        

            if c == 0 {
                matchStatusLabel.textColor = UIColor(Hex: 0xfff600)
                matchStatusLabel.text = "Draw"
            }
            if c == -1 || c == 2 {
                score = score + 1
                scorelabel.text = "\(score!)"
                
                matchStatusLabel.textColor = UIColor(Hex: 0x05d327)
                matchStatusLabel.text = "Win"
            }
            if c == 1 || c == -2 {
                opponentScore = opponentScore + 1
                opponentScoreLabel.text = "\(opponentScore!)"
                
                matchStatusLabel.textColor = UIColor(Hex: 0xff0202)
                matchStatusLabel.text = "Lose"
            }
        }
    }
    
    @IBAction func baoButton(_ sender: AnyObject) {
        matchData(activeUser.id, value: "1", submitted: "no")
        chooseImage.image = UIImage(named: "bao")
        self.submitButton.isEnabled = true
    }
    @IBAction func buaButton(_ sender: AnyObject) {
        matchData(activeUser.id, value: "2", submitted: "no")
        chooseImage.image = UIImage(named: "bua")
        self.submitButton.isEnabled = true
    }
    @IBAction func keoButton(_ sender: AnyObject) {
        matchData(activeUser.id, value: "3", submitted: "no")
        chooseImage.image = UIImage(named: "keo")
        self.submitButton.isEnabled = true
    }
    
    // Nút sẵn sàng.
    @IBAction func readyButton(_ sender: AnyObject) {
        self.chooseImage.image = UIImage()
        userStatus(activeUser.id, status: "Ready")
    }
    
    // Nút chưa sẵn sàng.
    @IBAction func unreadyButton(_ sender: AnyObject) {
        userStatus(activeUser.id, status: "Unready")
        matchData(activeUser.id, value: "4", submitted: "no")
    }
    
    @IBAction func submitButton(_ sender: AnyObject) {
        submitButton.isEnabled = false
        matchData(activeUser.id, value: value[0], submitted: "yes")
    }
    
    
    // Hàm đếm ngược thời gian chơi.
    func count() {
        numberCount = numberCount - 1
        if numberCount >= 0 {
            timeLabel.text = "Time: \(numberCount!)"
        }
        if self.numberCount == 0 {
            self.processMatch(self.value[0], value2: self.opponentValue[0])
            
            if self.opponentValue[0] == "1" {
                self.opponentChooseImage.image = UIImage(named: "bao")
            }
            if self.opponentValue[0] == "2" {
                self.opponentChooseImage.image = UIImage(named: "bua")
            }
            if self.opponentValue[0] == "3" {
                self.opponentChooseImage.image = UIImage(named: "keo")
            }
            if self.opponentValue[0] == "4" {
                self.opponentChooseImage.image = UIImage()
            }
            
            self.submitButton.isEnabled = false
        }
        if self.numberCount == -3 {
            matchData(activeUser.id, value: "4", submitted: "no")
            userStatus(activeUser.id, status: "Unready")

        }
    }
    @IBAction func exitButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

// Mark: Chuyển màu theo mã hexa.
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
