//
//  ChartMath.swift
//  StepTracker-SeanAllen
//
//  Created by Kevin Mattocks on 5/9/24.
//

import Foundation
import Algorithms

struct ChartMath {
    
    static func avgWeeklyCount(for metric: [HealthMetric]) -> [WeekdayChartData] {
        let sortedByWeekday = metric.sorted{$0.date.weekdayInt < $1.date.weekdayInt }
        
        
        ///Checking and making sure that they day of the week Int is equal to each other. If they are not equal, a new array is created.
        let weekDayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }
        
        var weekDayChartData: [WeekdayChartData] = []
        
        for array in weekDayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgSteps = total/Double(array.count)
            
            weekDayChartData.append(.init(date: firstValue.date, value: avgSteps))
        }

        return weekDayChartData
    }
    
    
    static func averageDailyweightDiffs(for weights: [HealthMetric]) -> [WeekdayChartData] {
        var diffValues: [(date: Date, value: Double)] = []
        
        for i in 1..<weights.count {
            
            let date = weights[i].date
            let diff = weights[i].value - weights[i - 1].value
            diffValues.append((date: date, value: diff))
        }
        
//        for value in diffValues {
//            print("\(value.date) ,\(value.value)")
//        }
        
        let sortedByWeekday = diffValues.sorted{$0.date.weekdayInt < $1.date.weekdayInt }
        let weekDayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }
        var weekDayChartData: [WeekdayChartData] = []
        
//        for array in weekDayArray {
//            print("---------")
//            for day in array {
//                print("\(day.date.weekdayInt), \(day.value)")
//            }
//        }
        
        
        for array in weekDayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgWeightDiff = total/Double(array.count)
            
            weekDayChartData.append(.init(date: firstValue.date, value: avgWeightDiff))
        }
        return weekDayChartData
    }
    
}
