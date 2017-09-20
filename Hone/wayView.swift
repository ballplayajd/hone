//
//  wayView.swift
//  Hone
//
//  Created by Joey Donino on 6/14/15.
//  Copyright (c) 2015 Joey Donino. All rights reserved.
//

import UIKit
import MapKit

class wayView: UIView {

    var contentsLabel: UILabel!
    var subLabel: UILabel!
    var honeButton: UIButton!
    var contentsTextfield: UITextField!
    var mapItem: MKPlacemark?
    var WayOb: WayPoint?
    var ismap: Bool?
    var title: String?
    
    
required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    }

    
   override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor=UIColor(white: 1.0, alpha: 1.0)
    let contentFrame=CGRectMake(bounds.origin.x+8, bounds.origin.y, 5 * bounds.width/6, 2*bounds.height/3)
    contentsLabel=UILabel(frame: contentFrame)
    contentsLabel.font=UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    contentsLabel.font=UIFont.systemFontOfSize(30.0)
    //addSubview(contentsLabel)
    contentsTextfield = UITextField(frame: contentFrame)
    contentsTextfield.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    contentsTextfield.font = UIFont.systemFontOfSize(30.0)
    addSubview(contentsTextfield)

    
    let subContentFrame=CGRectMake(bounds.origin.x+8, bounds.origin.y+2*bounds.height/3, bounds.width-16, bounds.height/3)
    subLabel=UILabel(frame: subContentFrame)
    subLabel.font=UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    subLabel.font=UIFont.systemFontOfSize(10)
    subLabel.textColor=UIColor.blueColor()
    addSubview(subLabel)
    
    let honeFrame=CGRectMake(bounds.origin.x + 5 * bounds.width/6 + 8, bounds.origin.y, bounds.width/5-16, 2*bounds.height/3)
    honeButton=UIButton(frame: honeFrame)
    let image=UIImage(named: "arrow.png")
    honeButton.setImage(image, forState: .Normal)
    honeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/4))
    //honeButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
    
    addSubview(honeButton)
    let bottomBorder = CALayer()
    bottomBorder.frame = CGRectMake(0, self.frame.height, self.frame.width, CGFloat(0.5))
    bottomBorder.backgroundColor = UIColor.blackColor().CGColor
    self.layer .addSublayer(bottomBorder)
    
    
    //self.backgroundColor = UIColor.groupTableViewBackgroundColor()


    }
    
    
    
    
}
