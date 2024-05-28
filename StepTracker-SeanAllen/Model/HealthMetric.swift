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
}
