//
//  WayPoint.swift
//  Hone
//
//  Created by Joey Donino on 6/18/15.
//  Copyright (c) 2015 Joey Donino. All rights reserved.
//

import Foundation
import CoreData
@objc(WayPoint)
class WayPoint: NSManagedObject {

    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var title: String
    @NSManaged var created: NSDate
    @NSManaged var fromMap: NSNumber

}
