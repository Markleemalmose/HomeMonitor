//
//  WeatherStationStatisticsTemperatureViewController.swift
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

class WeatherStationStatisticsTemperatureViewController: UIViewController, ChartViewDelegate {
    
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
            values:         temperatureToChartWeather,
            chartView:      lineChartView,
            xmax:           30,
            xmin:           -5,
            description:    "Weatherstation temperature",
            chartUnitLabel: "Temperature [C°]")
        
        print("Done - Updating charts")
        
        dispatch_async(dispatch_get_main_queue(), {
            if let formatTemp:Float = Float(getAverage(temperatureToChartWeather)){
                let roundedTemp:String = String(Int(formatTemp))
                let avgLabel = "\(roundedTemp)C°"
                self.sumLabel.text = avgLabel
            }
        })
        
        
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) in \(createdAtToChartWeather[entry.xIndex])")
        
        graphDataLabel.text = "\(round(1000*entry.value)/1000)°C the \(createdAtToChartWeather[entry.xIndex])"
    }
}
