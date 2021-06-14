//
//  ProductListTableViewCell.swift
//  ecommerceAPP
//
//  Created by Akshay  on 12/01/20.
//  Copyright © 2020 Akshay . All rights reserved.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var itemDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
