//
//  WaitingViewController.swift
//  OanTuTi
//
//  Created by Phuc on 11/11/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        SocketIOManager.Instance.socket.on(Commands.Instance.ClientLeaveRoomRs) { (data, ack) in
            print(data)
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                print(response)
                if let isSuccess:Bool = response[Contants.Instance.isSuccess] as? Bool {
                    if isSuccess {
                        print(isSuccess)
                    } else {
                        if let message:String = response[Contants.Instance.message] as? String {
                            self.showNotification(title: "Notice", message: message)
                        }
                    }
                }
            }
        }
        //TEST LEAVEROOM
        SocketIOManager.Instance.socket.on(Commands.Instance.PlayerLeaveRoom) { (data, ack) in
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                print(response)
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.view.rotateYAxis()
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
