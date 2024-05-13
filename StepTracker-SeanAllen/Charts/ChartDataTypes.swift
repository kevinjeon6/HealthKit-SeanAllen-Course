//
//  ChartDataTypes.swift
//  StepTracker-SeanAllen
//
//  Created by Kevin Mattocks on 5/9/24.
//

import Foundation

struct WeekdayChartData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
