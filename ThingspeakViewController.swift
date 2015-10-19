//
//  ThingspeakViewController.swift
//  HomeMonitor
//
//  CFNetwork SSLHandshake failed (-9824) error solved by:
//  http://stackoverflow.com/questions/30739473/nsurlsession-nsurlconnection-http-load-failed-on-ios-9/30748166#30748166
//
//
//  http://stackoverflow.com/questions/26613971/coredata-warning-unable-to-load-class-named
//
//  Created by Mark Lee Malmose on 04/10/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ThingspeakViewController: UIViewController {
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var newHttpRequest = HttpRequestJson()
    var feed: Feed!
    var lastEntryId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new fetch request using the Feed entity
        let fetchRequest = NSFetchRequest(entityName: "Feed")
        
        // Fetch only one record
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "entry_id", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        
        do {
            
            let fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            let lastEntry = fetchResults[0] as! NSManagedObject
            
            lastEntryId = lastEntry.valueForKey("entry_id") as! Int
            
            print("Last entry: \(lastEntryId)")
            
        } catch {
            
            print("Could not fetch")
        }
        
        
        
        // Print it to the console
        print(managedObjectContext)
        
        //ViewControllerUtils().showActivityIndicator(self.view)
        // Use optional binding to confirm the managedObjectContext
        let moc = self.managedObjectContext
        
        newHttpRequest.HTTPGetJSON("https://api.thingspeak.com/channels/56570/feeds.json?api_key=0PODIGLG2371U0B3") {
            (data: Dictionary<String, AnyObject>, error: String?) -> Void in
            if error != nil {
                print(error)
            } else {
                
                print("HTTP request GET")
                
                if let feeds = data["feeds"] as? NSArray{
                    for elem: AnyObject in feeds{
                        
                        if let entry_id = elem as? NSDictionary ,
                            let entry_idValue = entry_id["entry_id"] as? Int{
                            
                                if entry_idValue > self.lastEntryId {
                                
                            print(entry_idValue)

                        
                            if let created_at = elem as? NSDictionary ,
                                let created_at_stamp = created_at["created_at"] as? String{
                                print(created_at_stamp)
                       
                                    if let solarCellBattery = elem as? NSDictionary ,
                                        let solarCellBatteryValue = solarCellBattery["field6"] as? String{
                                        print(solarCellBatteryValue)
                                        
                                        if let lux = elem as? NSDictionary ,
                                            let luxValue = lux["field7"] as? String{
                                            print(luxValue)
                                            print("\n")

                                            Feed.createInManagedObjectContext(moc, lux: luxValue, entry_id: entry_idValue, created_at: created_at_stamp, battery: solarCellBatteryValue)
                                                }
                                        }
                                        
                                }
                                }
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            // Do something in response to error condition
                            print("Error in saving to database")
                        }
                        
                    }
                    
                }
            //ViewControllerUtils().hideActivityIndicator(self.view)
            }
            
            
        }
        
        
        //sleep(5)
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        // Create a new fetch request using the Feed entity
//        let fetchRequest = NSFetchRequest(entityName: "Feed")
//        
//        
//        do {
//            let fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Feed]
//            // Do something with fetchedEntities
//            
//            // Create an Alert, and set it's message
//            let alert = UIAlertController(title: fetchResults[0].created_at,
//                message: fetchResults[0].lux,
//                preferredStyle: .Alert)
//            
//            // Display the alert
//            self.presentViewController(alert,
//                animated: true,
//                completion: nil)
//            
//        } catch {
//            // Do something in response to error condition
//        }
//    
//        
//
//}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Save data to database
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
