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
    
    
    //Functions that try need to handle the error or be marked with "throws"
    // async throws means that it might throw an error and it might suspend its execution
    func fetchStepCount () async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)!
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        //Create the query descriptor
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.stepCount), predicate: queryPredicate)
        
        let sumOfStepQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: samplePredicate,
            options: .cumulativeSum,
            anchorDate: endDate,
            intervalComponents: .init(day: 1))
        
        let stepCount = try! await sumOfStepQuery.result(for: healthStore)
        
        
        //Looping of the results of stepCount to make sure we have it by printing it out
//        for steps in stepCount.statistics() {
//            print(steps.sumQuantity() ?? 0)
//        }
        
    }
    
    func fetchWeight () async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)!
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        //Create the query descriptor
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.bodyMass), predicate: queryPredicate)
        
        let weightQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: samplePredicate,
            options: .mostRecent,
            anchorDate: endDate,
            intervalComponents: .init(day: 1))
        
        let weights = try! await weightQuery.result(for: healthStore)
        
        
        //Looping of the results of stepCount to make sure we have it by printing it out
//        for weight in weights.statistics() {
//            print(weight.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
//        }
        
    }
    

    
    
//    func addSimulatorData() async {
//        
//        var mockSamples: [HKQuantitySample] = []
//        
//        for i in 0..<28 {
//            let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4_000...20_000))
//            let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now)!
//            let endDate = Calendar.current.date(byAdding: .second, value: 1, to: startDate)!
//            let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: startDate, end: endDate)
//            
//            let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: (160 + Double(i/3)...165 + Double(i/3))))
//            let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass), quantity: weightQuantity, start: startDate, end: endDate)
//            
//            mockSamples.append(stepSample)
//            mockSamples.append(weightSample)
//        }
//        
//        try! await healthStore.save(mockSamples)
//        print("Dummy Data sent up 👀")
//        
//    }
    
}
