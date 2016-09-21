//
//  User.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 9/20/16.
//  Copyright © 2016 Lee Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let id:String!
    let email:String!
    let nickName:String!
    let avatarUrl:String!
    let avatarImage:UIImage!
    
    init(){
        id = ""
        email = ""
        nickName = ""
        avatarUrl = ""
        avatarImage = UIImage(named: "avatar")
    }
    init(id:String, email:String, nickName:String, avatarUrl:String){
        self.id = id
        self.email = email
        self.nickName = nickName
        self.avatarUrl = avatarUrl
        self.avatarImage = UIImage(named: "avatar")
    }
}
