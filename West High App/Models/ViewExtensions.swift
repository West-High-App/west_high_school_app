//
//  ViewExtensions.swift
//  West High App
//

import Foundation
import SwiftUI

extension Text {
    
    func screenMessageStyle(size: CGFloat) -> some View {
        self
            .lineLimit(2)
            .minimumScaleFactor(0.2)
            .multilineTextAlignment(.center)
            .font(.system(size: size, weight: .semibold, design: .rounded))
            .fontWeight(.medium)
            .padding(.horizontal)
            .foregroundColor(Color.yellow)
            .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
    }
    
    func signInButtonText(color: Color) -> some View {
        self
            .font(.body)
            .foregroundColor(color)
            .padding(.horizontal, 20)
            .cornerRadius(9)
    }
    
}

extension Rectangle {
    
    func signInButtonBackground(color: Color) -> some View {
        self
            .cornerRadius(9.0)
            .frame(width: 315, height: 50)
            .foregroundColor(color)
    }
    
}
