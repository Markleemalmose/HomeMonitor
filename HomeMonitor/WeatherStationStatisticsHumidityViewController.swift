//
//  WeatherStationStatisticsHumidityViewController.swift
//  HomeMonitor
//
//  Created by Mark Lee Malmose on 19/11/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//
//  Charts from https://github.com/danielgindi/ios-charts
//
//


import UIKit
import Charts

class WeatherStationStatisticsHumidityViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var graphDataLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        createdAtToChartWeather = [String]()
        print("catc \(createdAtToChartWeather)")
        
        lineChartView.delegate = self
        
        let dbCount = getDatabaseCount("WeatherFeed")
        print("db count \(dbCount)")
        getDataFromWeatherDatabase(dbCount)   // 24 timer a 34 sek
        
        print("Updating charts")
        print("Created at entries: \(createdAtToChartWeather.count)")
        
        setChart(createdAtToChartWeather,
            values:         humidityToChartWeather,
            chartView:      lineChartView,
            xmax:           100,
            xmin:           0,
            description:    "Weatherstation humidity",
            chartUnitLabel: "Humidity [%]")
        
        print("Done - Updating charts")
        
        dispatch_async(dispatch_get_main_queue(), {
            if let formatTemp:Float = Float(getAverage(humidityToChartWeather)){
                let roundedTemp:String = String(Int(formatTemp))
                let avgLabel = "\(roundedTemp)%"
                self.sumLabel.text = avgLabel
            }
        })
        
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) in \(createdAtToChartWeather[entry.xIndex])")
        
        graphDataLabel.text = "\(round(1000*entry.value)/1000)% the \(createdAtToChartWeather[entry.xIndex])"
    }
}
