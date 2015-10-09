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

}
