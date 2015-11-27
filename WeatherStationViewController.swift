//
//  WeatherStationViewController.swift
//  HomeMonitor
//
//  Created by Mark Lee Malmose on 23/10/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//

import UIKit

class WeatherStationViewController: UIViewController {
    var newHttpRequest = HttpRequestJson()

    @IBOutlet weak var thermometerLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var winddirectionLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get window status from thingspeak
        newHttpRequest.HTTPGetJSON("https://api.thingspeak.com/channels/61952/feeds/last.json?api_key=ZBM1FGNSLEIZ4GSL") {
            (data: Dictionary<String, AnyObject>, error: String?) -> Void in
            if error != nil {
                print(error)
            } else {
                
                var windDirectionFormatted: String = ""

                let temperature = (data["field3"] as? String)!
                let humidity = (data["field4"] as? String)!
                let windDirection = (data["field2"] as? String)!
                let windSpeed = (data["field1"] as? String)!
                
                let WindDirectionInt:Int = Int(windDirection)!
                
                switch WindDirectionInt {
                case 0..<23:
                    windDirectionFormatted = "N"
                    
                case 23..<68:
                    windDirectionFormatted = "NE"
                    
                case 68..<158:
                    windDirectionFormatted = "SE"
                    
                case 158..<203:
                    windDirectionFormatted = "S"
                    
                case 203..<247:
                    windDirectionFormatted = "SW"
                    
                case 247..<292:
                    windDirectionFormatted = "W"
                    
                    
                case 292..<337:
                    windDirectionFormatted = "NW"
                    
                    
                case 337..<360:
                    windDirectionFormatted = "N"
                    
                default:
                    print("Error in formatting wind direction")
                    
                }

                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if let formatTemp:Float = Float(temperature)!{
                        let roundedTemp:String = String(Int(formatTemp))
                        print("temp \(roundedTemp)")
                        self.thermometerLabel.text = roundedTemp
                    }
                    
                    if let formatHum:Float = Float(humidity)!{
                        let roundedHum:String = String(Int(formatHum))
                        self.humidityLabel.text = roundedHum
                    }
                    
                    if let formatDir:Float = Float(windDirection)!{
                        let roundedDir:String = String(Int(formatDir))
                        self.winddirectionLabel.text = roundedDir
                    }
                    
                    if let formatSpeed:Float = Float(windSpeed)!{
                        let roundedSpeed:String = String(Int(formatSpeed))
                        self.windspeedLabel.text = roundedSpeed
                    }
                    
                    self.winddirectionLabel.text = windDirectionFormatted
                    
                })
                
                
                               
            }
        }
        
    } // END ViewDidLoad
    
}
