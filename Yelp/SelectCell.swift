//
//  SelectCell.swift
//  Yelp
//
//  Created by SGLMR on 23/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class SelectCell: UITableViewCell {

    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
