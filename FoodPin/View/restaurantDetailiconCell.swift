//
//  restaurantDetailPhoneCell.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/4/26.
//

import UIKit

class restaurantDetailiconCell: UITableViewCell {


    @IBOutlet var restaurantIconImage: UIImageView!
    @IBOutlet var restaurantLabel: UILabel!{
        didSet{
            restaurantLabel.numberOfLines = 0
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }

}
