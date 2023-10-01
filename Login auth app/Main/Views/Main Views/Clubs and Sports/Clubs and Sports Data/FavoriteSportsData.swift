import Foundation
import Firebase

struct sportFavorite: Identifiable {
    var user: String
    var favoritedSports: [String]
    let documentID: String
    let id = UUID()
}

class FavoriteSports: ObservableObject {
    @Published var favoritedsports: [sport] = []
    var userInfo = UserInfo.shared
    
    func getFavorites(completion: @escaping ([String]) -> Void) {
        let email = userInfo.email
        let db = Firestore.firestore()
        let collection = db.collection("FavoritedSports")
        
        collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
            }
            
            if let snapshot = snapshot {
                var returnvalue: [String] = []
                for document in snapshot.documents {
                    let data = document.data()
                    let user = data["user"] as? String ?? ""
                    let favoritedSports = data["favoritedSports"] as? [String] ?? []
                    if email == user {
                        returnvalue = favoritedSports
                    }
                }
                completion(returnvalue)
            }
        }
    }

    
    func addFavorite(sport: sport) {
        let email = userInfo.email
        let db = Firestore.firestore()
        let collection = db.collection("FavoritedSports")
        var documenttoupdate = ""
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error adding favorite: \(error.localizedDescription)")
            }
            var flag = false
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let user = data["user"] as? String ?? ""
                    let documentID = document.documentID
                    
                    if user == email {
                        flag = true
                        documenttoupdate = documentID
                    }
                }
            }
            if flag {
                let ref = collection.document(documenttoupdate)
                let sportid = "\(sport.sportname) \(sport.sportsteam)"
                ref.updateData([
                    "favoritedSports": FieldValue.arrayUnion([sportid])
                ])
            } else {
                collection.addDocument(data: [
                    "user": email,
                    "favoritedSports": ["\(sport.sportname) \(sport.sportsteam)"]
                ]) { error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
        let _ = getFavorites() { favorites in }
    }
    
    //MARK: ADD REMOVE FAVORITE FUNCTION
    func removeFavorite(sport: sport) {
        let email = userInfo.email
        let db = Firestore.firestore()
        let collection = db.collection("FavoritedSports")
        var documenttoupdate = ""
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error deleting favorite \(error.localizedDescription)")
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let user = data["user"] as? String ?? ""
                    let documentID = document.documentID
                    
                    if user == email {
                        documenttoupdate = documentID
                    }
                }
            }
            
            let ref = collection.document(documenttoupdate)
            let sportid = "\(sport.sportname) \(sport.sportsteam)"
            ref.updateData([
                "favoritedSports": FieldValue.arrayRemove([sportid])
            ])
        }
        let _ = getFavorites() { favorites in }
    }
}
