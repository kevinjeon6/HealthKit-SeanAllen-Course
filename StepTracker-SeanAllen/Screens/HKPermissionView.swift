//
//  HKPermissionView.swift
//  StepTracker-SeanAllen
//
//  Created by Kevin Mattocks on 5/6/24.
//

import SwiftUI
import HealthKitUI

struct HKPermissionView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @Environment(\.dismiss) private var dismiss
    @State private var trigger = false
    
    var description = """
    This app displays your step and weight data in interactive charts.
    
    You can also add new step or weight data to Apple Health from this app. Your data is private and secured.
    """
    
    var body: some View {
        VStack(spacing: 130) {
            VStack(alignment: .leading, spacing: 10) {
                Image(.applehealthIcon)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .shadow(color: .gray.opacity(0.3), radius: 16)
                    .padding(.bottom, 12)
                
                Text("Apple Health Integration")
                    .font(.title2.bold())
                
                Text(description)
                    .foregroundStyle(.secondary)
            }
            
            Button("Connect Apple Health") {
                //Check if Health Data is available on the device
                
                if HKHealthStore.isHealthDataAvailable() {
                    trigger = true
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .padding(30)
        .interactiveDismissDisabled()
        .healthDataAccessRequest(
            store: hkManager.healthStore,
            shareTypes: hkManager.allTypes,
            readTypes: hkManager.allTypes,
            trigger: trigger) { result in
                switch result {
                    
                case .success(_):
                    dismiss()
                case .failure(_):
                    //handle error later
                    dismiss()
                }
            }
    }
}

#Preview {
    HKPermissionView()
        .environment(HealthKitManager())
}
