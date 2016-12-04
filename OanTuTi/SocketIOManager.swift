//
//  SocketIOManager.swift
//  OanTuTi
//
//  Created by Phuc on 11/4/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import Foundation
class SocketIOManager {
    
    static let Instance:SocketIOManager = SocketIOManager()
    
    var socket:SocketIOClient = SocketIOClient(socketURL: URL(string: "https://oan-tu-ti.herokuapp.com")!)

    init() {}
    
    //Start connection
    func establishConnection() {
        socket.connect()
    }
    //Logout when into background
    func closeConnection() {
        //Static set to myProfile variables
        if let uid: String = MyProfile.Instance.uid {
            disconnect([Contants.Instance.uid: uid])
        }
    }
    
    //Emit an event
    func socketEmit(_ event: String, _ items: Dictionary<String, Any>) {
        socket.emit(event, items)
    }
    
    //User disconnect
    func disconnect(_ uid: Dictionary<String, Any>) {
        
        socket.emit(Commands.Instance.ClientLogout, uid)
    }
    
}
