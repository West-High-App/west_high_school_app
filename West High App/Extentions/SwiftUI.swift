//
//  SwiftUI.swift
//  West High
//
//  Created by August Andersen on 03/02/2024.
//

import Foundation
import SwiftUI

extension UIScreen {
    
    // Adding accessible screen size components
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    
}

extension UIApplication {
    
    // Finds safe area insets of the screen
    static var safeAreaInsets: UIEdgeInsets  {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets ?? .zero
    }
}
