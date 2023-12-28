//
//  DataManager.swift
//  Login auth app
//
//  Created by August Andersen on 6/3/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class UserStore: ObservableObject {
    @Published var user: User?
    
    init() {
        self.user = Auth.auth().currentUser
    }
}

class DataManager: ObservableObject {
    @Published var events: [Event] = []
    
    // init() {
       // getEvents()
    // }
    
    func getEvents() {
        events.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("TestList")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print("Error!")
                print(error!.localizedDescription)
                return
            }
            print("Shoulda worked")
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? Int ?? 0
                    let date = data["date"] as? String ?? ""
                    let title = data["title"] as? String ?? ""
                    let subtitle = data["subtitle"] as? String ?? ""
                    
                    let _ = Event(id: id, date: date, title: title, subtitle: subtitle)
                    //self.events.append(Event)
                }
            }
        }
    }
}
