//
//  HealthKitManager.swift
//  StepTracker-SeanAllen
//
//  Created by Kevin Mattocks on 5/6/24.
//

import HealthKit
import Foundation
import Observation

@Observable class HealthKitManager {
    
    let healthStore = HKHealthStore()
    
    let allTypes: Set = [
        HKQuantityType(.stepCount),
        HKQuantityType(.bodyMass)
    ]
    
}
