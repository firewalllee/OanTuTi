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
        //Player leave room
        SocketIOManager.Instance.socket.on(Commands.Instance.PlayerLeaveRoom) { (data, ack) in
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                //Send this delegate to Waiting room screen
                NotificationCenter.default.post(name: NotificationCommands.Instance.waitingDelegate, object: response)
            }
        }
        
        //User leave room
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientLeaveRoomRs) { (data, ack) in
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                NotificationCenter.default.post(name: NotificationCommands.Instance.leaveRoomDelegate, object: response)
            }
        }
        
        //Client Update room info
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientUpdateRoomInfoRs) { (data, ack) in
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                //print(response)
                NotificationCenter.default.post(name: NotificationCommands.Instance.updateRoomInfoDelegate, object: response)
            }
        }
        
        //Client Ready
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientReadyRs) { (data, ack) in
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                //Send to waiting room
                NotificationCenter.default.post(name: NotificationCommands.Instance.readyDelegate, object: response)
            }
        }
        //Client start game
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientsStartPlayingRs) { (data, ack) in
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                NotificationCenter.default.post(name: NotificationCommands.Instance.clientSartgameDelegate, object: response)
            }
        }
        
    }
    
}
