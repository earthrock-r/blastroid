//
//  LeaderCell.swift
//  Blastroid
//
//  Created by Ranjith R D on 20/04/18.
//  Copyright © 2018 Ranjith R Dixit. All rights reserved.
//

import UIKit

class LeaderCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
