//
//  WeatherStatsViewController.swift
//  HomeMonitor
//
//  Created by Mark Lee Malmose on 26/10/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//

import UIKit
import CoreData
import Charts

class WeatherStatsViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var weatherStatsView: LineChartView!
    @IBOutlet weak var weatherStatsViewBottom: LineChartView!
    
    @IBOutlet weak var graphDataLabel: UILabel!
    

    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var newHttpRequest = HttpRequestJson()
    var feed: WeatherFeed!
    var lastEntryId: Int = 0
    var dataRecords = [WeatherFeed]()
    
    var createdAtToChart: [String] = []
    var humidityToChart: [Double] = []
    var temperatureToChart: [Double] = []
    var windSpeedToChart: [Double] = []
    var windDirectionToChart: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherStatsView.delegate = self
        weatherStatsViewBottom.delegate = self
        
        // Create a new fetch request using the Feed entity
        let fetchRequest = NSFetchRequest(entityName: "WeatherFeed")
        
        // Fetch only one record
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "entry_id", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        
        do {
            let fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            if let lastEntry = fetchResults.first as! NSManagedObject? {
                lastEntryId = lastEntry.valueForKey("entry_id") as! Int
                print("Last entry: \(lastEntryId)")
            }     
            
        } catch {
            
            print("Could not fetch")
        }
        
        
        //        print(managedObjectContext)
        
        //ViewControllerUtils().showActivityIndicator(self.view)
        // Use optional binding to confirm the managedObjectContext
        let moc = self.managedObjectContext
        var dataThingspeakCount = 0
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
                                
                        if entry_idValue > self.lastEntryId {
                            ++dataThingspeakCount
//                          print("entry_idValue:  \(entry_idValue)")
//                          print("lastEntryId:  \(self.lastEntryId)")
                                    
                            if let
                                created_at          = elem as? NSDictionary,
                                created_at_stamp    = created_at["created_at"] as? String{
//                              print(created_at_stamp)
                                        
                                if let
                                    windspeed       = elem as? NSDictionary,
                                    windspeedValue  = windspeed["field1"] as? String{
//                                  print(windspeedValue)
                                                    
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
                                                                            
                                                WeatherFeed.createInManagedObjectContext(moc,
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
            print("Got \(dataThingspeakCount) json objects from Thingspeak")
            dataThingspeakCount = 0
        } // End of HTTP request
        
        
        getDataFromDatabase(2541)
        
        print("Updating charts")
        print("Created at entries: \(createdAtToChart.count)")
        setChartTop(createdAtToChart, values: temperatureToChart)
        
        setChartBottom(createdAtToChart, values: humidityToChart)
        print("Done - Updating charts")
        
    }   // End of viewDidLoad
    
    
    func getDataFromDatabase(numberOfRecords: Int){
        print("Getting data from database")
        var dataCount = 0
        
        // Create a new fetch request using the Feed entity
        let fetchRequest = NSFetchRequest(entityName: "WeatherFeed")
        
        // Fetch only one record
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "entry_id", ascending: true)]
        fetchRequest.fetchLimit = numberOfRecords
        
        
        do {
            
            dataRecords = try managedObjectContext.executeFetchRequest(fetchRequest) as! [WeatherFeed]
            
            for dataRecord in dataRecords {
                
                ++dataCount // Count records from database
                
                if let created_at_value = dataRecord.created_at {
//                    print("Created at: \(created_at_value)")
                    
                    // create dateFormatter with GMT time format
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    
                    let dateGMT = dateFormatter.dateFromString(created_at_value)
                    
                    // change to a readable time format and change to local time zone
                    let offsetFromGMT = 3600.0
                    let dateCET = NSDate(timeInterval: offsetFromGMT, sinceDate: dateGMT!)
                    dateFormatter.dateFormat = "dd.MM 'kl.' HH:mm:ss"
                    let timeStamp = dateFormatter.stringFromDate(dateCET)
                
//                    print(timeStamp)
                    createdAtToChart.append(timeStamp)
                }
                
                if let windspeed_value = dataRecord.wind_speed {
//                    print("Windspeed: \(windspeed_value)")
                    windSpeedToChart.append(NSString(string: windspeed_value).doubleValue)
                }
                
                if let winddirection_value = dataRecord.wind_direction {
//                    print("Winddirection: \(winddirection_value)")
                    windDirectionToChart.append(NSString(string: winddirection_value).doubleValue)
                }
                
                if let humidity_value = dataRecord.humidity {
//                    print("Humidity: \(humidity_value)")
                    humidityToChart.append(NSString(string: humidity_value).doubleValue)
                }
                
                if let temperature_value = dataRecord.temperature {
//                    print("Temperature: \(temperature_value)")
                    temperatureToChart.append(NSString(string: temperature_value).doubleValue)
                }
                
            }
            
        } catch {
            
            print("Could not fetch")
        }
        print("Done - Getting data from database")
        print("Got \(dataCount) records from database")
        dataCount = 0
    }
    
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) in \(createdAtToChart[entry.xIndex])")
        graphDataLabel.text = "\(round(1000*entry.value)/1000) in \(createdAtToChart[entry.xIndex])"
    }
    
    // Top Chart
    func setChartTop(dataPoints: [String], values: [Double]) {
        weatherStatsView.noDataText = "You need to provide data for the chart."
        weatherStatsView.descriptionText = "Temperature"
        weatherStatsView.xAxis.enabled = true
        weatherStatsView.rightAxis.enabled = false
        weatherStatsView.drawGridBackgroundEnabled = true
        weatherStatsView.drawBordersEnabled = true
        weatherStatsView.borderColor = UIColor(red: 0.408, green: 0.537, blue: 0.749, alpha: 1.0)
        weatherStatsView.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1.0)
        weatherStatsView.leftAxis.startAtZeroEnabled = false
        weatherStatsView.leftAxis.customAxisMin = -10
        weatherStatsView.leftAxis.customAxisMax = 30
        weatherStatsView.xAxis.labelPosition = .Bottom
        weatherStatsView.xAxis.drawGridLinesEnabled = true
        
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        //        let limitline = ChartLimitLine(limit: 2700.0, label: "Target")
        //        lineChartView.rightAxis.addLimitLine(limitline)
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Temperature [C°]")
        
        //lineChartDataSet.circleRadius = 2.0
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawCubicEnabled = true
        lineChartDataSet.cubicIntensity = 0.5
        lineChartDataSet.lineWidth = 1.8
        lineChartDataSet.setColor(UIColor(red: 0.008, green: 0.165, blue: 0.533, alpha: 1.0))
        
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        weatherStatsView.data = lineChartData
        lineChartData.setDrawValues(false)
        
        
    }
    
    
    // Bottom Chart
    func setChartBottom(dataPoints: [String], values: [Double]) {
        weatherStatsViewBottom.noDataText = "You need to provide data for the chart."
        weatherStatsViewBottom.descriptionText = "Humidity"
        weatherStatsViewBottom.xAxis.enabled = true
        weatherStatsViewBottom.rightAxis.enabled = false
        weatherStatsViewBottom.drawGridBackgroundEnabled = true
        weatherStatsViewBottom.drawBordersEnabled = true
        weatherStatsViewBottom.borderColor = UIColor(red: 0.408, green: 0.537, blue: 0.749, alpha: 1.0)
        weatherStatsViewBottom.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1.0)
        weatherStatsViewBottom.leftAxis.startAtZeroEnabled = false
        weatherStatsViewBottom.xAxis.labelPosition = .Bottom
        
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
//        let limitline = ChartLimitLine(limit: 10000.0, label: "Full daylight")
//        weatherStatsViewBottom.rightAxis.addLimitLine(limitline)
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Humidity [%]")
        
        //lineChartDataSet.circleRadius = 2.0
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawCubicEnabled = true
        lineChartDataSet.cubicIntensity = 0.5
        lineChartDataSet.lineWidth = 1.8
        lineChartDataSet.setColor(UIColor(red: 0.008, green: 0.165, blue: 0.533, alpha: 1.0))
        
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        weatherStatsViewBottom.data = lineChartData
        lineChartData.setDrawValues(false)
        
        
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
