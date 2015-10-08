//
//  RoomViewController.swift
//  HomeMonitor
//
//  Created by Mark Lee Malmose on 06/10/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {

    @IBOutlet weak var roomImageView: UIImageView!
    
    let image : UIImage = UIImage(named:"x232_map_iphone")!
    let imageWindowRight : UIImage = UIImage(named:"x232_map_iphone_window_1")!
    let imageWindowLeft : UIImage = UIImage(named:"x232_map_iphone_window_2")!
    let imageWindowRightAndLeft : UIImage = UIImage(named:"x232_map_iphone_window_1and2")!
    
    
    var windowRight : String = ""
    var windowLeft : String = ""
    var windowStatus : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewControllerUtils().showActivityIndicator(self.view)
        
        // Get window status from thingspeak
        HTTPGetJSON("https://api.thingspeak.com/channels/56570/feeds/last.json?api_key=0PODIGLG2371U0B3") {
            (data: Dictionary<String, AnyObject>, error: String?) -> Void in
                if error != nil {
                    print(error)
                } else {
                        
                    self.windowRight = (data["field1"] as? String)!
                    self.windowLeft = (data["field2"] as? String)!
                    
                    self.windowStatus = self.windowLeft
                    self.windowStatus += self.windowRight
                    
                    self.SetRoomImageView(self.windowStatus)
                    ViewControllerUtils().hideActivityIndicator(self.view)
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func SetRoomImageView(windowStatus: String) {
        
        //print(self.windowStatus)
        
        switch windowStatus {
        case "00":
            print("Both windows closed")
            dispatch_async(dispatch_get_main_queue(), {
                self.roomImageView.image = self.image
                self.view.addSubview(self.roomImageView)
            })
            
        case "01":
            print("window right open")
            dispatch_async(dispatch_get_main_queue(), {
                self.roomImageView.image = self.imageWindowRight
                self.view.addSubview(self.roomImageView)
            })
            
        case "10":
            print("window left open")
            dispatch_async(dispatch_get_main_queue(), {
                self.roomImageView.image = self.imageWindowLeft
                self.view.addSubview(self.roomImageView)
            })
            
        case "11":
            print("Both windows open")
            dispatch_async(dispatch_get_main_queue(), {
                self.roomImageView.image = self.imageWindowRightAndLeft
                self.view.addSubview(self.roomImageView)
            })
            
        default:
            print("Error in windows")
            
        }
    }
    
    
    // MARK: - HTTPrequest
    
    
    func JSONParseDict(jsonString:String) -> Dictionary<String, AnyObject> {
        
        if let data: NSData = jsonString.dataUsingEncoding(
            NSUTF8StringEncoding){
                
                do{
                    if let jsonObj = try NSJSONSerialization.JSONObjectWithData(
                        data,
                        options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject>{
                            return jsonObj
                    }
                }catch{
                    print("Error")
                }
        }
        return [String: AnyObject]()
    }
    
    func HTTPsendRequest(request: NSMutableURLRequest,
        callback: (String, String?) -> Void) {
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(
                request, completionHandler :
                {
                    data, response, error in
                    if error != nil {
                        callback("", (error!.localizedDescription) as String)
                    } else {
                        callback(
                            NSString(data: data!, encoding: NSUTF8StringEncoding) as! String,
                            nil
                        )
                    }
            })
            
            task.resume()
            
    }
    
    func HTTPGetJSON(
        url: String,
        callback: (Dictionary<String, AnyObject>, String?) -> Void) {
            
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            HTTPsendRequest(request) {
                (data: String, error: String?) -> Void in
                if error != nil {
                    callback(Dictionary<String, AnyObject>(), error)
                } else {
                    let jsonObj = self.JSONParseDict(data)
                    callback(jsonObj, nil)
                }
            }
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
