//
//  ContentView.swift
//  CustomTabBar
//
//  Created by Pratik on 14/10/22.
//

import SwiftUI

let backgroundColor = Color.init(white: 0.92)

struct ContentViews: View {
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            VStack(spacing: 70) {
                TabBarView3()
            }
            .padding(.horizontal)
        }
    }
}

struct ContentViews_Previews: PreviewProvider {
    static var previews: some View {
        ContentViews()
    }
}


enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case home
    case announcments
    case activities
    case calendar
    case profile
    
    internal var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .announcments:
            return "Clubs"
        case .activities:
            return "Messages"
        case .calendar:
            return "Sports"
        case .profile:
            return "Info"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .activities:
            return "dice.fill"
        case .announcments:
            return "megaphone.fill"
        case .calendar:
            return "basketball.fill"
        case .profile:
            return "info.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .home:
            return .indigo
        case .activities:
            return .pink
        case .announcments:
            return .orange
        case .calendar:
            return .teal
        case .profile:
            return .green
        }
    }
}


