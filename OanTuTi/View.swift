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
    func loadAvatar (_ link:String) {
        let url:URL = URL(string: link)!
        let data:Data = try! Data(contentsOf: url)
        self.image = UIImage(data: data)
    }
}
