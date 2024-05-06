//
//  DashboardView.swift
//  StepTracker-SeanAllen
//
//  Created by Kevin Mattocks on 5/3/24.
//

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
    @AppStorage("hasSeenPermissionView") private var hasSeenPermissionView = false
    @State private var isShowingHealthKitPermissionSheet = false
    @State private var selectedStat: HealthMetricContext = .steps
    
    ///Computed property to make things a bit neater for the tint modifier based on steps or weight
    ///If didn't have computed property, you would have selectedStat == .steps ? .mint : .indigo
    var isSteps: Bool {
        selectedStat == .steps
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
                                    
                                    Text("Avg: 10K Steps")
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                
                            }
                        }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                        
                        RoundedRectangle(cornerRadius: 13)
                            .foregroundStyle(.secondary)
                            .frame(height: 150)
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
            .onAppear {
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
