//
//  SocketIOManager.swift
//  AppChat
//
//  Created by Phuc on 10/23/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import Foundation

class SocketIOManager:NSObject {
    
    public static let sharedInstance = SocketIOManager()
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "https://oan-tu-ti.herokuapp.com")!)
    
    override init(){
        super.init()
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }

    func SocketEmit(command:String, items:SocketData...) {
        socket.emit(command, items)
    }
    
}
