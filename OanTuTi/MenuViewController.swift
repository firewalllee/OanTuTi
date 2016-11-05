//
//  MenuViewController.swift
//  OanTuTi
//
//  Created by Phuc on 11/4/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let myName:String = myProfile.name {
            print(myName)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - signout tasks
    @IBAction func btnLogout(_ sender: UIBarButtonItem) {
        if let uid:String = myProfile.uid {
            let jsonUID:Dictionary<String, Any> = [Contants.Instance.uid: uid]
            SocketIOManager.Instance.disconnect(jsonUID)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    

}
