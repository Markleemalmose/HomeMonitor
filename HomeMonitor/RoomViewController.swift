//
//  RoomViewController.swift
//  HomeMonitor
//
//  Created by Mark Lee Malmose on 06/10/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {
    
    var newHttpRequest = HttpRequestJson()

    @IBOutlet weak var roomImageView: UIImageView!
    
    @IBOutlet weak var thermImageView: UIImageView!
    @IBOutlet weak var thermDataLabel: UILabel!
    @IBOutlet weak var thermDegreeLabel: UILabel!
    @IBOutlet weak var humImageView: UIImageView!
    @IBOutlet weak var humDataLabel: UILabel!
    @IBOutlet weak var humPercentLabel: UILabel!
    @IBOutlet weak var luxLuxLabel: UILabel!
    @IBOutlet weak var luxDataLabel: UILabel!
    @IBOutlet weak var luxImageView: UIImageView!
    
    let image000 : UIImage = UIImage(named:"x232_map_iphone")!
    let image001 : UIImage = UIImage(named:"x232_map_iphone_door")!
    let image010 : UIImage = UIImage(named:"x232_map_iphone_window_1")!
    let image011 : UIImage = UIImage(named:"x232_map_iphone_window_1_door")!
    let image100 : UIImage = UIImage(named:"x232_map_iphone_window_2")!
    let image101: UIImage = UIImage(named:"x232_map_iphone_window_2_door")!
    let image110 : UIImage = UIImage(named:"x232_map_iphone_window_1and2")!
    let image111 : UIImage = UIImage(named:"x232_map_iphone_window_1and2_door")!
    
    var windowRight : String = ""
    var windowLeft : String = ""
    var door : String = ""
    var windowsDoorStatus : String = ""
    
    var temperature : String = ""
    var humidity : String = ""
    var light : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewControllerUtils().showActivityIndicator(self.view)
        
        // Get window status from thingspeak
        newHttpRequest.HTTPGetJSON("https://api.thingspeak.com/channels/56570/feeds/last.json?api_key=0PODIGLG2371U0B3") {
            (data: Dictionary<String, AnyObject>, error: String?) -> Void in
            if error != nil {
                print(error)
            } else {
                
                // Get latest data from thingspeak room channel
                self.windowRight = (data["field1"] as? String)!
                self.windowLeft = (data["field2"] as? String)!
                self.door = (data["field3"] as? String)!
                self.humidity = (data["field5"] as? String)!
                self.light = (data["field7"] as? String)!
                self.temperature = (data["field4"] as? String)!
                
                print("door \(self.door)")
                
                self.windowsDoorStatus = self.windowLeft
                self.windowsDoorStatus += self.windowRight
                self.windowsDoorStatus += self.door
                
                
                self.SetRoomImageView(self.windowsDoorStatus)
                
                // Set values to labels
                dispatch_async(dispatch_get_main_queue(), {
                    self.thermDataLabel.text = self.temperature
                    self.humDataLabel.text = self.humidity
                    self.luxDataLabel.text = self.light
                })
                
                ViewControllerUtils().hideActivityIndicator(self.view)
            }
        }
    }

    func SetRoomImageView(windowStatus: String) {
        
        print(self.windowsDoorStatus)
        
        switch windowStatus {
        case "000":
            print("Both windows and door closed")
            dispatch_async(dispatch_get_main_queue(), {
                self.roomImageView.image = self.image000
                self.view.addSubview(self.roomImageView)
            })
            
        case "001":
            print("Both windows closed and door open")
            dispatch_async(dispatch_get_main_queue(), {
                self.roomImageView.image = self.image001
                self.view.addSubview(self.roomImageView)
            })
            
        case "010":
            print("window right open and door closed")
            dispatch_async(dispatch_get_main_queue(), {
                self.roomImageView.image = self.image010
                self.view.addSubview(self.roomImageView)
            })
            
        case "011":
            print("Window right open and door open")
            dispatch_async(dispatch_get_main_queue(), {
                self.roomImageView.image = self.image011
                self.view.addSubview(self.roomImageView)
            })
        
        case "100":
            print("Window left open and door closed")
            dispatch_async(dispatch_get_main_queue(), {
                self.roomImageView.image = self.image100
                self.view.addSubview(self.roomImageView)
            })
            
        case "101":
            print("Window left open and door open")
            dispatch_async(dispatch_get_main_queue(), {
                self.roomImageView.image = self.image101
                self.view.addSubview(self.roomImageView)
            })
            
        case "110":
            print("Both windows open and door closed")
            dispatch_async(dispatch_get_main_queue(), {
                self.roomImageView.image = self.image110
                self.view.addSubview(self.roomImageView)
            })
            
        case "111":
            print("Both windows open and door open")
            dispatch_async(dispatch_get_main_queue(), {
                self.roomImageView.image = self.image111
                self.view.addSubview(self.roomImageView)
            })
            
        default:
            print("Error in windows")
            
        }
        
        // Set the temperature and humidity labels, and views after room image is set
        dispatch_async(dispatch_get_main_queue(), {
            self.view.addSubview(self.thermImageView)
            self.view.addSubview(self.thermDataLabel)
            self.view.addSubview(self.thermDegreeLabel)
            self.view.addSubview(self.humImageView)
            self.view.addSubview(self.humDataLabel)
            self.view.addSubview(self.humPercentLabel)
            self.view.addSubview(self.luxImageView)
            self.view.addSubview(self.luxDataLabel)
            self.view.addSubview(self.luxLuxLabel)
        })
    }

}
