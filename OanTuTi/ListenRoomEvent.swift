//
//  ListenChatControl.swift
//  AppChat
//
//  Created by Phuc on 10/29/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

class ListenRoomEvent {
    
    //Declarations
    private var rooms:Array<Array<Room>> = Array<Array<Room>>()
    private var totalPage:Int = 1
    private var pageNeedReload:Int = 2
    
    static let Instance:ListenRoomEvent = ListenRoomEvent()
    
    private init() {}
    
    ///Design Patterns-----------------------
    func getRooms() -> Array<Array<Room>> {
        return self.rooms
    }
    func getTotalPage() -> Int {
        return self.totalPage
    }
    func setPageNeedReload(_ page: Int) {
        self.pageNeedReload = page
    }
    ///--------------------------------------
    
    func ListenRoomsList() {
        
        //Listen event page from server
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientGetFirstRoomPage) { (data, ack) in
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                //Get total page
                if let total:Int = response[Contants.Instance.total_page] as? Int {
                    self.totalPage = total
                }

                //reset value before reload rooms list
                var firstRooms:Array<Room> = Array<Room>()
                if let roomList:Array<Dictionary<String, Any>> = response[Contants.Instance.rooms] as? Array<Dictionary<String, Any>> {
                    for room in roomList {
                        firstRooms.append(Room(room))
                    }
                    if self.rooms.count > 0 {
                        self.rooms[0] = firstRooms
                    } else {
                        self.rooms.append(firstRooms)
                    }
                    //send delegate to RoomCollectionView
                    if let currentWindow = UIApplication.topViewController() {
                        if currentWindow is RoomCollectionViewController {
                            NotificationCenter.default.post(name: NotificationCommands.Instance.updateRoomDelegate, object: nil)
                        }
                    }
                    //Reload current screen
                    if self.totalPage >= 2 {
                        SocketIOManager.Instance.socketEmit(Commands.Instance.ClientGetRoomByPage, [Contants.Instance.page: self.pageNeedReload])
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
                    if self.pageNeedReload >= 2 {
                        let current:Int = self.pageNeedReload - 1
                        if self.rooms.count > current {
                            self.rooms[current] = continueRooms
                        } else {
                            self.rooms.append(continueRooms)
                        }
                    }
                    
                    //send delegate to RoomCollectionView
                    if let currentWindow = UIApplication.topViewController() {
                        if currentWindow is RoomCollectionViewController {
                            NotificationCenter.default.post(name: NotificationCommands.Instance.updateRoomDelegate, object: nil)
                        }
                    }
                    
                }
            }
        }
        
    }
    
    func ListenCreateRoom() {
        
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientCreateRoomRs) { (data, ack) in

            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                
                //Send to rooms list screen an event when user create room
                NotificationCenter.default.post(name: NotificationCommands.Instance.createRoomDelegate, object: response)
            }
        }
        
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientJoinRoomRs) { (data, ack) in
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                NotificationCenter.default.post(name: NotificationCommands.Instance.joinRoomDelegate, object: response)
            }
         }
        
    }
}
