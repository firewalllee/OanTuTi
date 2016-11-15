//
//  MyUser.swift
//  OanTuTi
//
//  Created by Phuc on 11/15/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import Foundation

class MyProfile: User {
    
    static var Instance:MyProfile = MyProfile()
    
    //save bytes array of image
    var imgData:Data?
    
    override init() {
        super.init()
    }
    
    override init(_ json:Dictionary<String, Any>) {
        super.init(json)
        
        if let imgStr:String = avatar {
            guard let url:URL = URL(string: imgStr) else {
                self.imgData = nil
                return
            }
            do {
                self.imgData = try Data(contentsOf: url)
            } catch {
                self.imgData = nil
            }
        }
    }
    
}
