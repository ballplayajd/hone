//
//  ExploreTableViewCell.swift
//  Hone
//
//  Created by Joey Donino on 12/12/15.
//  Copyright © 2015 Joey Donino. All rights reserved.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
