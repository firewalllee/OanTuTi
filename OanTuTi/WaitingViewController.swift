//
//  WaitingViewController.swift
//  OanTuTi
//
//  Created by Phuc on 11/11/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

//Global variables
var isFirstLgin:Bool = true

class WaitingViewController: UIViewController {

    //MARK: - Declarations
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add observation
        //->Player Leave Room
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivePlayerLeaveRoomEvent), name: NotificationCommands.Instance.waitingDelegate, object: nil)
        //->This user leave Room
        NotificationCenter.default.addObserver(self, selector: #selector(self.userLeaveRoom), name: NotificationCommands.Instance.leaveRoomDelegate, object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.view.rotateYAxis()
    }
    
    //MARK: - Listener response
    //-> player leaver room
    func receivePlayerLeaveRoomEvent(notification: Notification) {
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            print("Player leave Room =>", response)
        }
    }
    //-> User leave room
    func userLeaveRoom(notification: Notification) {
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            print("Leave Room", response)
            if let isSuccess:Bool = response[Contants.Instance.isSuccess] as? Bool {
                if isSuccess {
                } else {
                    if let message:String = response[Contants.Instance.message] as? String {
                        self.showNotification(title: "Notice", message: message)
                    }
                }
            }
        }
    }
    
    //MARK: - Leave room task
    @IBAction func leaveRoom(_ sender: AnyObject) {
        
        if let room_id = myRoomId {
            if let uid:String = myProfile.uid {
                let jsonData:Dictionary<String, Any> = [Contants.Instance.room_id: room_id, Contants.Instance.uid: uid]
                SocketIOManager.Instance.socketEmit(Commands.Instance.ClientLeaveRoom, jsonData)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
