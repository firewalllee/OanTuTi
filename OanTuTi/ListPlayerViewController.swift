//
//  ListPlayerViewController.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 9/20/16.
//  Copyright © 2016 Lee Nguyen. All rights reserved.
//

import UIKit
import Firebase

let ref = FIRDatabase.database().reference()
var activeUser:User!

class ListPlayerViewController: UIViewController {

    var listPlayer:Array<User> = Array<User>()
    
    @IBOutlet weak var tbvListPlayer: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hiển thị danh sách player.
        tbvListPlayer.dataSource = self
        tbvListPlayer.delegate = self
        
        
        // Kiểm tra thông tin user hiện tại.
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid
            
            // Lưu thông tin user lên Database.
            activeUser = User(id: uid, email: email!, nickName: name!, avatarUrl: String(photoUrl!))
            
            let tableName = ref.child("ListPlayer")
            let userId = tableName.child(activeUser.id)
            let user:Dictionary<String, String> = ["email": activeUser.email, "nickName": activeUser.nickName, "avatarUrl": activeUser.avatarUrl]
            userId.setValue(user)
            
            // Lấy thông tin user xuống lại máy từ Database.
            tableName.observeEventType(.ChildAdded, withBlock: { (snapshot) in
                let postDict = snapshot.value as? [String:AnyObject]
                
                if postDict != nil {
                    let email:String = (postDict?["email"])! as!  String
                    let nickName:String = (postDict?["nickName"])! as!  String
                    let avatarUrl:String = (postDict?["avatarUrl"])! as!  String
                    
                    let user:User = User(id: snapshot.key, email: email, nickName: nickName, avatarUrl: avatarUrl)
                    self.listPlayer.append(user)
                    print("-------------\(self.listPlayer)")
                    self.tbvListPlayer.reloadData()
                }
            })
        } else {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ListPlayerViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPlayer.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ListPlayerTableViewCell
        
        cell.lblNickName.text = listPlayer[indexPath.row].nickName
        cell.avatarImage.loadAvatar(listPlayer[indexPath.row].avatarUrl)
        return cell
    }
}









