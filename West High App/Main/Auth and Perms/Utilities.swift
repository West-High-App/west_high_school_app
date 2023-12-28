//
//  Utilities.swift
//  West high App
//

import Foundation
import UIKit

final class Utilities {
    
    static let shared = Utilities()
    private init() {}
    
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        
        // Accessing the window's rootViewController
        let controller = controller ?? windowScene.windows.first?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        return controller
    }
}


extension Date {
    
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
}

extension DateFormatter {
    
    func date(from date: Date) -> Date? {
        self.date(from: self.string(from: date))
    }
}

extension TimeZone {
    
    static let chicago = TimeZone(identifier: "America/Chicago")!
}
