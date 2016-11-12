//
//  ListenWaitingRoomEvent.swift
//  OanTuTi
//
//  Created by Phuc on 11/12/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import Foundation

class ListenWaitingRoomEvent {
    
    init() {}
    
    static func ListenWaitingRoomResponse() {
        
        SocketIOManager.Instance.socket.on(Commands.Instance.PlayerLeaveRoom) { (data, ack) in
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                //Send this delegate to Waiting room screen
                NotificationCenter.default.post(name: NotificationCommands.Instance.waitingDelegate, object: response)
            }
        }
        
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientLeaveRoomRs) { (data, ack) in
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                NotificationCenter.default.post(name: NotificationCommands.Instance.leaveRoomDelegate, object: response)
            }
        }
        
    }
    
}
