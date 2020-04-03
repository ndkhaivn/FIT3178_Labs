//
//  SuperHeroTableViewCell.swift
//  FIT3178-Lab03
//
//  Created by Nguyễn Đình Khải on 3/4/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class SuperHeroTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
