import SwiftUI
import Firebase
import FirebaseFirestore

struct event: Identifiable { // holy shit this took a long fucking time jesus fucking christ it was being hard as fuck
    let id = UUID()
    let documentID: String // add this bitch
    let eventname: String
    let time: String
    let month: String
    let day: String
}


class upcomingEventsDataManager: ObservableObject {
    @Published var alleventslist: [event] = [] // data list
    var editingEvent: event?

    init() {
        print("Retrieving collection 'UpcomingEvents'...")
        getUpcomingEvents() // initialising the updated data to get at beginning
        print("'UpcomingEvents' retrieved")
    }

    func getUpcomingEvents() {
        alleventslist.removeAll() // clear the list
        let db = Firestore.firestore()
        let ref = db.collection("UpcomingEvents") // finding collection
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)") // if this happens everything is
                return
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let eventname = data["eventname"] as? String ?? ""
                    let time = data["time"] as? String ?? ""
                    let month = data["month"] as? String ?? ""
                    let day = data["day"] as? String ?? ""
                    let documentID = document.documentID
                    
                    let event = event(documentID: documentID, eventname: eventname, time: time, month: month, day: day)
                    self.alleventslist.append(event) // adding event with info from firebase
                }
            }
        }
    }

    func createEvent(event: event, completion: @escaping (Error?) -> Void) { // creating a new event
        print("Creating new event...")
        let db = Firestore.firestore()
        db.collection("UpcomingEvents").addDocument(data: [
            "eventname": event.eventname,
            "time": event.time,
            "month": event.month,
            "day": event.day
        ]) { error in
            completion(error)
            if error == nil {
                self.getUpcomingEvents()
            }
        }
        print("Event created with documentID: \(event.documentID)")
    }

    func deleteEvent(event: event, completion: @escaping (Error?) -> Void) { // who woulda fucking thought this one deletes an event
        print("Deleting event with documentID: \(event.documentID)...")
        let db = Firestore.firestore()
        let eventRef = db.collection("UpcomingEvents").document(event.documentID)
        
        eventRef.delete { error in
            completion(error)
            if error == nil {
                self.getUpcomingEvents()
            }
        }
        print("Event deleted")
    }

    
}
