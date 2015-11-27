//
//  RoomStatisticsHumidityViewController.swift
//  HomeMonitor
//
//  Created by Mark Lee Malmose on 14/11/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//
//  Charts from https://github.com/danielgindi/ios-charts
//
//

import UIKit
import Charts

class RoomStatisticsHumidityViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var graphDataLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

        createdAtToChart = [String]()
        
        lineChartView.delegate = self
        
        let dbCount = getDatabaseCount("Feed")
        getDataFromRoomDatabase(dbCount)   // 24 timer a 34 sek 2541
        
        print("Updating charts")
        print("Created at entries: \(createdAtToChart.count)")
        
        setChart(createdAtToChart,
            values:         humidityToChartRoom,
            chartView:      lineChartView,
            xmax:           100,
            xmin:           0,
            description:    "Room humidity",
            chartUnitLabel: "Humidity [%]")
        
        print("Done - Updating charts")
        
        dispatch_async(dispatch_get_main_queue(), {
            if let formatTemp:Float = Float(getAverage(humidityToChartRoom)){
                let roundedTemp:String = String(Int(formatTemp))
                let avgLabel = "\(roundedTemp)%"
                self.sumLabel.text = avgLabel
            }
        })
       
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) in \(createdAtToChart[entry.xIndex])")
        
        graphDataLabel.text = "\(round(1000*entry.value)/1000)% the \(createdAtToChart[entry.xIndex])"
    }
}
