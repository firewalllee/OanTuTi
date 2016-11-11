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
var myRoomId:String?

class RoomCollectionViewController: UICollectionViewController {
    
    //MARK: - Declarations
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView()

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
        
        // Listen Create room event from server
        SocketIOManager.Instance.socket.on(Commands.Instance.ClientCreateRoomRs) { (data, ack) in
            if let response: Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
                if let isSuccess: Bool = response[Contants.Instance.isSuccess] as? Bool {
                    //-------CheckUpdate----------------------------
                    if isSuccess {
                        if let room_id:String = response[Contants.Instance.room_id] as? String {
                            myRoomId = room_id
                        }
                        self.dismiss(animated: true) {
                            self.performSegue(withIdentifier: Contants.Instance.segueWaiting, sender: nil)
                        }
                    } else {
                        self.dismiss(animated: true) {
                            if let message: String = response[Contants.Instance.message] as? String {
                                self.showNotification(title: "Notice!", message: message)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.view.rotateXAxis()
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
    
    //MARK:- Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Contants.Instance.segueWaiting {
            self.collectionView?.reloadData()
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
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: true,
            titleColor: UIColor.green
        )
        
        
        let alertView = SCLAlertView(appearance: appearance)
        let subview = UIView(frame: CGRect(x:0, y:0, width: 220, height: 100))
        let x = (subview.frame.width - 200) / 2
        
        // Add textfield for Room name
        let txtRoomName = UITextField(frame: CGRect(x:x, y:10, width: 200, height: 30))
        txtRoomName.layer.borderColor = UIColor.red.cgColor
        txtRoomName.layer.borderWidth = 1.5
        txtRoomName.layer.cornerRadius = 3
        txtRoomName.placeholder = "Room name"
        txtRoomName.textAlignment = NSTextAlignment.center
        txtRoomName.spellCheckingType = UITextSpellCheckingType.no
        txtRoomName.autocorrectionType = UITextAutocorrectionType.no
        subview.addSubview(txtRoomName)
        
        // Add textfield for bet
        let txtMoneyBet = UITextField(frame: CGRect(x: x,y: txtRoomName.frame.maxY + 10,width: 200,height: 30))
        txtMoneyBet.layer.borderColor = UIColor.yellow.cgColor
        txtMoneyBet.layer.borderWidth = 1.5
        txtMoneyBet.layer.cornerRadius = 3
        txtMoneyBet.placeholder = "Coin bet"
        txtMoneyBet.textAlignment = NSTextAlignment.center
        txtMoneyBet.spellCheckingType = UITextSpellCheckingType.no
        txtMoneyBet.autocorrectionType = UITextAutocorrectionType.no
        subview.addSubview(txtMoneyBet)
        
        alertView.customSubview = subview
        
        let alertViewIcon = UIImage(named: "createRoom") //Replace the IconImage text with the image name
        alertView.addButton("Create", backgroundColor: UIColor.green, textColor: UIColor.white, showDurationStatus: false) {
            
            let roomName: String = txtRoomName.text!
            if let money_bet:Double = Double(txtMoneyBet.text!) {
                // Check room name and bet.
                if roomName != Contants.Instance.null {
                    // Waiting indicator
                    self.waitingIndicator(with: self.indicator)
                    let jsonData:Dictionary<String, Any> = [Contants.Instance.room_name: roomName, Contants.Instance.money_bet: money_bet, Contants.Instance.host_uid: myProfile.uid!]
                    SocketIOManager.Instance.socketEmit(Commands.Instance.ClientCreateRoom, jsonData)
                } else {
                    self.showNotification(title: "Notice!", message: "Fail to create your room. Try again and please make sure you fill in the name and the bet is a number!")
                }
            }
        }
        alertView.addButton("Cancle", backgroundColor: UIColor.lightGray, textColor: UIColor.red, showDurationStatus: false) {
            
        }
        
        alertView.showEdit("Create Room", subTitle: "", closeButtonTitle: "Cancel", colorStyle: 0xc38cff, colorTextButton: 0xfc0217
            , circleIconImage: alertViewIcon, animationStyle: .topToBottom)
    }

}
