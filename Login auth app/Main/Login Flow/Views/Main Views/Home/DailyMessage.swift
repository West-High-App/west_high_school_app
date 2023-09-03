//
//  DailyMessage.swift
//  West High App
//
//  Created by Aiden Lee on 8/16/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct dailymessage: Identifiable {
    let id = UUID()
    let documentID: String // add this bitch
    let messagecontent: String
    let writer: String
}


class dailymessagelist: ObservableObject {
    @Published var alldailymessagelist: [dailymessage] = [] // data list
    var edittingdailymessage: dailymessage?

    init() {
        getdailymessage() // initialising the updated data to get at beginning
    }

    func getdailymessage() {
        alldailymessagelist.removeAll() // clear the list
        let db = Firestore.firestore()
        let ref = db.collection("DailyMessage") // finding collection
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)") // if this happens everything is fucked
                return
            }

            if let snapshot = snapshot {
                print("Scanning documents...")
                for document in snapshot.documents {
                    let data = document.data()
                    let writer = data["writer"] as? String ?? ""
                    let messagecontent = data["messagecontent"] as? String ?? ""
                    let documentID = document.documentID
                    
                    let dailymessage = dailymessage(documentID: documentID, messagecontent: messagecontent, writer: writer)
                    self.alldailymessagelist.append(dailymessage) // adding event with info from firebase
                }
            }
        }
    }

    func createEvent(event: dailymessage, completion: @escaping (Error?) -> Void) { // creating a new event
        print("Creating new event...")
        let db = Firestore.firestore()
        db.collection("DailyMessage").addDocument(data: [
            "messagecontent": event.messagecontent,
            "writer": event.writer,
        ]) { error in
            completion(error)
            if error == nil {
                self.getdailymessage()
            }
        }
        print("Event created with documentID: \(event.documentID)")
    }

    func deleteEvent(event: dailymessage, completion: @escaping (Error?) -> Void) {
        print("Deleting event with documentID: \(event.documentID)...")
        let db = Firestore.firestore()
        let eventRef = db.collection("DailyMessage").document(event.documentID)
        
        eventRef.delete { error in
            completion(error)
            if error == nil {
                self.getdailymessage()
            }
        }
        print("Event deleted")
    }

    
}

struct DailyMessage: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct DailyMessage_Previews: PreviewProvider {
    static var previews: some View {
        DailyMessage()
    }
}
