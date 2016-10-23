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


        
        let queue = DispatchQueue(label: "LoadImage", attributes: DispatchQueue.Attributes.concurrent, target: nil)
        let activity:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activity.frame = CGRect(x: self.frame.size.width/2, y: self.frame.size.height/2, width: 0, height: 0)
        activity.color = UIColor.gray
        self.addSubview(activity)
        activity.startAnimating()
        
        queue.async {
            let url:URL = URL(string: link)!
            do {
                let data:Data = try Data(contentsOf: url)
                DispatchQueue.main.async(execute: {
                    activity.stopAnimating()
                    self.image = UIImage(data: data)
                })
            } catch {
                activity.stopAnimating()
            }
        }
    }
    func loadUpdateAvatar (_ linkPhoto:URL) {


        let queue = DispatchQueue(label: "LoadImage", attributes: DispatchQueue.Attributes.concurrent, target: nil)
        let activity:UIActivityIndicatorView = UIActivityIndicatorView()
        activity.frame = CGRect(x: self.frame.size.width/2, y: self.frame.size.height/2, width: 0, height: 0)
        activity.color = UIColor.gray
        self.addSubview(activity)
        activity.startAnimating()
        
        queue.async {
            do {
                let data:Data = try Data(contentsOf: linkPhoto)
                DispatchQueue.main.async(execute: {
                    activity.stopAnimating()
                    self.image = UIImage(data: data)
                })
            } catch {
                activity.stopAnimating()
            }
        }
    }
    
    
}
