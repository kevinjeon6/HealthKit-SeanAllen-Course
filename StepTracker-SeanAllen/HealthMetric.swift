//
//  HealthMetric.swift
//  StepTracker-SeanAllen
//
//  Created by Kevin Mattocks on 5/8/24.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    
    
    static var mockData: [HealthMetric] {
        var array: [HealthMetric] = []
        
        for i in 0..<28 {
            let metric = HealthMetric(date: Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? Date(), value: .random(in: 4_000...15_000))
            array.append(metric)
        }
        
        return array
    }
}
