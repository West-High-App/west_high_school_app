//
//  Shapes.swift
//  West High App
//

import Foundation
import SwiftUI

extension Rectangle {
    
    func signInButtonBackground(color: Color) -> some View {
        self
            .cornerRadius(9.0)
            .frame(width: 315, height: 50)
            .foregroundColor(color)
    }
    
}
