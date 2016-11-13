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
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.view.rotateYAxis()
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
        
        if let userName:String = myProfile.name {
            self.lblUserName.text = userName
        }
        if let imgUserAvatar:String = myProfile.avatar {
            self.imgUserAvatar.loadAvatar(imgUserAvatar)
        }
        if let coin:Int = myProfile.coin_card {
            self.lblUserMoney.text = "\(coin)"
        }
        if self.isHost {
            self.lblUserName.text = self.lblUserName.text! + " (Host)"
            self.nullOtherPlayer()
            
        } else {
            self.btnReadyStart.setBackgroundImage(#imageLiteral(resourceName: "ready"), for: UIControlState.normal)
            self.lblGuestReady.isHidden = true
            
            if let hostName:String = otherUser.name {
                self.lblGuestName.text = hostName + " (Host)"
            }
            if let hostAvatar:String = otherUser.avatar {
                self.imgGuestAvatar.loadAvatar(hostAvatar)
            }
            if let hostCoin:Int = otherUser.coin_card {
                self.lblGuestMoney.text = "$ \(hostCoin)"
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
    }
    //Get infor of new player join room
    func playerJoin(_ otherUser:User) {
        if let playerName:String = self.otherUser.name {
            self.lblGuestName.text = playerName
        }
        if let coins:Int = self.otherUser.coin_card {
            self.lblGuestMoney.text = "$ \(coins)"
        }
        if let avatar:String = self.otherUser.avatar {
            self.imgGuestAvatar.isHidden = false
            self.imgGuestAvatar.loadAvatar(avatar)
        }
    }
    
    //MARK: - Listener response
    //-> player leaver room
    func receivePlayerLeaveRoomEvent(notification: Notification) {
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            print("Player leave Room =>", response)
            if self.isHost {
                self.nullOtherPlayer()
            } else {
                self.nullOtherPlayer()
                self.lblUserName.text = "\(self.lblUserName.text!) (Host)"
                self.btnReadyStart.setBackgroundImage(#imageLiteral(resourceName: "start"), for: UIControlState.normal)
                self.isHost = true
            }
        }
    }
    //-> User leave room
    func userLeaveRoom(notification: Notification) {
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            print("Leave Room", response)
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
                //Check fail, -> return function
                if let message:String = response[Contants.Instance.message] as? String {
                    self.showNotification(title: "Notice", message: message)
                }
                return
            }
            
            self.otherUser = User(response)
            self.playerJoin(self.otherUser)
            
        }
    }
    
    //MARK: - Leave room task
    @IBAction func leaveRoom(_ sender: AnyObject) {
        
        if let room_id = thisRoom.id {
            if let uid:String = myProfile.uid {
                
                let jsonData:Dictionary<String, Any> = [Contants.Instance.room_id: room_id, Contants.Instance.uid: uid]
                SocketIOManager.Instance.socketEmit(Commands.Instance.ClientLeaveRoom, jsonData)
                //Because server don't response when user is being host ==>
                _ = self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
    
    //MARK: - Update room tasks
    @IBAction func btnUpdateRoom(_ sender: AnyObject) {
        
        
        
    }
    
    
}
