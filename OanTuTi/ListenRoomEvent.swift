//
//  ListenChatControl.swift
//  AppChat
//
//  Created by Phuc on 10/29/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import Foundation
import UIKit

var isFirstLogin:Bool = true
var updateRoomDelegate:Notification.Name = Notification.Name("postDelegate")
var rooms:Array<Array<Room>> = Array<Array<Room>>()
var totalPage:Int = 1
var currentPage: Int = 1
var pageNeedReload:Int = 1

class ListenRoomEvent {
    
    init() {}
    
    static func ListenRoomsList() {
        
        //Listen event page from server
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientGetFirstRoomPage) { (data, ack) in
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                //Get total page
                if let total:Int = response[Contants.Instance.total_page] as? Int {
                    totalPage = total
                }
                //reset value before reload rooms list
                var firstRooms:Array<Room> = Array<Room>()
                if let roomList:Array<Dictionary<String, Any>> = response[Contants.Instance.rooms] as? Array<Dictionary<String, Any>> {
                    for room in roomList {
                        firstRooms.append(Room(room))
                    }
                    if rooms.count > 0 {
                        rooms[0] = firstRooms
                    } else {
                        rooms.append(firstRooms)
                    }
                    //send delegate to RoomCollectionView
                    if let currentWindow = UIApplication.topViewController() {
                        if currentWindow is RoomCollectionViewController {
                            NotificationCenter.default.post(name: updateRoomDelegate, object: nil)
                        }
                    }
                    //Reload current screen
                    if totalPage >= 2 && pageNeedReload <= currentPage {
                        SocketIOManager.Instance.socketEmit(Commands.Instance.ClientGetRoomByPage, [Contants.Instance.page: pageNeedReload])
                    }
                }
            }
        }
        
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientGetRoomByPageRs) { (data, ack) in
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                if let roomList:Array<Dictionary<String, Any>> = response[Contants.Instance.rooms] as? Array<Dictionary<String, Any>> {
                    //reset first
                    var continueRooms:Array<Room> = Array<Room>()
                    for room in roomList {
                        continueRooms.append(Room(room))
                    }
                    let current:Int = currentPage - 1
                    if rooms.count > current {
                        rooms[current] = continueRooms
                    } else {
                        rooms.append(continueRooms)
                    }
                    
                    //send delegate to RoomCollectionView
                    if let currentWindow = UIApplication.topViewController() {
                        if currentWindow is RoomCollectionViewController {
                            NotificationCenter.default.post(name: updateRoomDelegate, object: nil)
                        }
                    }
                    
                }
            }
        }
        
    }
}
