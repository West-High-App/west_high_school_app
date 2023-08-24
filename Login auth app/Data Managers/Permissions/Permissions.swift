import Foundation
import Firebase

struct permission: Identifiable {
    let id = UUID()
    let dataType: String
    let allowedUsers: [String]
    let documentID: String
}

class permissionsDataManager: ObservableObject {
    @Published var permissions: [String: [String]] = [:]
    
    func checkPermissions(dataType: String, user: String, completion: @escaping (Bool) -> Void) {
        print("chekcing permissions")
        self.permissions.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Permissions")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                completion(false)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let dataType = data["dataType"] as? String ?? ""
                    let allowedUsers = data["allowedUsers"] as? [String] ?? []
                    let documentID = document.documentID
                    
                    self.permissions[dataType] = allowedUsers
                }
            }
            print(self.permissions)
            
            var returnValue = false
            for thing in self.permissions {
                if thing.key == dataType {
                    if thing.value.contains(user) {
                        returnValue = true
                    }
                }
            }
            print("has permisison??? ->>> \(returnValue)")
            completion(returnValue)
        }
    }
    
    func updatePermission(_ permission: permission, completion: @escaping (Error?) -> Void) {
            let db = Firestore.firestore()
            let documentRef = db.collection("Permissions").document(permission.documentID)
            
            documentRef.setData([
                "dataType": permission.dataType,
                "allowedUsers": permission.allowedUsers
            ], merge: true) { error in
                completion(error)
            }
        }
}

