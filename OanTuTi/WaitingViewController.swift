//
//  WaitingViewController.swift
//  OanTuTi
//
//  Created by Phuc on 11/11/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {

    //MARK: - Mapped items
    @IBOutlet weak var lblRoomName: UILabel!
    @IBOutlet weak var lblMoneyBet: UILabel!
    @IBOutlet weak var lblBestOf: UILabel!
    @IBOutlet weak var btnUpdate: UIBarButtonItem!
    ////-> Guest
    @IBOutlet weak var lblGuestName: UILabel!
    @IBOutlet weak var imgGuestAvatar: UIImageView!
    @IBOutlet weak var lblGuestReady: UILabel!
    @IBOutlet weak var lblGuestMoney: UILabel!
    ////-> User
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUserAvatar: UIImageView!
    @IBOutlet weak var lblUserMoney: UILabel!
    @IBOutlet weak var btnReadyStart: UIButton!
    
    //MARK: - Declarations
    var thisRoom:Room = Room()
    var otherUser:User!
    var isHost:Bool = true      //Check host or guest from previous screen
    var isClientReady = true
    var matchId:String!
    let best_of:Array<String> = ["1", "3", "5", "7", "9", "11", "15"]
    var otherUserCoin: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRoomInfor()
        
        //Add observation
        //->Player Leave Room
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivePlayerLeaveRoomEvent), name: NotificationCommands.Instance.waitingDelegate, object: nil)
        //->This user leave Room
        NotificationCenter.default.addObserver(self, selector: #selector(self.userLeaveRoom), name: NotificationCommands.Instance.leaveRoomDelegate, object: nil)
        //->Other player join this room
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerJoinRoom), name: NotificationCommands.Instance.joinRoomDelegate, object: nil)
        //->Update Room delegate
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateRoom), name: NotificationCommands.Instance.updateRoomInfoDelegate, object: nil)
        //Client ready
        NotificationCenter.default.addObserver(self, selector: #selector(self.clientReady), name: NotificationCommands.Instance.readyDelegate, object: nil)
        //Start game
        NotificationCenter.default.addObserver(self, selector: #selector(self.startGame), name: NotificationCommands.Instance.clientSartgameDelegate, object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if let coin:Int = MyProfile.Instance.coin_card {
            self.lblUserMoney.text = "$\(coin)"
        }
        
        if !self.isHost {
            if let hostCoin:Int = otherUser.coin_card {
                self.lblGuestMoney.text = "$\(hostCoin)"
            }
        }
        
        self.view.rotateYAxis()
        self.viewProperties()
    }
    
    func viewProperties() {
        self.imgUserAvatar.lightBorder(with: 4)
        self.imgGuestAvatar.lightBorder(with: 4)
    }
    
    //Setting room infor
    func setupRoomInfor() {
        if let room_name:String = thisRoom.roomName {
            self.lblRoomName.text = room_name
        }
        if let money:Double = thisRoom.moneyBet {
            self.lblMoneyBet.text = "$\(Int(money))"
        }
        self.lblBestOf.text = "Bo \(thisRoom.best_of)"
        
        if let userName:String = MyProfile.Instance.name {
            self.lblUserName.text = userName
        }
        if let imgData:Data = MyProfile.Instance.imgData {
            self.imgUserAvatar.image = UIImage(data: imgData)
        }
        if self.isHost {
            self.lblUserName.text = self.lblUserName.text! + " (Host)"
            self.nullOtherPlayer()
            
        } else {
            self.btnReadyStart.setBackgroundImage(#imageLiteral(resourceName: "ready"), for: UIControlState.normal)
            self.btnUpdate.isEnabled = false
            
            if let hostName:String = otherUser.name {
                self.lblGuestName.text = hostName + " (Host)"
            }
            if let hostAvatar:String = otherUser.avatar {
                self.imgGuestAvatar.loadAvatar(hostAvatar)
            }

        }
    }
    
    //Reset other player
    func nullOtherPlayer(){
        ////
        self.lblGuestReady.isHidden = true
        self.imgGuestAvatar.isHidden = true
        self.imgGuestAvatar.image = #imageLiteral(resourceName: "avatar")
        self.lblGuestName.text = "Waiting user"
        self.lblGuestMoney.text = "$0"
        self.btnReadyStart.isEnabled = false
    }
    //Get infor of new player join room
    func playerJoin(_ otherUser:User) {
        if let playerName:String = self.otherUser.name {
            self.lblGuestName.text = playerName
        }
        if let coins:Int = self.otherUser.coin_card {
            self.lblGuestMoney.text = "$\(coins)"
        }
        if let avatar:String = self.otherUser.avatar {
            self.imgGuestAvatar.isHidden = false
            self.imgGuestAvatar.loadAvatar(avatar)
        }
    }
    
    //MARK: - Listener response
    //-> player leaver room
    func receivePlayerLeaveRoomEvent(notification: Notification) {
        if let _:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            if self.isHost {
                self.nullOtherPlayer()
            } else {
                self.nullOtherPlayer()
                self.lblUserName.text = "\(self.lblUserName.text!) (Host)"
                self.btnReadyStart.setBackgroundImage(#imageLiteral(resourceName: "start"), for: UIControlState.normal)
                self.btnUpdate.isEnabled = true
                self.isHost = true
            }
        }
    }
    //-> User leave room
    func userLeaveRoom(notification: Notification) {
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            if let isSuccess:Bool = response[Contants.Instance.isSuccess] as? Bool {
                if isSuccess {
                    _ = self.navigationController?.popViewController(animated: true)
                } else {
                    if let message:String = response[Contants.Instance.message] as? String {
                        self.showNotification(title: "Notice", message: message)
                    }
                }
            }
        }
    }
    //-> Other player join room
    func playerJoinRoom(notification: Notification) {
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            if let _:Bool = response[Contants.Instance.isSuccess] as? Bool {
                if let message:String = response[Contants.Instance.message] as? String {
                    self.showNotification(title: "Notice", message: message)
                }
                return
            }
            
            self.otherUser = User(response)
            self.playerJoin(self.otherUser)
            otherUserCoin = self.otherUser.coin_card
        }
    }
    //-> Update room info response
    func updateRoom(notification: Notification) {
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            if let isSuccess:Bool = response[Contants.Instance.isSuccess] as? Bool {
                if isSuccess {
                    if let roomInfor:Dictionary<String, Any> = response[Contants.Instance.room_info] as? Dictionary<String, Any> {
                        ///Update this room Instance
                        if let name:String = roomInfor[Contants.Instance.room_name] as? String {
                            self.lblRoomName.text = name
                            self.thisRoom.roomName = name
                        }
                        if let moneyBet:Double = roomInfor[Contants.Instance.money_bet] as? Double {
                            self.lblMoneyBet.text = "$\(Int(moneyBet))"
                            self.thisRoom.moneyBet = moneyBet
                        }
                        if let bo:Int = roomInfor[Contants.Instance.best_of] as? Int {
                            self.lblBestOf.text = "Bo \(bo)"
                            self.thisRoom.best_of = bo
                        }
                        if let room_id:String = roomInfor[Contants.Instance.room_id] as? String {
                            self.thisRoom.id = room_id
                        }
                    }
                }
            } else {
                self.showNotification(title: "Notice", message: "Can't update room information")
            }
        }
    }
    //-> Client Ready
    func clientReady(notification: Notification) {
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            guard let ready:Bool = response[Contants.Instance.ready] as? Bool else {
                return
            }
            //If client ready
            if isHost {
                if ready {
                    self.btnUpdate.isEnabled = false
                    self.btnReadyStart.isEnabled = true
                    self.lblGuestReady.isHidden = false
                } else {
                    self.btnUpdate.isEnabled = true
                    self.lblGuestReady.isHidden = true
                    self.btnReadyStart.isEnabled = false
                }
            }  else { //host ready start
                if ready {
                    self.btnReadyStart.setBackgroundImage(#imageLiteral(resourceName: "unready"), for: UIControlState.normal)
                } else {
                    self.btnReadyStart.setBackgroundImage(#imageLiteral(resourceName: "ready"), for: UIControlState.normal)
                }
                self.isClientReady = true // Client have been ready
            }
        }
    }
    //-> Client start game
    func startGame(notification: Notification) {
        
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {

            guard let isSuccess:Bool = response[Contants.Instance.isSuccess] as? Bool else {
                return
            }
            
            if isSuccess {
                if let match_id:String = response[Contants.Instance.match_id] as? String {
                    self.matchId = match_id
                    self.performSegue(withIdentifier: Contants.Instance.segueMain, sender: nil)
                }
            } else {
                if let message:String = response[Contants.Instance.message] as? String {
                    self.showNotification(title: "Notice", message: message)
                }
            }
            
        }
        
    }
    
    //MARK: - Leave room task
    @IBAction func leaveRoom(_ sender: AnyObject) {
        
        if let room_id:String = thisRoom.id {
            if let uid:String = MyProfile.Instance.uid {
                
                let jsonData:Dictionary<String, Any> = [Contants.Instance.room_id: room_id, Contants.Instance.uid: uid]
                SocketIOManager.Instance.socketEmit(Commands.Instance.ClientLeaveRoom, jsonData)
                //Because server don't response when user is being host ==>
                _ = self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
    
    //MARK: - Update room tasks
    @IBAction func btnUpdateRoom(_ sender: AnyObject) {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true,
            showCircularIcon: true,
            titleColor: UIColor.purple
        )
        
        
        let alertView:SCLAlertView = SCLAlertView(appearance: appearance)
        let subview:UIView = UIView(frame: CGRect(x:0, y:0, width: 220, height: 130))
        let x:CGFloat = 10
        let width:CGFloat = 200
        
        // Add textfield for Room name
        let txtRoomName = UITextField(frame: CGRect(x:x, y:10, width: width, height: 30))
        txtRoomName.standardTextField(borderColor: UIColor.red.cgColor, placeHolder: "Room name")
        subview.addSubview(txtRoomName)
        if let roomName:String = self.thisRoom.roomName {
            txtRoomName.text = roomName
        }
        
        // Add textfield for bet
        let txtMoneyBet = UITextField(frame: CGRect(x: x,y: txtRoomName.frame.maxY + 10,width: width,height: 30))
        txtMoneyBet.standardTextField(borderColor: UIColor.yellow.cgColor, placeHolder: "Coin bet")
        txtMoneyBet.keyboardType = UIKeyboardType.numberPad
        subview.addSubview(txtMoneyBet)
        if let coin:Double = self.thisRoom.moneyBet {
            txtMoneyBet.text = "\(Int(coin))"
        }
        
        //Add label...Bo
        let lblBo:UILabel = UILabel(frame: CGRect(x: x, y: txtMoneyBet.frame.maxY + 10, width: 90, height: 40))
        lblBo.text = "Bo >>"
        lblBo.font = UIFont(name: "Chalkboard SE", size: 30)
        lblBo.textAlignment = NSTextAlignment.center
        subview.addSubview(lblBo)
        
        // Add pickerView for best of
        let picker:UIPickerView = UIPickerView(frame: CGRect(x: 100, y: txtMoneyBet.frame.maxY + 10, width: 110, height: 40))
        picker.delegate = self
        picker.layer.borderColor = UIColor.black.cgColor
        picker.layer.borderWidth = 1.5
        picker.layer.cornerRadius = 3
        picker.selectRow(2, inComponent: 0, animated: true)
        subview.addSubview(picker)
        
        alertView.customSubview = subview
        
        //Update tasks
        alertView.addButton("Update", backgroundColor: UIColor.green, textColor: UIColor.white, showDurationStatus: false) {
            
            let name:String = txtRoomName.text!
            let bo:Int = Int(self.best_of[picker.selectedRow(inComponent: 0)])!
            if let moneyBet:Double = Double(txtMoneyBet.text!) {
                self.prepareForEmit(name: name, moneyBet: moneyBet, best_of: bo)
            }
            
        }
        
        alertView.showEdit("Updating Room", subTitle: "", closeButtonTitle: "Cancel", colorStyle: 0xc38cff, colorTextButton: 0xfc0217
            , animationStyle: .topToBottom)
        
    }
    //Update room infor emit function
    func prepareForEmit(name: String, moneyBet: Double, best_of: Int) {
        if name != Contants.Instance.null && moneyBet > 0 {
            if let id:String = thisRoom.id {
                let jsonData:Dictionary<String, Any> = [Contants.Instance.room_id: id, Contants.Instance.room_name: name, Contants.Instance.money_bet: moneyBet, Contants.Instance.best_of: best_of]
                
                if let coin: Int = MyProfile.Instance.coin_card {
                    if otherUserCoin != nil {
                        if moneyBet > Double(coin) || moneyBet > Double(otherUserCoin) {
                            self.showNotification(title: "Notice!", message: "Both of player did not enough coins for bet!")
                        } else {
                            SocketIOManager.Instance.socketEmit(Commands.Instance.ClientUpdateRoomInfo, jsonData)
                        }
                    } else if moneyBet > Double(coin) {
                        self.showNotification(title: "Notice!", message: "You did not enough coins for bet!")
                    } else {
                        SocketIOManager.Instance.socketEmit(Commands.Instance.ClientUpdateRoomInfo, jsonData)
                    }
                }
            }
        }
    }
    
    
    @IBAction func btnReadyStart(_ sender: UIButton) {
        
        if self.isHost {
            //MARK: - Play button on host user
            //Perform segue to starting game 
            if let room_id:String = thisRoom.id {
                let jsonData:Dictionary<String, Any> = [Contants.Instance.room_id: room_id]
                SocketIOManager.Instance.socketEmit(Commands.Instance.ClientsStartPlaying, jsonData)
            }
            
        } else {
            //check user money with room bet money
            if (MyProfile.Instance.coin_card ?? 0) < Int(self.thisRoom.moneyBet ?? 0) {
                self.showNotification(title: "Notice!", message: "You don't have enough money to play this room!")
                return
            }
            
            if isClientReady {
                if let room_id:String = self.thisRoom.id {
                    SocketIOManager.Instance.socketEmit(Commands.Instance.ClientReady, [Contants.Instance.room_id: room_id])
                    self.isClientReady = false
                }
            }
        }
        
    }
    
    //MARK: - Transfer data to next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Contants.Instance.segueMain {
            if let mainVC:MainViewController = segue.destination as? MainViewController {
                mainVC.thisRoom = self.thisRoom
                mainVC.match_id = self.matchId
                mainVC.otherUser = self.otherUser
                //mainVC.delegate = self
            }
        }
    }
    
}

extension WaitingViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return best_of.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return best_of[row]
    }
}
