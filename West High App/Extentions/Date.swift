//
//  Date.swift
//  West High
//

import Foundation

extension Date {
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        return dateFormatter.string(from: self)
    }
    
    func dateComponent(_ component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        
        return calendar.component(component, from: self)
    }
    
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        guard initTimeZone != timeZone else { return self }
        
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
    
    var twelveHourTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: self)
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension DateFormatter {
    
    func date(from date: Date) -> Date? {
        self.date(from: self.string(from: date))
    }
}

extension TimeZone {
    
    static let chicago = TimeZone(identifier: "America/Chicago")!
}
