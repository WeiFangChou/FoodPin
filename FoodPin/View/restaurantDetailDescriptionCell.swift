//
//  restaurantDetailDescriptionCell.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/4/26.
//

import UIKit

class restaurantDetailDescriptionCell: UITableViewCell {

    @IBOutlet var restaurantDetailDescriptionImage: UIImageView!
    @IBOutlet var restaurantDetailDescriptionLabel: UILabel!{
        didSet{
            restaurantDetailDescriptionLabel.numberOfLines = 0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
