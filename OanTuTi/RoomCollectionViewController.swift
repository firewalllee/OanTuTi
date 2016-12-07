//
//  RoomCollectionViewController.swift
//  OanTuTi
//
//  Created by Phuc on 11/7/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

class RoomCollectionViewController: UICollectionViewController {
    
    //MARK: - Declarations
    private var rooms:Array<Array<Room>> = Array<Array<Room>>()
    private var totalPage:Int = 1
    private var pageNeedReload:Int = 2
    
    private let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    private var nextRoom:Room = Room()
    private var hostUser:User!
    private var isHost:Bool = true      //Check host or guest in next screen
    private var isEmit:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ///Make spacing margin
        let spacing:CGFloat = (self.view.frame.size.width - 280) / 4
        self.collectionView?.contentInset = UIEdgeInsets(top: 10, left: spacing, bottom: 0, right: spacing)
        
        //get list room from Listener Instance
        self.rooms = ListenRoomEvent.Instance.getRooms()
        
        //set collectionView background image
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "background");
        bgImage.contentMode = .scaleToFill
        self.collectionView?.backgroundView = bgImage
        
        ////----Add observation-----------------
        //->Rooms List
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveEvent), name: NotificationCommands.Instance.updateRoomDelegate , object: nil)
        //->Create Room
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveCreateRoomEvent), name: NotificationCommands.Instance.createRoomDelegate, object: nil)
        //->Join Room
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveJoinRoomEvent), name: NotificationCommands.Instance.joinRoomDelegate, object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.view.rotateXAxis()
    }

    //MARK: - Delegate from Listener Class
    //->Rooms List
    func receiveEvent() {
        //Let main queue to update table view
        DispatchQueue.main.async {
            //Edit here!
            self.rooms = ListenRoomEvent.Instance.getRooms()
            self.totalPage = ListenRoomEvent.Instance.getTotalPage()
            print(self.totalPage)
            self.collectionView?.reloadData()
        }
    }
    //->Create Room
    func receiveCreateRoomEvent(notification:Notification) {
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            
            if let isSuccess: Bool = response[Contants.Instance.isSuccess] as? Bool {
                //-------CheckUpdate----------------------------
                if isSuccess {
                    if let room_id:String = response[Contants.Instance.room_id] as? String {
                        self.nextRoom.id = room_id
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
    //->Join Room
    func receiveJoinRoomEvent(notification: Notification) {
        if let response:Dictionary<String, Any> = notification.object as? Dictionary<String, Any> {
            //print(response)
            if let _:Bool = response[Contants.Instance.isSuccess] as? Bool {
                
                self.dismiss(animated: true) {
                    if let message:String = response[Contants.Instance.message] as? String {
                        self.showNotification(title: "Notice", message: message)
                    }
                }
            } else {
                self.hostUser = User(response)
                self.dismiss(animated: true) {
                    self.performSegue(withIdentifier: Contants.Instance.segueWaiting, sender: nil)
                }
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.rooms.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.rooms[section].count
    }

    //Draw room on interface (each cell)
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Contants.Instance.cellRoom, for: indexPath) as! RoomCell

        //cell properties
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.lightText.cgColor
        cell.layer.borderWidth = 5
        cell.contentView.backgroundColor = UIColor.init(Hex: 0xd4ded7)
        
        if rooms.count > 0 {
            //Get room name
            if let room_name:String = self.rooms[indexPath.section][indexPath.row].roomName {
                cell.lblRoomName.text = room_name
            }
            //Get money bet
            if let money:Double = self.rooms[indexPath.section][indexPath.row].moneyBet {
                cell.lblMoney.text = "$\(Int(money))"
            } else {
                cell.lblMoney.text = "$0"
            }

            //state image
            if let roomState:String = self.rooms[indexPath.section][indexPath.row].roomState {
                bindImage(imgView: cell.imgAvatar, state: roomState)
            }
        
        }
        
        return cell
    }
    
    //MARK: - Roload page manager
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let index:Int = indexPath.row
        let section:Int = indexPath.section
        
        if self.isEmit {
            //Kick flag, make collectionView can reload data
            if index >= 9 && self.pageNeedReload == section + 1 && self.pageNeedReload < self.totalPage {
                self.pageNeedReload += 1
                ListenRoomEvent.Instance.setPageNeedReload(self.pageNeedReload)
                self.isEmit = false
                
            }
        }
        
        if index <= 0 && self.pageNeedReload > 0 {
            self.pageNeedReload = section + 1
            ListenRoomEvent.Instance.setPageNeedReload(self.pageNeedReload)
        }
        
        //print(pageNeedReload, " ===> ", self.isEmit)
        
        if !isEmit { //Get data if receive permission from code above (isEmiting)
            self.isEmit = true
            SocketIOManager.Instance.socketEmit(Commands.Instance.ClientGetRoomByPage, [Contants.Instance.page: pageNeedReload])
            
        }
        
    }
    
    //MARK:- Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Contants.Instance.segueWaiting {
            
            if let waitingRoom:WaitingViewController = segue.destination as? WaitingViewController {
                //transfer room infor to next screen using prepare for segue function
                waitingRoom.thisRoom = self.nextRoom
                waitingRoom.isHost = self.isHost
                waitingRoom.otherUser = self.hostUser
            }
            
        }
    }
    
    //MARK: - Join room task
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Start indicator waiting
        self.waitingIndicator(with: self.indicator)
        
        //Check money before join room
        if let coin:Int = MyProfile.Instance.coin_card {
            let moneyBet:Int = Int(rooms[indexPath.section][indexPath.row].moneyBet ?? 0)
            if coin < moneyBet {
                self.dismiss(animated: true, completion: { 
                    self.showNotification(title: "Notice!", message: "You don't enough coins to join this room!")
                })
                return
            }
        }
        
        //Emit to server
        if let uid:String = MyProfile.Instance.uid {
            SocketIOManager.Instance.socketEmit(Commands.Instance.ClientJoinRoom, [Contants.Instance.room_id: rooms[indexPath.section][indexPath.row].id!, Contants.Instance.uid: uid])
        }
        //Get next room infor
        self.nextRoom = rooms[indexPath.section][indexPath.row]
        self.isHost = false
        
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
        txtRoomName.standardTextField(borderColor: UIColor.red.cgColor, placeHolder: "Room name")
        subview.addSubview(txtRoomName)
        
        // Add textfield for bet
        let txtMoneyBet = UITextField(frame: CGRect(x: x,y: txtRoomName.frame.maxY + 10,width: 200,height: 30))
        txtMoneyBet.standardTextField(borderColor: UIColor.yellow.cgColor, placeHolder: "Money bet")
        txtMoneyBet.keyboardType = UIKeyboardType.numberPad
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
                    //get infor of next room
                    self.nextRoom.roomName = roomName
                    self.nextRoom.moneyBet = money_bet
                    self.isHost = true
                    //Init json data to push to server
                    if let uid:String = MyProfile.Instance.uid {
                        let jsonData:Dictionary<String, Any> = [Contants.Instance.room_name: roomName, Contants.Instance.money_bet: money_bet, Contants.Instance.host_uid: uid]
                        //Emit to server
                        if let coin:Int = MyProfile.Instance.coin_card {
                            if Int(money_bet) > coin {
                                self.dismiss(animated: true, completion: { 
                                    self.showNotification(title: "Notice!", message: "Your coins did not enough for bet!")
                                })
                            } else {
                                SocketIOManager.Instance.socketEmit(Commands.Instance.ClientCreateRoom, jsonData)
                            }
                        }
                    }
                    
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
