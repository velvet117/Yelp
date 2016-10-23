//
//  DealTableViewCell.swift
//  Yelp
//
//  Created by Anastasia Blodgett on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DealTableViewCellDelegate {
    @objc optional func dealSwitchValueChanged(dealCell: DealTableViewCell, didChangeValue value:Bool)
}

class DealTableViewCell: UITableViewCell {
    @IBOutlet weak var dealLabel: UILabel!
    @IBOutlet weak var dealSwitch: UISwitch!

    weak var delegate: DealTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dealSwitch.addTarget(self, action: #selector(DealTableViewCell.dealSwitchValueChanged), for: UIControlEvents.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dealSwitchValueChanged() {
        delegate?.dealSwitchValueChanged?(dealCell: self, didChangeValue: dealSwitch.isOn)
    }

}
