//
//  AboutTableViewCell.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/5/1.
//

import UIKit

class AboutTableViewCell: UITableViewCell {
    @IBOutlet var aboutImage: UIImageView!
    @IBOutlet var aboutLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
