//
//  Contants.swift
//  OanTuTi
//
//  Created by Phuc on 11/3/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import Foundation

class Contants {
    
    //Singleton Pattern
    static let Instance :Contants = Contants()
    
    init() {}
    
    //----------------Segue------------------------
    let segueRegister: String = "segueRegister"
    let segueMenu: String = "segueMenu"
    let segueProfile: String = "segueProfile"
    //---------------CellID------------------------
    let cellRoom: String = "roomCell"
    //---------------Contants----------------------
    let null: String = ""
    let avatar: String = "avatar"
    let coin_card: String = "coin_card"
    let nickname: String = "displayName"
    let email: String = "email"
    let file: String = "file"
    let histories: String = "histories"
    let isSuccess: String = "isSuccess"
    let loses: String = "loses"
    let message: String = "message"
    let name: String = "name"
    let noti_token: String = "noti_token"
    let uid: String = "uid"
    let user: String = "user"
    let pass: String = "pass"
    let socket_id: String = "socket_id"
    let statistics: String = "statistics"
    let wins: String = "wins"
    
    
}
