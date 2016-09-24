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
var opponent:User!

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
            
            let tableName = ref.child("ListOnlinePlayer")
            let userId = tableName.child(activeUser.id)
            let user:Dictionary<String, String> = ["email": activeUser.email, "nickName": activeUser.nickName, "avatarUrl": activeUser.avatarUrl]
            userId.setValue(user)
            
            // Kiểm tra player online hay offline.
//            userId.onDisconnectRemoveValue()
            
            // Lấy thông tin user xuống lại máy từ Database.
            tableName.observeEventType(.ChildAdded, withBlock: { (snapshot) in
                let postDict = snapshot.value as? [String:AnyObject]
                
                if postDict != nil {
                    let email:String = (postDict?["email"])! as!  String
                    let nickName:String = (postDict?["nickName"])! as!  String
                    let avatarUrl:String = (postDict?["avatarUrl"])! as!  String
                    
                    let user:User = User(id: snapshot.key, email: email, nickName: nickName, avatarUrl: avatarUrl)
                    
                    // Kiểm tra nếu user
                    if user.id != activeUser.id {
                        self.listPlayer.append(user)
                    }
                    
                    self.tbvListPlayer.reloadData()
                }
            })
            
//            tableName.observeEventType(.ChildRemoved, withBlock: { (Snapshot) in
//                let postDict = Snapshot.value as? [String:AnyObject]
//                let emailToFind:String = (postDict?["email"])! as! String
//                let nickNameToFind:String = (postDict?["nickName"])! as!  String
//                let avatarUrlToFind:String = (postDict?["avatarUrl"])! as!  String
//                
//                let user:User = User(id: Snapshot.key, email: emailToFind, nickName: nickNameToFind, avatarUrl: avatarUrlToFind)
//                
//                for(index, email) in self.listPlayer.enumerate() {
//                    if activeUser.email == emailToFind {
//                        let indexPath = NSIndexPath(forRow: index, inSection: 0)
//                        self.listPlayer.removeAtIndex(index)
//                        
//                    }
//                }
//            })
            
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        opponent = listPlayer[indexPath.row]
        
        let url:NSURL = NSURL(string:  opponent.avatarUrl)!
        let data:NSData = NSData(contentsOfURL: url)!
        opponent.avatarImage = UIImage(data: data)
        print(opponent)
        
        let sence = self.storyboard?.instantiateViewControllerWithIdentifier("Main")
        if sence != nil {
            presentViewController(sence!, animated: true, completion: nil)
        }
    }
}









