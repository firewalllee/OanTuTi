//
//  RoomTableViewCell.swift
//  OanTuTi
//
//  Created by Lee Nguyen on 10/27/16.
//  Copyright © 2016 Lee Nguyen. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var roomIDLabel: UILabel!
    @IBOutlet weak var statusRoom: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
