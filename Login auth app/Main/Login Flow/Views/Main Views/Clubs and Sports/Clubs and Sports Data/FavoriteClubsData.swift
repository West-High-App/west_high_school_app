import Foundation
import Firebase

struct clubFavorite: Identifiable {
    var user: String
    var favoritedClubs: [String]
    let documentID: String
    let id = UUID()
}

class FavoriteClubs: ObservableObject {
    @Published var favoritedclubs: [club] = []
    var userInfo = UserInfo()
    
    func getFavorites(completion: @escaping ([String]) -> Void) {
        if userInfo.loginStatus == "google" {
            let email = userInfo.email
            var returnvalue: [String] = []
            let db = Firestore.firestore()
            let collection = db.collection("FavoritedClubs")
            
            collection.getDocuments { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion([])
                }
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        let user = data["user"] as? String ?? ""
                        let favoritedClubs = data["favoritedClubs"] as? [String] ?? []
                        if email == user {
                            returnvalue = favoritedClubs
                            print(returnvalue)
                            print("CLUb RETURN VALUE")
                        }
                    }
                }
                completion(returnvalue)
            }
        } else {
            completion([])
        }
    }
    
    func addFavorite(club: club) {
        let email = userInfo.email
        let db = Firestore.firestore()
        let collection = db.collection("FavoritedClubs")
        var documenttoupdate = ""
        collection.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
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
            let clubid = club.clubname
            ref.updateData([
                "favoritedClubs": FieldValue.arrayUnion([clubid])
            ])
            
            
        }
    }
    
    func removeFavorite(club: club) {
        let email = userInfo.email
        let db = Firestore.firestore()
        let collection = db.collection("FavoritedClubs")
        var documenttotupdate = ""
        collection.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let user = data["user"] as? String ?? ""
                    let documentID = document.documentID
                    
                    if user == email {
                        documenttotupdate = documentID
                    }
                }
            }
            
            let ref = collection.document(documenttotupdate)
            let clubid = club.clubname
            ref.updateData([
                "favoritedClubs": FieldValue.arrayRemove([clubid])
            ])
        }
    }
    
}
