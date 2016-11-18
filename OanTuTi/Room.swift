//
//  Room.swift
//  OanTuTi
//
//  Created by Phuc on 11/9/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import Foundation

class Room {
    
    var id:String?
    var roomName:String?
    var roomState:String?
    var moneyBet:Double?
    var hostId:String?
    var hostState:Bool?
    var guestId:String?
    var guestState:Bool?
    var best_of:Int = 5
    
    init() {}
    
    init(_ json:Dictionary<String, Any>) {
        if let id:String = json[Contants.Instance.id] as? String {
            self.id = id
        }
        if let room_name:String = json[Contants.Instance.room_name] as? String {
            self.roomName = room_name
        }
        if let money_bet:Double = json[Contants.Instance.money_bet] as? Double {
            self.moneyBet = money_bet
        }
        if let state:String = json[Contants.Instance.state] as? String {
            self.roomState = state
        }
        if let host:Dictionary<String, Any> = json[Contants.Instance.host] as? Dictionary<String, Any> {
            if let uid:String = host[Contants.Instance.uid] as? String {
                self.hostId = uid
            }
            if let state:Bool = host[Contants.Instance.ready] as? Bool {
                self.hostState = state
            }
        }
        if let guest:Dictionary<String, Any> = json[Contants.Instance.guest] as? Dictionary<String, Any> {
            if let uid:String = guest[Contants.Instance.uid] as? String {
                self.hostId = uid
            }
            if let state:Bool = guest[Contants.Instance.ready] as? Bool {
                self.hostState = state
            }
        }
        if let bo:Int = json[Contants.Instance.best_of] as? Int {
            self.best_of = bo
        }
        
    }
    
    init(room_id:String, room_name:String, money_bet: Double = 1000, best_of:Int = 5) {
        self.id = room_id
        self.roomName = room_name
        self.moneyBet = money_bet
        self.best_of = best_of
    }
    
}
