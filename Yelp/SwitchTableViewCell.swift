//
//  SwitchTableViewCell.swift
//  Yelp
//
//  Created by Anastasia Blodgett on 10/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchTableViewCellDelegate {
    @objc optional func switchCell(switchCell: SwitchTableViewCell, didChangeValue value:Bool)
}

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!
    weak var delegate: SwitchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        filterSwitch.addTarget(self, action: #selector(SwitchTableViewCell.switchValueChanged), for: UIControlEvents.valueChanged)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged() {
        delegate?.switchCell?(switchCell: self, didChangeValue: filterSwitch.isOn)
    }

}
