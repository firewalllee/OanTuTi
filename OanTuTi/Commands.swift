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
    
    let ClientCreateRoom: String = "Client-Create-Room"
    let ClientCreateRoomRs: String = "Client-Create-Room-Rs"
    
    let ClientGetFirstRoomPage: String = "Server-Send-First-Rooms-Page"
    
    let ClientGetRoomByPage: String = "Client-Get-Room-By-Page"
    let ClientGetRoomByPageRs: String = "Client-Get-Room-By-Page-Rs"
    
    let ClientJoinRoom: String = "Client-Join-Room"
    let ClientJoinRoomRs: String = "Client-Join-Room-Rs"
    
    let ClientLeaveRoom: String = "Client-Leave-Room"
    let ClientLeaveRoomRs: String = "Client-Leave-Room-Rs"
    
    let PlayerLeaveRoom: String = "Player-Leave-Room"
    
    let ClientReady: String = "Client-Ready"
    let ClientReadyRs: String = "Client-Ready-Rs"
    
    let ClientUpdateRoomInfo: String = "Client-Update-Room-Info"
    let ClientUpdateRoomInfoRs: String = "Client-Update-Room-Info-Rs"
    
    let ClientsStartPlaying:String = "Clients-Start-Playing"
    let ClientsStartPlayingRs:String = "Clients-Start-Playing-Rs"
    
    let ClientSubmitSelection:String = "Client-Submit-Selection"
    let ClientSubmitSelectionRs:String = "Client-Submit-Selection-Rs"
    
}
