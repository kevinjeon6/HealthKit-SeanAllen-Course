//
//  StepPieChartView.swift
//  StepTracker-SeanAllen
//
//  Created by Kevin Mattocks on 5/13/24.
//

import Charts
import SwiftUI

struct StepPieChartView: View {
    // MARK: - Properties
    var chartData: [WeekdayChartData]
    
    var body: some View {
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
                
            Chart {
                ForEach(chartData) { weekday in
                    SectorMark(
                        angle: .value( "Average Steps", weekday.value),
                        innerRadius: .ratio( 0.618),
                        angularInset: 1
                    )
                    .foregroundStyle(.mint)
                    .cornerRadius(6)
                }
            }
            .chartLegend(.hidden)
            .frame(height: 240)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    StepPieChartView(chartData: ChartMath.avgWeeklyCount(for: HealthMetric.mockData))
}
