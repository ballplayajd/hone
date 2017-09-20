//
//  MyTableViewCell.swift
//  Hone
//
//  Created by Joey Donino on 8/1/15.
//  Copyright (c) 2015 Joey Donino. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
