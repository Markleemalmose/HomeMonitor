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

    @NSManaged var entry_id: NSNumber?
    @NSManaged var created_at: String?
    @NSManaged var luxInside: String?
    @NSManaged var luxOutside: String?
    @NSManaged var temperature: String?
    @NSManaged var humidity: String?
    
    class func createInManagedObjectContext(
        moc: NSManagedObjectContext,
        entry_id: NSNumber,
        created_at: String,
        luxInside: String,
        luxOutside: String,
        temperature: String,
        humidity: String
        ) -> Feed {
            let newItem = NSEntityDescription.insertNewObjectForEntityForName("Feed", inManagedObjectContext: moc) as! Feed
        
            newItem.entry_id = entry_id
            newItem.created_at = created_at
            newItem.luxInside = luxInside
            newItem.luxOutside = luxOutside
            newItem.temperature = temperature
            newItem.humidity = humidity
                    
        return newItem
    }

}
