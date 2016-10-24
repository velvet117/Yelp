//
//  ExpandedTableViewCell.swift
//  Yelp
//
//  Created by Anastasia Blodgett on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class ExpandedTableViewCell: UITableViewCell {

    @IBOutlet weak var expandedImageView: UIImageView!
    @IBOutlet weak var expandedLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
