//
//  MainViewController.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 11/16/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    //MARK: - Mapped items
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMatchResult: UILabel!
    @IBOutlet weak var lblBestOf: UILabel!
    
    ////-> Guest
    @IBOutlet weak var imgGuestAvatar: UIImageView!
    @IBOutlet weak var imgGuestChoose: UIImageView!
    @IBOutlet weak var lblGuestName: UILabel!
    @IBOutlet weak var lblGuestReady: UILabel!
    @IBOutlet weak var lblGuestScore: UILabel!
    
    ////-> User 
    @IBOutlet weak var imgUserAvatar: UIImageView!
    @IBOutlet weak var imgUserChoose: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserReady: UILabel!
    @IBOutlet weak var lblUserScore: UILabel!
    @IBOutlet weak var btnBao: UIButton!
    @IBOutlet weak var btnBua: UIButton!
    @IBOutlet weak var btnKeo: UIButton!
    @IBOutlet weak var btnReady: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    //MARK: - Declarations
    var match_id:String = String()
    var selection:Int = 1
    var ready:Bool = true
    var game_id:Int = 1
    
    var thisRoom:Room = Room()
    var otherUser:User = User()
    
    var timer:Timer!
    var count:Int = 60 // Calc in 1 minutes
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //User leave room
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerLeaveGame), name: NotificationCommands.Instance.waitingDelegate, object: nil)
        //Submit selection
        NotificationCenter.default.addObserver(self, selector: #selector(self.userSubmit), name: NotificationCommands.Instance.submitDelegate, object: nil)
        //User ready
        NotificationCenter.default.addObserver(self, selector: #selector(self.clientReady), name: NotificationCommands.Instance.readyDelegate, object: nil)
        
        self.bind()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.viewProperties()
        
    }
    //Sub view properties
    func viewProperties() {
        imgGuestAvatar.lightBorder(with: 4)
        imgUserAvatar.lightBorder(with: 4)
    }
    
    //->Bind data User and Guest
    func bind() {
        //Both user
        self.lblBestOf.text = "Bo \(self.thisRoom.best_of)"
        
        //This user
        if let userName:String = MyProfile.Instance.name {
            self.lblUserName.text = userName
        }
        if let userAvatar:Data = MyProfile.Instance.imgData {
            self.imgUserAvatar.image = UIImage(data: userAvatar)
        }
        
        //Guest infor
        if let guestName:String = self.otherUser.name {
            self.lblGuestName.text = guestName
        }
        if let guestImage:String = self.otherUser.avatar {
            self.imgGuestAvatar.loadAvatar(guestImage)
        }
        
    }

    //MARK: - Listener from server
    //-> User quit suddenly quit game
    func playerLeaveGame(notification:Notification) {
        if let _:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            self.alertMessage("Congratulation! You have won this match!", completion: { 
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    //-> User submit selection
    func userSubmit(notification:Notification) {
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            
            print("Submit", response)
            
            if let their:Int = response[Contants.Instance.their] as? Int {
                self.whichAnswer(their, me: false)
            }
            if let selF:Int = response[Contants.Instance.selF] as? Int {
                self.whichAnswer(selF)
            }
            if let win:Bool = response[Contants.Instance.win] as? Bool {
                if win {
                    self.lblMatchResult.text = "Win"
                    self.lblUserScore.text = "\((Int(self.lblUserScore.text!) ?? 0) + 1)"
                } else {
                    self.lblMatchResult.text = "Lost"
                    self.lblGuestScore.text = "\((Int(self.lblGuestScore.text!) ?? 0) + 1)"
                }
            }
            
            //Reset timer
            if timer != nil {
                self.timer.invalidate()
                self.timer = nil
                self.count = 60
                self.lblTime.text = "Time \(self.count)"
            }
            
            self.game_id += 1
            self.btnSubmit.isEnabled = true
            if self.game_id > self.thisRoom.best_of {
                self.alertMessage("Game is end!", completion: {
                    self.dismiss(animated: true, completion: { 
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    
                })
            }
            
        }
    }
    //-> Client ready
    func clientReady(notification:Notification) {
        
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            
            print("Client - Ready => ", response)
            guard let their:Bool = response[Contants.Instance.their] as? Bool else {
                return
            }
            guard let selF:Bool = response[Contants.Instance.selF] as? Bool else {
                return
            }
            //->Guest ready
            self.isReady(lbl: self.lblGuestReady, their)
            //->User ready
            self.isReady(lbl: self.lblUserReady, selF)
            
            if their && selF {
                //Timer will start
                if timer == nil {
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCalc), userInfo: nil, repeats: true)
                }
            } else {
                if timer != nil {
                    timer.invalidate()
                    timer = nil
                    self.count = 60
                }
            }
            
            if selF {
                self.btnReady.setBackgroundImage(#imageLiteral(resourceName: "unready"), for: UIControlState.normal)
            } else {
                self.btnReady.setBackgroundImage(#imageLiteral(resourceName: "ready"), for: UIControlState.normal)
            }
            
        }
        
    }
    
    
    //Receive result from server and bind to image view
    func whichAnswer(_ submit:Int, me: Bool = true) {
        switch submit {
        case 1:
            if me {
                self.imgUserChoose.image = #imageLiteral(resourceName: "bua")
            } else {
                self.imgGuestChoose.image = #imageLiteral(resourceName: "bua")
            }
        case 2:
            if me {
                self.imgUserChoose.image = #imageLiteral(resourceName: "bao")
            } else {
                self.imgGuestChoose.image = #imageLiteral(resourceName: "bao")
            }
        default:
            if me {
                self.imgUserChoose.image = #imageLiteral(resourceName: "keo")
            } else {
                self.imgGuestChoose.image = #imageLiteral(resourceName: "keo")
            }
        }
    }
    //Check ready
    func isReady(lbl: UILabel, _ readY:Bool = true) {
        if readY {
            lbl.text = "Ready"
            lbl.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        } else {
            lbl.text = "Unready"
            lbl.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
    }
    
    //Timer calculating time when start game
    func timerCalc() {
        self.count -= 1
        if self.count < 1 {
            self.timer.invalidate()
            self.timer = nil
            self.lblMatchResult.text = "Draw"
            self.lblMatchResult.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else {
            self.lblTime.text = "Time \(self.count)"
        }
    }
    
    @IBAction func btnSelection(_ sender: UIButton) {
        
        self.selection = sender.tag
        self.whichAnswer(self.selection)
        //Hide guest answer
        self.imgGuestChoose.image = #imageLiteral(resourceName: "Icon")
        
    }
    
    //MARK: - Ready tasks
    @IBAction func btnReady(_ sender: AnyObject) {
        
        if timer != nil {
            timer.invalidate()
            timer = nil
            self.count = 60
        }
        
        if let uid:String = MyProfile.Instance.uid {
            let jsonData:Dictionary<String, Any> = [Contants.Instance.match_id: self.match_id, Contants.Instance.uid: uid]
            print("Button Ready => ", jsonData)
            SocketIOManager.Instance.socketEmit(Commands.Instance.ClientReady, jsonData)
        }
        
    }
    
    //MARK: - Submit tasks
    @IBAction func btnSubmit(_ sender: AnyObject) {
        
        if let uid:String = MyProfile.Instance.uid {
            let jsonData:Dictionary<String, Any> = [Contants.Instance.match_id: self.match_id, Contants.Instance.game_id: self.game_id, Contants.Instance.uid: uid, Contants.Instance.selection: self.selection]
            
            print("Submit => ", jsonData)
            SocketIOManager.Instance.socketEmit(Commands.Instance.ClientSubmitSelection, jsonData)
            
            
            self.btnSubmit.isEnabled = false
        }
        
    }
    
    
    //Quit tasks
    @IBAction func quitGame(_ sender: UIBarButtonItem) {
        
        self.alertMessage("You will lose this game!") { 
            if let room_id:String = self.thisRoom.id {
                if let uid:String = MyProfile.Instance.uid {
                    let jsonData:Dictionary<String, Any> = [Contants.Instance.room_id: room_id, Contants.Instance.uid: uid]
                    SocketIOManager.Instance.socketEmit(Commands.Instance.ClientLeaveRoom, jsonData)
                    //Because server don't response when user is being host ==>
                    _ = self.navigationController?.popViewController(animated: true)
                    
                }
            }
        }
        
    }
    
}

extension UIViewController {
    
    func alertMessage(_ message:String, title:String = "Notice!", completion: @escaping () -> Void) {
        
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOk:UIAlertAction = UIAlertAction(title: "Quit", style: UIAlertActionStyle.destructive) { (btn) in
            completion()
        }
        let alertCancel:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(alertOk)
        alert.addAction(alertCancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
