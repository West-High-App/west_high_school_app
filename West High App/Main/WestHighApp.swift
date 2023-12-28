//  
// WestHighApp.swift
// West High App
//

import SwiftUI
import Firebase

@main
struct WestHighApp: App {
    
    init() {
        // Intilialize Firebase
        FirebaseApp.configure()
    }
    
    @StateObject var userInfo = UserInfo.shared
        
    var body: some Scene {
        WindowGroup {
            AuthView()
                .environmentObject(userInfo)
        }
    }
}
