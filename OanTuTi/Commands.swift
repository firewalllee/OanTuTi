//
//  Commands.swift
//  OanTuTi
//
//  Created by Phuc on 11/3/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import Foundation

class Commands {

    //Singleton Pattern
    static let Instance: Commands = Commands()
    
    init() {}
    
    //Contant commands
    let ClientLogin: String = "Client-Login"
    let ClientLoginRs: String = "Client-Login-Rs"
    
    let ClientSignUp: String = "Client-Sign-Up"
    let ClientSignUpRs: String = "Client-Sign-Up-Rs"
    
    let ClientLogout: String = "disconnect"
    
    let ClientUpdateProfile: String = "Client-Update-Profile"
    let ClientUpdateProfileRs: String = "Client-Update-Profile-Rs"
    
}
