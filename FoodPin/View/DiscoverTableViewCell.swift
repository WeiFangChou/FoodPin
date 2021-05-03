//
//  DiscoverTableViewCell.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/5/1.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {
    
    @IBOutlet var restaurantImage: UIImageView!
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantTypeLabel: UILabel!
    @IBOutlet var restaurantLocationImageView: UIImageView!
    @IBOutlet var restaurantLocationLabel: UILabel!
    @IBOutlet var restaurantPhoneImageView: UIImageView!
    @IBOutlet var restaurantphoneLabel: UILabel!
    @IBOutlet var restaurantTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
