import SwiftUI
import Foundation
import Firebase

class LinkManager: ObservableObject {
        
    static let shared = LinkManager()
    
    @Published var linktionary: [String: String] = [:] // value is link
    
    init() {
        getLinks()
    }

    func getLinks() {
        
        let db = Firestore.firestore()
        let collection = db.collection("Links")
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let snapshot = snapshot {
                
                for document in snapshot.documents {
                    
                    let data = document.data()
                    let name = data["name"] as? String ?? ""
                    let link = data["link"] as? String ?? ""
                    
                    self.linktionary[name] = link
                    
                }
                                
            }
        }
    }
}
