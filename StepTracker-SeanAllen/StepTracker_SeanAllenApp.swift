//
//  StepTracker_SeanAllenApp.swift
//  StepTracker-SeanAllen
//
//  Created by Kevin Mattocks on 5/3/24.
//

import SwiftUI

@main
struct StepTracker_SeanAllenApp: App {
    
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
            ///This modifer is used for iOS 17+. Prior to that, you would use environmentObject.
            ///Currently injecting this at top level/root view of the app
        }
    }
}
