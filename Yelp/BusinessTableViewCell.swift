//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Anastasia Blodgett on 10/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewsNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeOfFoodLabel: UILabel!
    
    var business: Business! {
        didSet {
            restaurantNameLabel.text = business.name
            
            ratingsImageView.setImageWith(business.ratingImageURL!)
            distanceLabel.text = business.distance
            
            addressLabel.text = business.address
            typeOfFoodLabel.text = business.categories
            
            if let thumbImageURL = business.imageURL {
                thumbImageView.setImageWith(thumbImageURL)
            }
            
            if let reviewNumber = business.reviewCount {
                reviewsNumberLabel.text = "\(reviewNumber) Reviews"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
