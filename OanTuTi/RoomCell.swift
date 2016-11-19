//
//  RoomCell.swift
//  OanTuTi
//
//  Created by Phuc on 11/19/16.
//  Copyright © 2016 Phuc. All rights reserved.
//

import UIKit

class RoomCell: UICollectionViewCell {
    
    @IBOutlet weak var lblRoomName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblMoney: UILabel!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
    
}
