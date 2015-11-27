//
//  utilities.swift
//  HomeMonitor
//
//  Created by Mark Lee Malmose on 13/11/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//
import UIKit
import Foundation
import CoreData
import Charts


// Retreive the managedObjectContext from AppDelegate
let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
var dataRecordsFeed = [Feed]()
var dataRecordsWeatherFeed = [WeatherFeed]()

var createdAtToChart: [String] = []
var luxInsideToChartRoom: [Double] = []
var luxOutsideToChartRoom: [Double] = []
var temperatureToChartRoom: [Double] = []
var humidityToChartRoom: [Double] = []

var createdAtToChartWeather: [String] = []
var windspeedToChartWeather: [Double] = []
var wind_directionToChartWeather: [Double] = []
var temperatureToChartWeather: [Double] = []
var humidityToChartWeather: [Double] = []


var averageTemperature: Double = 0


func getLastEntryId(entity: String) -> Int{
    
    // Create a new fetch request using the Feed entity
    let fetchRequest = NSFetchRequest(entityName: entity)

    // Fetch only one record
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "entry_id", ascending: false)]
    fetchRequest.fetchLimit = 1

    do {
        let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest)
        if let lastEntry = fetchResults.first as! NSManagedObject? {
            return lastEntry.valueForKey("entry_id") as! Int
        }
    
    } catch {
        print("Could not fetch last entry id")
    }
    return 0
}

func getDatabaseCount(entity: String) -> Int{
    
    let fetchRequest = NSFetchRequest(entityName: entity)
    let count = managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
    return count
}


//Room database
func getDataFromRoomDatabase(numberOfRecords: Int){
        print("Getting data from room database")
        var dataCount = 0

        // Create a new fetch request using the Feed entity
        let fetchRequest = NSFetchRequest(entityName: "Feed")

        // Fetch numberOfRecords
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "entry_id", ascending: true)]
//        fetchRequest.fetchLimit = numberOfRecords

        do {

            dataRecordsFeed = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Feed]

            for dataRecord in dataRecordsFeed {

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
                    dateFormatter.dateFormat = "dd. MMM 'at' HH:mm:ss"
                    let timeStamp = dateFormatter.stringFromDate(dateCET)

//                    print(timeStamp)
                    createdAtToChart.append(timeStamp)
                }

                if let luxInside_value = dataRecord.luxInside
                {
                    luxInsideToChartRoom.append(NSString(string: luxInside_value).doubleValue)

                }
                
                if let luxOutside_value = dataRecord.luxOutside
                {
                    luxOutsideToChartRoom.append(NSString(string: luxOutside_value).doubleValue)
                    
                }
                
                if let temperature_value = dataRecord.temperature
                {
                    temperatureToChartRoom.append(NSString(string: temperature_value).doubleValue)
                }
                
                if let humidity_value = dataRecord.humidity
                {
                    humidityToChartRoom.append(NSString(string: humidity_value).doubleValue)
                    
                }
                
            }

        } catch {

            print("Could not fetch")
        }

            print("Done - Getting data from Room database")
            print("Got \(dataCount) records from Room database")
            dataCount = 0
    }


// Weather database
func getDataFromWeatherDatabase(numberOfRecords: Int){
    print("Getting data from weather database")
    var dataCount = 0
    
    // Create a new fetch request using the Feed entity
    let fetchRequest = NSFetchRequest(entityName: "WeatherFeed")
    
    // Fetch numberOfRecords
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "entry_id", ascending: true)]
    //        fetchRequest.fetchLimit = numberOfRecords
    
    do {
        
        dataRecordsWeatherFeed = try managedObjectContext.executeFetchRequest(fetchRequest) as! [WeatherFeed]
        
        for dataRecord in dataRecordsWeatherFeed {
            
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
                dateFormatter.dateFormat = "dd. MMM 'at' HH:mm:ss"
                let timeStamp = dateFormatter.stringFromDate(dateCET)
                
                //                    print(timeStamp)
                createdAtToChartWeather.append(timeStamp)
            }
            
            if let windspeed_value = dataRecord.wind_speed
            {
                windspeedToChartWeather.append(NSString(string: windspeed_value).doubleValue)   
            }
            
            if let wind_direction_value = dataRecord.wind_direction
            {
                wind_directionToChartWeather.append(NSString(string: wind_direction_value).doubleValue)
            }
            
            if let temperature_value = dataRecord.temperature
            {
                temperatureToChartWeather.append(NSString(string: temperature_value).doubleValue)
            }
            
            if let humidity_value = dataRecord.humidity
            {
                humidityToChartWeather.append(NSString(string: humidity_value).doubleValue)
            }
        }
        
    } catch {
        
        print("Could not fetch")
    }
    
    print("Done - Getting data from Room database")
    print("Got \(dataCount) records from Room database")
    dataCount = 0
}

func setChart(dataPoints: [String], values: [Double], chartView: LineChartView, xmax: Double, xmin: Double, description: String, chartUnitLabel: String) {
    chartView.noDataText = "You need to provide data for the chart."
    chartView.descriptionText = description
    chartView.xAxis.enabled = true
    chartView.rightAxis.enabled = false
    chartView.drawGridBackgroundEnabled = true
    chartView.drawBordersEnabled = true
    chartView.borderColor = UIColor(red: 0.408, green: 0.537, blue: 0.749, alpha: 1.0)
    chartView.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1.0)
    chartView.leftAxis.startAtZeroEnabled = false
    chartView.leftAxis.customAxisMin = xmin
    chartView.leftAxis.customAxisMax = xmax
    chartView.xAxis.labelPosition = .Bottom
    
    
    var dataEntries: [ChartDataEntry] = []
    
    for i in 0..<dataPoints.count {
        let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
        dataEntries.append(dataEntry)
    }
    
    //        let limitline = ChartLimitLine(limit: 2700.0, label: "Target")
    //        lineChartView.rightAxis.addLimitLine(limitline)
    
    let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: chartUnitLabel)
    
    lineChartDataSet.drawCirclesEnabled = false
    lineChartDataSet.drawCubicEnabled = true
    lineChartDataSet.cubicIntensity = 0.5
    lineChartDataSet.lineWidth = 1.8
    lineChartDataSet.setColor(UIColor(red: 0.008, green: 0.165, blue: 0.533, alpha: 1.0))
    
    
    let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
    chartView.data = lineChartData
    lineChartData.setDrawValues(false)
    
    
}

func getAverage(data: [Double]) -> Double
{
    let average = data.reduce(0) { $0 + $1 } / Double(data.count)
    return average

}



