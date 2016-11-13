//
//  NotificationCommands.swift
//  OanTuTi
//
//  Created by Phuc on 11/12/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import Foundation

class NotificationCommands {
    
    static let Instance:NotificationCommands = NotificationCommands()
    
    init() {}
    
    //Variables -> Name of Notification Delegate
    let signupDelegate:Notification.Name = Notification.Name("signup")
    let profileDelegate:Notification.Name = Notification.Name("profile")
    let updateRoomDelegate:Notification.Name = Notification.Name("roomsList")
    let createRoomDelegate:Notification.Name = Notification.Name("createRoom")
    let waitingDelegate:Notification.Name = Notification.Name("waiting")
    let leaveRoomDelegate:Notification.Name = Notification.Name("leaveRoom")
    let joinRoomDelegate:Notification.Name = Notification.Name("joinRoom")
    let updateRoomInfoDelegate:Notification.Name = Notification.Name("updateRoom")
    
}
