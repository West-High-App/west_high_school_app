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
    var userInfo = UserInfo()
    
    func getFavorites(completion: @escaping ([String]) -> Void) {
        let email = userInfo.email
        var returnvalue: [String] = []
        let db = Firestore.firestore()
        let collection = db.collection("FavoritedSports")
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let user = data["user"] as? String ?? ""
                    let favoritedSports = data["favoritedSports"] as? [String] ?? []
                    if email == user {
                        returnvalue = favoritedSports
                        print(returnvalue)
                        print("RETURN VALUE ^^^")
                    }
                }
            }
            completion(returnvalue)
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
                "favoritedSports": FieldValue.arrayUnion([sportid])
            ])
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
