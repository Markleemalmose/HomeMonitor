//
//  ViewController.swift
//  HomeMonitor
//
//  Created by Mark Lee Malmose on 29/09/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController {

    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var newHttpRequest = HttpRequestJson()
    var feed: Feed!
    var dataRecordsFeed = [Feed]()
    var lastEntryIdRoom = 0
    var lastEntryIdWeather = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true;
        
        // Use optional binding to confirm the managedObjectContext
        
        
        
        // Start Room Thingspeak
        lastEntryIdRoom = getLastEntryId("Feed")
        print("Last room entry id \(lastEntryIdRoom)")
        
        let mocFeed = self.managedObjectContext
        var roomDataThingspeakCount = 0
        newHttpRequest.HTTPGetJSON("https://api.thingspeak.com/channels/56570/feeds.json?api_key=0PODIGLG2371U0B3?results=2541") {
            (data: Dictionary<String, AnyObject>, error: String?) -> Void in
            if error != nil {
                print(error)
            } else {
                
                print("Getting data from Thingspeak Room channel...")
                
                if let feeds = data["feeds"] as? NSArray{
                    for elem: AnyObject in feeds{
                        
                        if let
                            entry_id        = elem as? NSDictionary,
                            entry_idValue   = entry_id["entry_id"] as? Int{
                                
                                if entry_idValue > self.lastEntryIdRoom {
                                    ++roomDataThingspeakCount
                                    
                                    if let
                                        created_at          = elem as? NSDictionary,
                                        created_at_stamp    = created_at["created_at"] as? String{
                                            //                                  print(created_at_stamp)
                                            
                                        if let
                                            roomTemperature        = elem as? NSDictionary,
                                            roomTemperatureValue   = roomTemperature["field4"] as? String{
                                               
                                            if let
                                                roomHumidity        = elem as? NSDictionary,
                                                roomHumidityValue   = roomHumidity["field5"] as? String{
                                                            
                                                if let
                                                    luxOutside        = elem as? NSDictionary,
                                                    luxOutsideValue   = luxOutside["field6"] as? String{
                                                                    
                                                    if let
                                                        luxInside        = elem as? NSDictionary,
                                                        luxInsideValue   = luxInside["field7"] as? String{
                                                        
                                                        Feed.createInManagedObjectContext(mocFeed,
                                                            
                                                            entry_id:       entry_idValue,
                                                            created_at:     created_at_stamp,
                                                            luxInside:      luxInsideValue,
                                                            luxOutside:     luxOutsideValue,
                                                            temperature:    roomTemperatureValue,
                                                            humidity:       roomHumidityValue)
                                                                            
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                        
                        do {
                            
                            try self.managedObjectContext.save()
                            
                        } catch {
                            print("Error in saving to database")
                        }
                    }
                }
            }
            print("Done - Getting data from Thingspeak Room channel...")
            print("Got \(roomDataThingspeakCount) json objects from Thingspeak Room channel")
            roomDataThingspeakCount = 0

        } // End Room Thingspeak
        
        
        
        // Start Weatherstation thingspeak
        
        lastEntryIdWeather = getLastEntryId("WeatherFeed")
        print("Last weather entry id \(lastEntryIdWeather)")

        
        let mocWeather = self.managedObjectContext
        var weatherDataThingspeakCount = 0
        newHttpRequest.HTTPGetJSON("https://api.thingspeak.com/channels/61952/feeds.json?api_key=ZBM1FGNSLEIZ4GSL?results=2541") {
            (data: Dictionary<String, AnyObject>, error: String?) -> Void in
            if error != nil {
                print(error)
            } else {
                
                print("Getting data from Thingspeak Weatherstation channel...")
                //              print("lastEntryId:  \(self.lastEntryId)")
                
                if let feeds = data["feeds"] as? NSArray{
                    for elem: AnyObject in feeds{
                        
                        if let
                            entry_id        = elem as? NSDictionary,
                            entry_idValue   = entry_id["entry_id"] as? Int{
                                
                            if entry_idValue > self.lastEntryIdWeather {
                                ++weatherDataThingspeakCount
                                //                          print("entry_idValue:  \(entry_idValue)")
                                //                          print("lastEntryId:  \(self.lastEntryId)")
                                    
                                if let
                                    created_at          = elem as? NSDictionary,
                                    created_at_stamp    = created_at["created_at"] as? String{
                                            //                              print(created_at_stamp)
                                        
                                    if let
                                        windspeed       = elem as? NSDictionary,
                                        windspeedValue  = windspeed["field1"] as? String{
                                        //                                 print(windspeedValue)
                                                    
                                        if let
                                            winddirection       = elem as? NSDictionary,
                                            winddirectionValue  = winddirection["field2"] as? String{
                                                            //                                      print(winddirectionValue)
                                                            
                                            if let
                                                temperature         = elem as? NSDictionary,
                                                temperatureValue    = temperature["field3"] as? String{
                                                                    //                                          print(temperatureValue)
                                                                    
                                                    if let
                                                        humidity = elem as? NSDictionary ,
                                                        humidityValue = humidity["field4"] as? String{
                                //                                              print(humidityValue)
                                                                            //                                              print("\n")
                                                                            
                                                            WeatherFeed.createInManagedObjectContext(
                                                                mocWeather,
                                                                wind_speed: windspeedValue,
                                                                entry_id: entry_idValue,
                                                                created_at: created_at_stamp,
                                                                wind_direction: winddirectionValue,
                                                                temperature: temperatureValue,
                                                                humidity: humidityValue)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                        
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print("Error in saving to database")
                            }
                        }
                    }
                //ViewControllerUtils().hideActivityIndicator(self.view)
                }
                print("Done - Getting data from Thingspeak Weatherstation channel...")
                print("Got \(weatherDataThingspeakCount) json objects from Thingspeak Weather channel")
                weatherDataThingspeakCount = 0
            } // End of HTTP request
    }
}

