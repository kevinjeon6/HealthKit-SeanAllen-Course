//
//  DashboardView.swift
//  StepTracker-SeanAllen
//
//  Created by Kevin Mattocks on 5/3/24.
//

import Charts
import SwiftUI

enum HealthMetricContext: CaseIterable, Identifiable {
    ///Self is relating to HealthMetricContext
    ///var id of type Self (which is HealthMetricContext) returning self, the current item
    var id: Self { self }
    
    case steps
    case weight
    
    
    var title: String {
        switch self {
        case .steps:
            "Steps"
        case .weight:
            "Weight"
        }
    }
}

struct DashboardView: View {
    
    // MARK: - Properties
    @Environment(HealthKitManager.self) private var hkManager
    @AppStorage("hasSeenPermissionView") private var hasSeenPermissionView = false
    @State private var isShowingHealthKitPermissionSheet = false
    @State private var selectedStat: HealthMetricContext = .steps
    
    ///Computed property to make things a bit neater for the tint modifier based on steps or weight
    ///If didn't have computed property, you would have selectedStat == .steps ? .mint : .indigo
    var isSteps: Bool {
        selectedStat == .steps
    }
    
    var avgStepCount: Double {
        guard !hkManager.stepData.isEmpty else { return 0 }
        
        let totalSteps = hkManager.stepData.reduce(0) {$0 + $1.value}
        return totalSteps/Double(hkManager.stepData.count)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 20) {
                    
                    Picker("Selected Stat", selection: $selectedStat) {
                        ForEach(HealthMetricContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    VStack {
                        NavigationLink(value: selectedStat) {
                            HStack {
                                VStack (alignment: .leading) {
                                    Label("Steps", systemImage: "figure.walk")
                                        .font(.title3.bold())
                                        .foregroundColor(.mint)
                                    
                                    Text("Avg: \(Int(avgStepCount)) Steps")
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                
                            }
                        }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                        
                       // MARK: - Chart
                        Chart {
                            RuleMark(y: .value("Average", avgStepCount))
                                .foregroundStyle(.secondary)
                                .lineStyle(.init(lineWidth: 1, dash: [5]))
                            
                            ForEach(hkManager.stepData) { steps in
                                BarMark(
                                    x: .value( "Date", steps.date, unit: .day),
                                    y: .value("Steps", steps.value)
                                )
                                .foregroundStyle(Color.mint.gradient)
                                
                            }
                        }
                        .frame(height: 150)
                        .chartXAxis {
                            AxisMarks {
                                AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                            }
                        }
                        .chartYAxis {
                            AxisMarks {value in
                                AxisGridLine()
                                    .foregroundStyle(Color.secondary.opacity(0.3))
                                
                                AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                    
                    VStack(alignment: .leading) {
   
                            VStack(alignment: .leading) {
                                Label("Averages", systemImage: "calendar")
                                    .font(.title3.bold())
                                    .foregroundColor(.mint)
                                
                                Text("Last 28 Days")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
             
                            }
                            .padding(.bottom, 12)
                            
                         
                        
                        RoundedRectangle(cornerRadius: 13)
                            .foregroundStyle(.secondary)
                            .frame(height: 240)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                }
             
            }
            .padding()
            .task {
                await hkManager.fetchStepCount()
                isShowingHealthKitPermissionSheet = !hasSeenPermissionView
                
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDataListView(metric: metric)
            }
            .sheet(isPresented: $isShowingHealthKitPermissionSheet) {
                // fetch health data
            } content: {
                HKPermissionView(hasSeen: $hasSeenPermissionView)
            }
        }
        .tint(isSteps ? .mint : .indigo)
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
