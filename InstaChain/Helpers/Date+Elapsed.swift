//
//  Date+Elapsed.swift
//  InstaChain
//
//  Created by Pei on 2019/5/9.
//  Copyright © 2019 WWK. All rights reserved.
//

import Foundation

extension Date {
    
    func getElapsedInterval() -> String {
        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: Bundle.main.preferredLocalizations[0])
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.calendar = calendar
        
        var dateString: String?
        let interval = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            formatter.allowedUnits = [.year] // years
        } else if let month = interval.month, month > 0 {
            formatter.allowedUnits = [.month] // 1 month
        } else if let week = interval.weekOfYear, week > 0 {
            formatter.allowedUnits = [.weekOfMonth] // weeks
        } else if let day = interval.day, day > 0 {
            formatter.allowedUnits = [.day] // days
        } else if let hour = interval.hour, hour > 0 {
            formatter.allowedUnits = [.hour] // hours
        } else if let minute = interval.minute, minute > 0 {
            formatter.allowedUnits = [.minute] // minutes
        } else if let second = interval.second, second > 0 {
            formatter.allowedUnits = [.second] // seconds
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: Bundle.main.preferredLocalizations[0])
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            
            dateString = dateFormatter.string(from: self) // 'TODAY'
        }
        if dateString == nil {
            dateString = formatter.string(from: self, to: Date())
        }
        
        return dateString!
    }
}
