//
//  View.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 9/21/16.
//  Copyright © 2016 Lee Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadAvatar (link:String) {
        let url:NSURL = NSURL(string: link)!
        let data:NSData = NSData(contentsOfURL: url)!
        self.image = UIImage(data: data)
    }
}