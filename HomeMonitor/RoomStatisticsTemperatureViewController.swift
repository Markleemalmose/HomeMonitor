//
//  RoomStatisticsTemperatureViewController.swift
//  HomeMonitor
//
//  CFNetwork SSLHandshake failed (-9824) error solved by:
//  http://stackoverflow.com/questions/30739473/nsurlsession-nsurlconnection-http-load-failed-on-ios-9/30748166#30748166
//
//
//  http://stackoverflow.com/questions/26613971/coredata-warning-unable-to-load-class-named
//
//  Created by Mark Lee Malmose on 12/11/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//
//  Charts from https://github.com/danielgindi/ios-charts
//
//


import UIKit
import Charts

class RoomStatisticsTemperatureViewController: UIViewController, ChartViewDelegate  {

    // MARK: - Outlets
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var graphDataLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createdAtToChart = [String]()
        print("catc \(createdAtToChart)")
        
        lineChartView.delegate = self
        
        let dbCount = getDatabaseCount("Feed")
        print("db count \(dbCount)")
        getDataFromRoomDatabase(dbCount)   // 24 timer a 34 sek
        
        print("Updating charts")
        print("Created at entries: \(createdAtToChart.count)")
        
        setChart(createdAtToChart,
            values:         temperatureToChartRoom,
            chartView:      lineChartView,
            xmax:           30,
            xmin:           5,
            description:    "Room temperature",
            chartUnitLabel: "Temperature [C°]")
        
        print("Done - Updating charts")
        
        dispatch_async(dispatch_get_main_queue(), {
            if let formatTemp:Float = Float(getAverage(temperatureToChartRoom)){
                let roundedTemp:String = String(Int(formatTemp))
                let avgLabel = "\(roundedTemp)C°"
                self.sumLabel.text = avgLabel
            }
        })
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) in \(createdAtToChart[entry.xIndex])")
        
        graphDataLabel.text = "\(round(1000*entry.value)/1000)°C the \(createdAtToChart[entry.xIndex])"
    }
}
