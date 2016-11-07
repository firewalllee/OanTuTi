//
//  User.swift
//  OanTuTi
//
//  Created by Phuc on 11/4/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import Foundation

struct Statistics {
    var loses: Int?
    var wins: Int?
    init(_ win: Int, _ lost: Int) {
        self.wins = win
        self.loses = lost
    }
}

class User {
    
    var avatar: String?
    var coin_card: Int?
    var histories: String?
    var name: String?
    var noti_token: String?
    var socket_id: String?
    var statis: Statistics?
    var uid: String?
    
    init() {}
    
    init(_ json: Dictionary<String, Any>) {
     
        if let avatar: String = json[Contants.Instance.avatar] as? String {
            self.avatar = avatar
        }
        if let coin_card: Int = json[Contants.Instance.coin_card] as? Int {
            self.coin_card = coin_card
        }
        if let histories:String = json[Contants.Instance.histories] as? String {
            self.histories = histories
        }
        if let name: String = json[Contants.Instance.name] as? String {
            self.name = name
        }
        if let noti_token: String = json[Contants.Instance.noti_token] as? String {
            self.noti_token = noti_token
        }
        if let socket_id: String = json[Contants.Instance.socket_id] as? String {
            self.socket_id = socket_id
        }
        if let statis:Dictionary<String, Int> = json[Contants.Instance.statistics] as? Dictionary<String, Int> {
            if let loses = statis[Contants.Instance.loses] {
                if let wins = statis[Contants.Instance.wins] {
                    self.statis = Statistics(wins, loses)
                }
            }
        }
        if let uid: String = json[Contants.Instance.uid] as? String {
            self.uid = uid
        }
    }
    
}
