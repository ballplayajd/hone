//
//  WaypointTableCell.swift
//  Hone
//
//  Created by Joey Donino on 11/29/15.
//  Copyright © 2015 Joey Donino. All rights reserved.
//

import UIKit

class WaypointTableCell: UITableViewCell{
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        title.font = UIFont.systemFontOfSize(24)
        coordinates.font = UIFont.systemFontOfSize(8)
     
    }
    
    @IBOutlet weak var coordinates: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
  
    
    var wayObject: WayPoint?
    @IBOutlet weak var honeInButton: UIButton!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    
    
    
    
    
    
}
