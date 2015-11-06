//
//  WeatherFeed+CoreDataProperties.swift
//  HomeMonitor
//
//  Created by Mark Lee Malmose on 26/10/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WeatherFeed {

    @NSManaged var wind_speed: String?
    @NSManaged var wind_direction: String?
    @NSManaged var temperature: String?
    @NSManaged var humidity: String?
    @NSManaged var created_at: String?
    @NSManaged var entry_id: NSNumber?
    
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext,
        wind_speed: String,
        entry_id: NSNumber,
        created_at: String,
        wind_direction: String,
        temperature: String,
        humidity: String) -> WeatherFeed {
            
            let newItem = NSEntityDescription.insertNewObjectForEntityForName("WeatherFeed", inManagedObjectContext: moc) as! WeatherFeed
            
            newItem.wind_speed = wind_speed
            newItem.entry_id = entry_id
            newItem.created_at = created_at
            newItem.wind_direction = wind_direction
            newItem.temperature = temperature
            newItem.humidity = humidity
        
            return newItem
    }


}
