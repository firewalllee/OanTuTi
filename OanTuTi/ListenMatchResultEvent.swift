//
//  ListenMatchResultEvent.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 11/17/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import Foundation

class ListenMatchResultEvent {
    init() {}
    
    static func ListenMatchResultResponse() {
        // Recive match result from server.
        SocketIOManager.Instance.socket.on(Commands.Instance.ServerSendMatchResult) { (data, ack) in
            if let response: Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                // Send this delegate to Main screen.
                NotificationCenter.default.post(name: NotificationCommands.Instance.matchResultDelegate, object: response)
            }
        }
    }
}
