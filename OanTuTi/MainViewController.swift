//
//  MainViewController.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 11/16/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    //MARK: - Mapped items
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMatchResult: UILabel!
    @IBOutlet weak var lblBestOf: UILabel!
    
    
    ////-> Guest
    @IBOutlet weak var imgGuestAvatar: UIImageView!
    @IBOutlet weak var imgGuestChoose: UIImageView!
    @IBOutlet weak var lblGuestName: UILabel!
    @IBOutlet weak var lblGuestReady: UILabel!
    @IBOutlet weak var lblGuestScore: UILabel!
    
    ////-> User 
    @IBOutlet weak var imgUserAvatar: UIImageView!
    @IBOutlet weak var imgUserChoose: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserReady: UILabel!
    @IBOutlet weak var lblUserScore: UILabel!
    @IBOutlet weak var btnBao: UIButton!
    @IBOutlet weak var btnBua: UIButton!
    @IBOutlet weak var btnKeo: UIButton!
    @IBOutlet weak var btnReady: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //-> Server send match result
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveMatchResultEvent), name: NotificationCommands.Instance.matchResultDelegate, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.viewProperties()
    }
    
    func viewProperties() {
        imgGuestAvatar.lightBorder(with: 4)
        imgUserAvatar.lightBorder(with: 4)
    }
    
    func receiveMatchResultEvent(notification: Notification) {
        if let response: Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            if let win: Bool = response[Contants.Instance.win] as? Bool {
                if win {
                    if let restCoins: Int = response[Contants.Instance.restCoinCard] as? Int {
                        MyProfile.Instance.coin_card = restCoins
                        showNotification(title: "You won!", message: "Your cions: \(MyProfile.Instance.coin_card)")
                    }
                } else if let restCoins: Int = response[Contants.Instance.restCoinCard] as? Int {
                        MyProfile.Instance.coin_card = restCoins
                        showNotification(title: "You lose!", message: "Your cions: \(MyProfile.Instance.coin_card)")
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
