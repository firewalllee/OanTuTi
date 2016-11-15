//
//  ListenRegisterEvent.swift
//  OanTuTi
//
//  Created by Phuc on 11/12/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import Foundation

class ListenRegisterEvent {
    
    init() {}
    
    static func ListenRegisterResponse() {
     
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientSignUpRs) { (data, ack) in
            
            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                
                //Send delegate to Register screen
                NotificationCenter.default.post(name: NotificationCommands.Instance.signupDelegate, object: response)
            }
            
        }
        
    }
    
}
