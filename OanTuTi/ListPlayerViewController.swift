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
            activeUser = User(id: uid, email: email!, nickName: name!, avatarUrl: String(describing: photoUrl!))
            
            let tableName = ref.child("ListOnlinePlayer")
            let userId = tableName.child(activeUser.id)
            let user:Dictionary<String, String> = ["email": activeUser.email, "nickName": activeUser.nickName, "avatarUrl": activeUser.avatarUrl]
            userId.setValue(user)
            
            // Kiểm tra player online hay offline.
            userId.onDisconnectRemoveValue()
            
            // Lấy thông tin user xuống lại máy từ Database.
            tableName.observe(.childAdded, with: { (snapshot) in
                let postDict = snapshot.value as? [String:AnyObject]
                
                if postDict != nil {
                    let email:String = (postDict?["email"])! as!  String
                    let nickName:String = (postDict?["nickName"])! as!  String
                    let avatarUrl:String = (postDict?["avatarUrl"])! as!  String
                    
                    let user:User = User(id: snapshot.key, email: email, nickName: nickName, avatarUrl: avatarUrl)
                    
                    print("--------------------\(snapshot.value)")
                    // Kiểm tra nếu user
                    if user.id != activeUser.id {
                        self.listPlayer.append(user)
                    }
                    
                    self.tbvListPlayer.reloadData()
                }
            })
            
//            tableName.observe(.childRemoved, with: { snap in
//                guard let emailToFind = snap.value as? String else { return }
//                for (index, email) in self.listPlayer.enumerated() {
//                    if email.email == emailToFind {
//                        let indexPath = IndexPath(row: index, section: 0)
//                        self.listPlayer.remove(at: index)
//                        self.deleteRows(at: [indexPath], with: .fade)
//                    }
//                }
//            })
            
//            FIRAuth.auth()!.addStateDidChangeListener { auth, user in
//                guard let user = user else { return }
//                activeUser = User(authData: activeUser)
//                let currentUserRef = self.usersRef.child(self.user.uid)
//                currentUserRef.setValue(self.user.email)
//                currentUserRef.onDisconnectRemoveValue()
//            }
//            
            
        } else {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
extension ListPlayerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPlayer.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListPlayerTableViewCell
        
        cell.lblNickName.text = listPlayer[(indexPath as NSIndexPath).row].nickName
        cell.avatarImage.loadAvatar(listPlayer[(indexPath as NSIndexPath).row].avatarUrl)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        opponent = listPlayer[(indexPath as NSIndexPath).row]
        
        let url:URL = URL(string:  opponent.avatarUrl)!
        let data:Data = try! Data(contentsOf: url)
        opponent.avatarImage = UIImage(data: data)
        print(opponent)
        
        let sence = self.storyboard?.instantiateViewController(withIdentifier: "Main")
        if sence != nil {
            present(sence!, animated: true, completion: nil)
        }
    }
}









