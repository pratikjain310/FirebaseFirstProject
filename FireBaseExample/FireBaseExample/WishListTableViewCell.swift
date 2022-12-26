//
//  WishListTableViewCell.swift
//  FireBaseExample
//
//  Created by ashutosh deshpande on 13/12/2022.
//

import UIKit

class WishListTableViewCell: UITableViewCell {

    @IBOutlet weak var wishListImageView: UIImageView!
    @IBOutlet weak var wishListLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
