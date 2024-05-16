//
//  WeightLineChartView.swift
//  StepTracker-SeanAllen
//
//  Created by Kevin Mattocks on 5/16/24.
//

import Charts
import SwiftUI

struct WeightLineChartView: View {
    // MARK: - Properties
    
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetric]
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack (alignment: .leading) {
                        Label("Weight", systemImage: "figure")
                            .font(.title3.bold())
                            .foregroundColor(.indigo)
                        
                        Text("Avg: weight")
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
                ForEach(chartData) { weight in
                    AreaMark(
                        x: .value("Day",weight.date, unit: .day),
                        y: .value("Value", weight.value)
                    )
                    .foregroundStyle(Gradient(colors: [.blue.opacity(0.5), .clear]))
                    
                    LineMark(
                        x: .value("Day",weight.date, unit: .day),
                        y: .value("Value", weight.value)
                    )
                }
            }
            .frame(height: 150)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    WeightLineChartView(selectedStat: .weight, chartData: MockData.weights)
}
