//
//  Feed+CoreDataProperties.swift
//  HomeMonitor
//
//  Created by Mark Lee Malmose on 08/10/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Feed {

    @NSManaged var lux: String?
    @NSManaged var entry_id: NSNumber?
    @NSManaged var created_at: String?
    @NSManaged var battery: String?
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, lux: String, entry_id: NSNumber, created_at: String, battery: String) -> Feed {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Feed", inManagedObjectContext: moc) as! Feed
        newItem.lux = lux
        newItem.entry_id = entry_id
        newItem.created_at = created_at
        newItem.battery = battery
        
        return newItem
    }

}
