//
//  RoomStatisticsLuxViewController.swift
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


class RoomStatisticsLuxViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var graphDataLabel: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var sumLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Reset createdAtToChart
        createdAtToChart = [String]()
        
        lineChartView.delegate = self
        
        let dbCount = getDatabaseCount("Feed")
        getDataFromRoomDatabase(dbCount)   // 24 timer a 34 sek
        
        print("Updating charts")
        print("Created at entries: \(createdAtToChart.count)")
        
        setChart(createdAtToChart,
            values:         luxInsideToChartRoom,
            chartView:      lineChartView,
            xmax:           500,
            xmin:           0,
            description:    "Room light",
            chartUnitLabel: "Light [lux]")
        
        print("Done - Updating charts")
        
        dispatch_async(dispatch_get_main_queue(), {
            if let formatTemp:Float = Float(getAverage(luxInsideToChartRoom)){
                let roundedTemp:String = String(Int(formatTemp))
                let avgLabel = "\(roundedTemp)lux"
                self.sumLabel.text = avgLabel
            }
        })
                
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) in \(createdAtToChart[entry.xIndex])")
        
        graphDataLabel.text = "\(round(1000*entry.value)/1000)lux the \(createdAtToChart[entry.xIndex])"
    }
}
