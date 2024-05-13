//
//  Date-Ext.swift
//  StepTracker-SeanAllen
//
//  Created by Kevin Mattocks on 5/9/24.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    var weekdayTitle: String {
        self.formatted(.dateTime.weekday(.wide))
    }
}
