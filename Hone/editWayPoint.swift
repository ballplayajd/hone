//
//  editWayPoint.swift
//  Hone
//
//  Created by Joey Donino on 6/16/15.
//  Copyright (c) 2015 Joey Donino. All rights reserved.
//

import UIKit

class editWayPoint: UIView {
    
    var contentsLabel: UITextField!
    var doneButton: UIButton!
    var deleteButton: UIButton!
    var nameLabel: UILabel!
    var way: WayPoint?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor=UIColor.groupTableViewBackgroundColor()
        let contentFrame=CGRectMake(bounds.origin.x+8 + bounds.width/3, bounds.origin.y+8, 2*bounds.width/3 - 16, bounds.height/3)
        contentsLabel=UITextField(frame: contentFrame)
        contentsLabel.font=UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        contentsLabel.font=UIFont.systemFontOfSize(30.0)
        let paddingView = UIView(frame: CGRectMake(0, 0, 5, bounds.height/3))
        contentsLabel.leftView = paddingView
        contentsLabel.leftViewMode = UITextFieldViewMode.Always
        contentsLabel.backgroundColor=UIColor.whiteColor()
        if let wayObject = way{
            contentsLabel.placeholder = wayObject.title
        }else{
            contentsLabel.placeholder = "Title"
        }
        addSubview(contentsLabel)
        let deleteContentFrame=CGRectMake(bounds.origin.x+8, bounds.origin.y + bounds.height - 40, 64, 32)
        deleteButton=UIButton(frame: deleteContentFrame)
        deleteButton.setTitle("Delete", forState: .Normal)
        deleteButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        addSubview(deleteButton)
        let doneContentFrame=CGRectMake(bounds.origin.x+bounds.width-72, bounds.origin.y + bounds.height - 40, 64, 32)
        doneButton=UIButton(frame: doneContentFrame)
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        addSubview(doneButton)
        
    
        let nameFrame=CGRectMake(bounds.origin.x+8, bounds.origin.y+8, bounds.width/3.0 - 8, bounds.height/3)
        nameLabel=UILabel(frame: nameFrame)
        nameLabel.font=UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        nameLabel.font=UIFont.systemFontOfSize(25.0)
        nameLabel.text = "Name:"
        addSubview(nameLabel)
        
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.borderWidth = CGFloat(2.0)
        
        
    }

}
