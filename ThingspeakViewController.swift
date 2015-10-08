//
//  ThingspeakViewController.swift
//  HomeMonitor
//
//  HTTP request from: https://medium.com/swift-programming/http-in-swift-693b3a7bf086
//
//  CFNetwork SSLHandshake failed (-9824) error solved by:
//  http://stackoverflow.com/questions/30739473/nsurlsession-nsurlconnection-http-load-failed-on-ios-9/30748166#30748166
//
//
//  Created by Mark Lee Malmose on 04/10/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//

import UIKit
import Foundation

class ThingspeakViewController: UIViewController {

    @IBOutlet weak var thingspeakView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ViewControllerUtils().showActivityIndicator(self.view)

        // Do any additional setup after loading the view.
        HTTPGetJSON("https://api.thingspeak.com/channels/56570/feeds.json?api_key=0PODIGLG2371U0B3") {
            (data: Dictionary<String, AnyObject>, error: String?) -> Void in
            if error != nil {
                print(error)
            } else {

                if let feeds = data["feeds"] as? NSArray{
                    for elem: AnyObject in feeds{
                        
                        
                        if let created_at = elem as? NSDictionary ,
                            let created_at_stamp = created_at["created_at"] as? String{
                                print(created_at_stamp)
                        }
                        
                        if let entry_id = elem as? NSDictionary ,
                            let entry_idValue = entry_id["entry_id"] as? Int{
                                print(entry_idValue)
                        }
                        
                        if let field6 = elem as? NSDictionary ,
                            let field6Value = field6["field6"] as? String{
                            print(field6Value)
                        }
                        
                        if let field7 = elem as? NSDictionary ,
                            let field7Value = field7["field7"] as? String{
                            print(field7Value)
                            print("\n")
                        }
                        
                    }
                    
                }
            //ViewControllerUtils().hideActivityIndicator(self.view)
            }
            
            
        }
        
        
        //sleep(5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
