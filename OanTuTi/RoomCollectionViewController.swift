//
//  RoomCollectionViewController.swift
//  OanTuTi
//
//  Created by Phuc on 11/7/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

let reuseIdentifier:String = Contants.Instance.cellRoom
fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

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
        
//        //Listen event page from server
//        SocketIOManager.Instance.socket.on(Commands.Instance.ClientGetFirstRoomPage) { (data, ack) in
//            if let response:Dictionary<String, Any> = data[0] as? Dictionary<String, Any> {
//                print(response)
//            }
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.view.rotateXAxis()
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 15
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Contants.Instance.cellRoom, for: indexPath)
    
        if let lblRoom: UILabel = cell.viewWithTag(1) as? UILabel {
            lblRoom.text = "Room \(indexPath.row)"
        }
        
        if let lblBet:UILabel = cell.viewWithTag(3) as? UILabel {
            lblBet.text = "$\(indexPath.row/5) 00"
        }
        
        //state image
        let index:Int = Int(indexPath.row % 3)
        if index == 0{
            if let imgView:UIImageView = cell.viewWithTag(2) as? UIImageView {
                imgView.image = UIImage(named: "1people")
            }
        } else if index == 1{
            if let imgView:UIImageView = cell.viewWithTag(2) as? UIImageView {
                imgView.image = UIImage(named: "2people")
            }
        } else {
            if let imgView:UIImageView = cell.viewWithTag(2) as? UIImageView {
                imgView.image = UIImage(named: "2peoplePlaying")
                imgView.tintColor = UIColor.green
            }
        }
        
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.lightText.cgColor
        cell.layer.borderWidth = 5
        
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
