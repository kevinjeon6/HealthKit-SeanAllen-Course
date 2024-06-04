//
//  HealthDataListView.swift
//  StepTracker-SeanAllen
//
//  Created by Kevin Mattocks on 5/5/24.
//

import SwiftUI

struct HealthDataListView: View {
    
    // MARK: - Properties
    @Environment(HealthKitManager.self) private var hkManager
    @State private var isShowingAddData = false
    @State private var addDataDate: Date = .now
    @State private var valueToAdd: String = ""
    
    var metric: HealthMetricContext
    
    var listData: [HealthMetric] {
        metric == .steps ? hkManager.stepData : hkManager.weightData
    }
    
    
    // MARK: - Body
    var body: some View {
        List(listData.reversed()) { data in
            HStack {
                Text(data.date, format: .dateTime.month().day().year())
                Spacer()
                Text(data.value, format: .number.precision(.fractionLength(metric == . steps ? 0 : 1)))
            }
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar {
            Button("Add Data", systemImage: "plus") {
                isShowingAddData = true
            }
        }
    }
    
    
    
    // MARK: - AddDataView
    ///We are adding a variable as a  view to our view
    ///More practical for a simple view.
    ///Used for an isolated only view
    ///Can get access of the variables without passing them in
    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                HStack {
                    Text(metric.title)
                    Spacer()
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        Task {
                            if metric == .steps {
                                do {
                                    try await hkManager.addStepData(for: addDataDate, value: Double(valueToAdd)!)
                                    try await hkManager.fetchStepCount()
                                    isShowingAddData = false
                                } catch STError.sharingDenied(let quantityType) {
                                    print("❌ sharing denied for \(quantityType)")
                                } catch {
                                    print("❌ Data List View Unable to complete request")
                                }
                            } else {
                                do {
                                    try await hkManager.addWeightData(for: addDataDate, value: Double(valueToAdd)!)
                                    try await hkManager.fetchWeight()
                                    try await hkManager.fetchWeightForDifferentials()
                                    isShowingAddData = false
                                } catch STError.sharingDenied(let quantityType) {
                                    print("❌ sharing denied for \(quantityType)")
                                } catch {
                                    print("❌ Data List View Unable to complete request")
                                }
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingAddData = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataListView(metric: .steps)
            .environment(HealthKitManager())
    }
}
