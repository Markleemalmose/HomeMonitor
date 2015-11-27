////
////  ThingspeakViewController.swift
////  HomeMonitor
////
////  CFNetwork SSLHandshake failed (-9824) error solved by:
////  http://stackoverflow.com/questions/30739473/nsurlsession-nsurlconnection-http-load-failed-on-ios-9/30748166#30748166
////
////
////  http://stackoverflow.com/questions/26613971/coredata-warning-unable-to-load-class-named
////
////  Created by Mark Lee Malmose on 04/10/15.
////  Copyright © 2015 Mark Lee Malmose. All rights reserved.
////
//
//import UIKit
//import Foundation
//import CoreData
//import Charts
//
//class ThingspeakViewController: UIViewController, ChartViewDelegate {
//    
////    @IBOutlet weak var lineChartView: LineChartView!
//    @IBOutlet weak var graphDataLabel: UILabel!
//    
//    @IBOutlet weak var lineChartView: LineChartView!
//    @IBOutlet weak var lineChartViewBottom: LineChartView!
//    
//    // Retreive the managedObjectContext from AppDelegate
//    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//    
//    var newHttpRequest = HttpRequestJson()
//    var feed: Feed!
//    var lastEntryId: Int = 0
//    var dataRecords = [Feed]()
//    
//    var createdAtToChart: [String] = []
//    var batteryToChart: [Double] = []
//    var luxToChart: [Double] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        lineChartView.delegate = self
//        lineChartViewBottom.delegate = self
//        
//        
//        
//        // Create a new fetch request using the Feed entity
//        let fetchRequest = NSFetchRequest(entityName: "Feed")
//        
//        // Fetch only one record
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "entry_id", ascending: false)]
//        fetchRequest.fetchLimit = 1
//        
//        
//        do {
//            let fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest)
//            
//            if let lastEntry = fetchResults.first as! NSManagedObject? {
//                lastEntryId = lastEntry.valueForKey("entry_id") as! Int
//                print("Last entry: \(lastEntryId)")
//            }
//            
//        } catch {
//            
//            print("Could not fetch")
//        }
//        
//        
////        print(managedObjectContext)
//        
//        //ViewControllerUtils().showActivityIndicator(self.view)
//        // Use optional binding to confirm the managedObjectContext
//        let moc = self.managedObjectContext
//        var dataThingspeakCount = 0
//        newHttpRequest.HTTPGetJSON("https://api.thingspeak.com/channels/56570/feeds.json?api_key=0PODIGLG2371U0B3?results=2541") {
//            (data: Dictionary<String, AnyObject>, error: String?) -> Void in
//            if error != nil {
//                print(error)
//            } else {
//                
//                print("Getting data from Thingspeak Room channel...")
//                
//                if let feeds = data["feeds"] as? NSArray{
//                    for elem: AnyObject in feeds{
//                        
//                        if let
//                            entry_id        = elem as? NSDictionary,
//                            entry_idValue   = entry_id["entry_id"] as? Int{
//                                
//                            if entry_idValue > self.lastEntryId {
//                                ++dataThingspeakCount
////                              print("entry_idValue:  \(entry_idValue)")
////                              print("lastEntryId:  \(self.lastEntryId)")
//                                    
//                                if let
//                                    created_at          = elem as? NSDictionary,
//                                    created_at_stamp    = created_at["created_at"] as? String{
////                                  print(created_at_stamp)
//                                            
//                                    if let
//                                        solarCellBattery        = elem as? NSDictionary,
//                                        solarCellBatteryValue   = solarCellBattery["field6"] as? String{
////                                      print(solarCellBatteryValue)
//                                                    
//                                        if let
//                                            lux         = elem as? NSDictionary,
//                                            luxValue    = lux["field7"] as? String{
////                                          print(luxValue)
////                                          print("\n")
//                                                            
////                                            Feed.createInManagedObjectContext(moc,
////                                                lux:        luxValue,
////                                                entry_id:   entry_idValue,
////                                                created_at: created_at_stamp,
////                                                battery:    solarCellBatteryValue)
//                                            }
//                                        }
//                                    }
//                            }
//                        }
//                   
//                        do {
//                        
//                            try self.managedObjectContext.save()
//
//                        } catch {
//                            print("Error in saving to database")
//                        }
//                    }
//                }
//                //ViewControllerUtils().hideActivityIndicator(self.view)
//            }
//            
//            print("Done - Getting data from Thingspeak Room channel...")
//            print("Got \(dataThingspeakCount) json objects from Thingspeak")
//            dataThingspeakCount = 0
//        } // End of HTTP request
//        
//        
//        getDataFromDatabase(2541)  // 24 timer a 34 sek
//        
//        print("Updating charts")
//        print("Created at entries: \(createdAtToChart.count)")
//        setChartTop(createdAtToChart, values: batteryToChart)
//        
//        setChartBottom(createdAtToChart, values: luxToChart)
//
//        print("Done - Updating charts")
//    }   // End of viewDidLoad
//    
//    
//    func getDataFromDatabase(numberOfRecords: Int){
//        
//        print("Getting data from database")
//        var dataCount = 0
//        
//        // Create a new fetch request using the Feed entity
//        let fetchRequest = NSFetchRequest(entityName: "Feed")
//        
//        // Fetch numberOfRecords
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "entry_id", ascending: true)]
//        fetchRequest.fetchLimit = numberOfRecords
//        
//        do {
//
//            dataRecords = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Feed]
//            
//            for dataRecord in dataRecords {
//                
//                ++dataCount // Count records from database
//                
//                if let created_at_value = dataRecord.created_at {
////                    print("Created at: \(created_at_value)")
//
//                    // create dateFormatter with GMT time format
//                    let dateFormatter = NSDateFormatter()
//                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
//                    
//                    let dateGMT = dateFormatter.dateFromString(created_at_value)
//                    
//                    // change to a readable time format and change to local time zone
//                    let offsetFromGMT = 3600.0
//                    let dateCET = NSDate(timeInterval: offsetFromGMT, sinceDate: dateGMT!)
//                    dateFormatter.dateFormat = "dd.MM 'kl.' HH:mm:ss"
//                    let timeStamp = dateFormatter.stringFromDate(dateCET)
//                    
////                    print(timeStamp)
//                    createdAtToChart.append(timeStamp)
//                }
//                
//                if let battery_value = dataRecord.battery {
////                    print("Battery id: \(battery_value)")
//                    batteryToChart.append(NSString(string: battery_value).doubleValue)
//
//                }
//                
////                if let lux_value = dataRecord.lux {
//////                    print("Lux: \(lux_value)")
////                    luxToChart.append(NSString(string: lux_value).doubleValue)
////                }
//                
//            }
//            
//        } catch {
//            
//            print("Could not fetch")
//        }
//        
//            print("Done - Getting data from database")
//            print("Got \(dataCount) records from database")
//            dataCount = 0
//    }
//    
//    
//    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
//        print("\(entry.value) in \(createdAtToChart[entry.xIndex])")
//        
//        graphDataLabel.text = "\(round(1000*entry.value)/1000) in \(createdAtToChart[entry.xIndex])"
//    }
//    
//    // Top Chart
//    func setChartTop(dataPoints: [String], values: [Double]) {
//        lineChartView.noDataText = "You need to provide data for the chart."
//        lineChartView.descriptionText = "State of battery charge"
//        lineChartView.xAxis.enabled = true
//        lineChartView.rightAxis.enabled = false
//        lineChartView.drawGridBackgroundEnabled = true
//        lineChartView.drawBordersEnabled = true
//        lineChartView.borderColor = UIColor(red: 0.408, green: 0.537, blue: 0.749, alpha: 1.0)
//        lineChartView.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1.0)
//        lineChartView.leftAxis.startAtZeroEnabled = false
//        lineChartView.leftAxis.customAxisMin = 2500
//        lineChartView.leftAxis.customAxisMax = 3000
//        lineChartView.xAxis.labelPosition = .Bottom
//        
//        
//        var dataEntries: [ChartDataEntry] = []
//        
//        for i in 0..<dataPoints.count {
//            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
//            dataEntries.append(dataEntry)
//        }
//        
////        let limitline = ChartLimitLine(limit: 2700.0, label: "Target")
////        lineChartView.rightAxis.addLimitLine(limitline)
//        
//        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Battery [mV]")
//        
//        //lineChartDataSet.circleRadius = 2.0
//        lineChartDataSet.drawCirclesEnabled = false
//        lineChartDataSet.drawCubicEnabled = true
//        lineChartDataSet.cubicIntensity = 0.5
//        lineChartDataSet.lineWidth = 1.8
//        lineChartDataSet.setColor(UIColor(red: 0.008, green: 0.165, blue: 0.533, alpha: 1.0))
//        
//        
//        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
//        lineChartView.data = lineChartData
//        lineChartData.setDrawValues(false)
//    
//        
//    }
//    
//    
//    // Bottom Chart
//    func setChartBottom(dataPoints: [String], values: [Double]) {
//        lineChartViewBottom.noDataText = "You need to provide data for the chart."
//        lineChartViewBottom.descriptionText = "Illuminance in the room"
//        lineChartViewBottom.xAxis.enabled = true
//        lineChartViewBottom.rightAxis.enabled = false
//        lineChartViewBottom.drawGridBackgroundEnabled = true
//        lineChartViewBottom.drawBordersEnabled = true
//        lineChartViewBottom.borderColor = UIColor(red: 0.408, green: 0.537, blue: 0.749, alpha: 1.0)
//        lineChartViewBottom.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1.0)
//        lineChartViewBottom.xAxis.labelPosition = .Bottom
//        
//        
//        var dataEntries: [ChartDataEntry] = []
//        
//        for i in 0..<dataPoints.count {
//            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
//            dataEntries.append(dataEntry)
//        }
//        
//                let limitline = ChartLimitLine(limit: 10000.0, label: "Full daylight")
//                lineChartViewBottom.rightAxis.addLimitLine(limitline)
//        
//        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Lux")
//        
//        //lineChartDataSet.circleRadius = 2.0
//        lineChartDataSet.drawCirclesEnabled = false
//        lineChartDataSet.drawCubicEnabled = true
//        lineChartDataSet.cubicIntensity = 0.5
//        lineChartDataSet.lineWidth = 1.8
//        lineChartDataSet.setColor(UIColor(red: 0.008, green: 0.165, blue: 0.533, alpha: 1.0))
//        
//        
//        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
//        lineChartViewBottom.data = lineChartData
//        lineChartData.setDrawValues(false)
//        
//        
//    }
//
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: - Save data to database
//    
//    
//    /*
//    // MARK: - Navigation
//    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    // Get the new view controller using segue.destinationViewController.
//    // Pass the selected object to the new view controller.
//    }
//    */
//    
//}
