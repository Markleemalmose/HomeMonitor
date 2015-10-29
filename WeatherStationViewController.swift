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
//    var temperatureCelsius = ""
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var winddirectionLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

       // ViewControllerUtils().showActivityIndicator(self.view)
        
        // Get window status from thingspeak
        newHttpRequest.HTTPGetJSON("https://api.thingspeak.com/channels/61952/feeds/last.json?api_key=ZBM1FGNSLEIZ4GSL") {
            (data: Dictionary<String, AnyObject>, error: String?) -> Void in
            if error != nil {
                print(error)
            } else {
                
                let temperature = (data["field3"] as? String)!
                let humidity = (data["field4"] as? String)!
                let windDirection = (data["field2"] as? String)!
                let windSpeed = (data["field1"] as? String)!
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if let formatTemp:Float = Float(temperature)!{
                        let roundedTemp:String = String(Int(formatTemp))
                        self.temperatureLabel.text = roundedTemp
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
                    
                    
                    
                    
                })
               
            }
        }
        //print("Temp \(self.temperature)")
        
        
        
        
        
        
        
        //        dispatch_async(dispatch_get_main_queue(), {
//        self.temperatureLabel.text = self.temperature
        //        })
        
        
        
        
    } // END ViewDidLoad

    func updateTemperatureLabel(temperature: String){
        temperatureLabel.text = temperature
        print(temperature)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
