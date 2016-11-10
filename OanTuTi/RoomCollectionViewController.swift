//
//  RoomCollectionViewController.swift
//  OanTuTi
//
//  Created by Phuc on 11/7/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

//MARK: - Global variables
var isEmit:Bool = false

class RoomCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        ///Make spacing margin
        let spacing:CGFloat = (self.view.frame.size.width - 280) / 4
        self.collectionView?.contentInset = UIEdgeInsets(top: 10, left: spacing, bottom: 0, right: spacing)
        
        //set background image
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "background");
        bgImage.contentMode = .scaleToFill
        self.collectionView?.backgroundView = bgImage
        
        //Add observation
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveEvent), name: updateRoomDelegate, object: nil)
        //set height between sections
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.view.rotateXAxis()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - Delegate from Listen Class
    func receiveEvent() {
        self.collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return rooms.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return rooms[section].count
    }

    //Draw room on interface (each cell)
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Contants.Instance.cellRoom, for: indexPath)
    
        if rooms.count > 0 {
            //Get room name
            if let lblRoom: UILabel = cell.viewWithTag(1) as? UILabel {
                if let room_name:String = rooms[indexPath.section][indexPath.row].roomName {
                    lblRoom.text = room_name
                }
            }
            //Get money bet
            if let lblBet:UILabel = cell.viewWithTag(3) as? UILabel {
                if let money:Double = rooms[indexPath.section][indexPath.row].moneyBet {
                    lblBet.text = "$\(Int(money))"
                } else {
                    lblBet.text = "$0"
                }
            }
            
            //state image            
            if let imgView:UIImageView = cell.viewWithTag(2) as? UIImageView {
                if let roomState:String = rooms[indexPath.section][indexPath.row].roomState {
                    bindImage(imgView: imgView, state: roomState)
                }
            }
            
            //cell properties
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            cell.layer.borderColor = UIColor.lightText.cgColor
            cell.layer.borderWidth = 5
            cell.contentView.backgroundColor = UIColor.init(Hex: 0xd4ded7)
        }
        
        return cell
    }
    
    //MARK: - Roload page manager
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let index:Int = indexPath.row
        let section:Int = indexPath.section
        pageNeedReload = section + 1
        
        //Kick flag, make collectionView can reload data
        if section + 1 == currentPage && index >= 7 && totalPage > currentPage {
            isEmit = false
        }
        //When scroll down again, collectionView will reload data
        if pageNeedReload < currentPage {
            isEmit = false
            currentPage -= 1
        }
        
        //Get data if receive permission from code above (isEmiting)
        if !isEmit {
            
            currentPage += 1
            SocketIOManager.Instance.socketEmit(Commands.Instance.ClientGetRoomByPage, [Contants.Instance.page: currentPage])
            
            isEmit = true
        }
        
    }
    
    //MARK: - Test join room
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SocketIOManager.Instance.socketEmit(Commands.Instance.ClientJoinRoom, [Contants.Instance.room_id: rooms[indexPath.section][indexPath.row].id!, Contants.Instance.uid: myProfile.uid!])
    }
    
    //MARK: - Binding data to Cell of collectionView
    func bindImage(imgView: UIImageView, state:String) {
        if state == Contants.Instance.joinable {
            // Joinable
            imgView.image = UIImage(named: "1people")
            imgView.tintColor = UIColor.init(Hex: 0x07cc28)
        } else if state == Contants.Instance.full {
            // Full
            imgView.image = UIImage(named: "2people")
            imgView.tintColor = UIColor.init(Hex: 0x07cc28)
        } else {
            // Playing
            imgView.image = UIImage(named: "2people")
            imgView.tintColor = UIColor.init(Hex: 0xff3e1c)
        }
        imgView.image = imgView.image!.withRenderingMode(.alwaysTemplate)
    }
    
    //MARK: - Create room tasks
    @IBAction func createRoom(_ sender: AnyObject) {
        
        let jsonData:Dictionary<String, Any> = [Contants.Instance.room_name: "\(arc4random())", Contants.Instance.money_bet: 400.0, "host_uid": myProfile.uid!]
        
        SocketIOManager.Instance.socketEmit(Commands.Instance.ClientCreateRoom, jsonData)
        
        
    }

}
