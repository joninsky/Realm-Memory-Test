//
//  DogCell.swift
//  Memory
//
//  Created by Jon Vogel on 11/23/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    
    @IBOutlet var friendName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
