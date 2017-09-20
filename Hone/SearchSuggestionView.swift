//
//  SearchSuggestionView.swift
//  Hone
//
//  Created by Joey Donino on 6/10/15.
//  Copyright (c) 2015 Joey Donino. All rights reserved.
//
import MapKit
import UIKit

class SearchSuggestionView: UIView {
    var contentsLabel: UILabel!
    var subLabel: UILabel!
    var mapItem: MKMapItem?
    var distanceLabel: UILabel!
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let contentFrame=CGRectMake(bounds.origin.x+8, bounds.origin.y, bounds.width-16, bounds.height)
        contentsLabel=UILabel(frame: contentFrame)
        contentsLabel.font=UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        addSubview(contentsLabel)
        let subContentFrame=CGRectMake(bounds.origin.x+8, bounds.origin.y+2*bounds.height/3, bounds.width-16, bounds.height/3)
        subLabel=UILabel(frame: subContentFrame)
        subLabel.font=UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        subLabel.font=UIFont.systemFontOfSize(10)
        addSubview(subLabel)
        
        let distContentFrame=CGRectMake(bounds.origin.x+contentFrame.width+8, bounds.origin.y, bounds.width-contentFrame.width-8, 2*bounds.height/3)
        distanceLabel=UILabel(frame: distContentFrame)
        distanceLabel.font=UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        distanceLabel.textColor=UIColor.blueColor()
        addSubview(distanceLabel)

    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor(white: 1.0, alpha: 1.0)
        let contentFrame=CGRectMake(bounds.origin.x+8, bounds.origin.y, bounds.width-64, 2*bounds.height/3)
        contentsLabel=UILabel(frame: contentFrame)
        contentsLabel.font=UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        addSubview(contentsLabel)
        let subContentFrame=CGRectMake(bounds.origin.x+8, bounds.origin.y+2*bounds.height/3, bounds.width-16, bounds.height/3)
        subLabel=UILabel(frame: subContentFrame)
        subLabel.font=UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        subLabel.font=UIFont.systemFontOfSize(10)
        addSubview(subLabel)
    
        let distContentFrame=CGRectMake(bounds.origin.x+contentFrame.width+8, bounds.origin.y, bounds.width-contentFrame.width-8, 2*bounds.height/3)
        distanceLabel=UILabel(frame: distContentFrame)
        distanceLabel.font=UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        distanceLabel.textColor=UIColor.blueColor()
        addSubview(distanceLabel)

    }
}
