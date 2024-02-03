//
//  ShutdownManager.swift
//  West High
//
//  Created by August Andersen on 03/02/2024.
//

import Foundation
import Firebase

class ShutdownManager: ObservableObject {
    
    var isShutDown = false
    var shutdownMessage = "No info to display"
    
    // Fetches data on whether the app has been manually shut down
    func fetchData(completion: @escaping (Bool, String) -> Void) {
        
        let db = Firestore.firestore()
        let shutdownRef = db.collection("Shutdown")
        
        var isShutDownData = false
        var shutdownMessageData = ""
        shutdownRef.getDocuments { snapshot, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    isShutDownData = data["isShutDown"] as? Bool ?? false
                    shutdownMessageData = data["shutdownMessage"] as? String ?? "No info to display"
                }
            }
            completion(isShutDownData, shutdownMessageData)
        }
    }
}
