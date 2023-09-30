import SwiftUI
import Firebase
import FirebaseFirestore

class event: NSObject, Identifiable {
    let id = UUID()
    let documentID: String
    let eventname: String
    let time: String
    let month: String
    let day: String
    let year: String
    var date: Date = Date()

    required init(documentID: String, eventname: String, time: String, month: String, day: String, year: String, publisheddate: String) {
        self.documentID = documentID
        self.eventname = eventname
        self.time = time
        self.month = month
        self.day = day
        self.year = year
 
        // Set the date formatter and optionally set the formatted date from string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        if let date = dateFormatter.date(from: publisheddate) {
            self.date = date
        }
    }

}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

class upcomingEventsDataManager: ObservableObject {
    @Published var allupcomingeventslist: [event] = []
    @Published var alleventslist: [event] = []
    @Published var firstcurrentevent = event(documentID: "", eventname: "", time: "", month: "", day: "", year: "", publisheddate: "")
    @Published var secondcurrentEvent = event(documentID: "", eventname: "", time: "", month: "", day: "", year: "", publisheddate: "")
    @Published var thirdcurrentEvent = event(documentID: "", eventname: "", time: "", month: "", day: "", year: "", publisheddate: "")


    var editingEvent: event?

    init() {
        getUpcomingEvents() // initialising the updated data to get at beginning
    }

    func getUpcomingEvents() {
        alleventslist.removeAll() // clear the list
        var templist: [event] = []
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
                    let year = data["year"] as? String ?? ""
                    let documentID = document.documentID
                    let event = event(documentID: documentID, eventname: eventname, time: time, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)")
                    
                    templist.append(event) // adding event with info from firebase
                }

                for event in self.allupcomingeventslist{
                    if event.date < Date.yesterday{
                        self.deleteEvent(event: event) { error in
                            if let error = error {
                                print("Error deleting event: \(error.localizedDescription)")
                            }
                        }

                    }
                }
                self.allupcomingeventslist = templist
                self.allupcomingeventslist = self.allupcomingeventslist.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
                self.allupcomingeventslist = self.allupcomingeventslist.reversed()
                if let firstEvent = self.allupcomingeventslist.first {
                  self.firstcurrentevent = firstEvent
                }
                if self.allupcomingeventslist.count > 1 {
                  self.secondcurrentEvent = self.allupcomingeventslist[1]
                }
                if self.allupcomingeventslist.count > 2 {
                  self.thirdcurrentEvent = self.allupcomingeventslist[2]
                }

            }
        }
    }

    func createEvent(event: event, completion: @escaping (Error?) -> Void) { // creating a new event
        let db = Firestore.firestore()
        db.collection("UpcomingEvents").addDocument(data: [
            "eventname": event.eventname,
            "time": event.time,
            "month": event.month,
            "day": event.day,
            "year": event.year,
            "publisheddate": event.date

        ]) { error in
            completion(error)
            if error == nil {
                self.getUpcomingEvents()
            }
        }
    }

    func deleteEvent(event: event, completion: @escaping (Error?) -> Void) { // who woulda fucking thought this one deletes an event
        let db = Firestore.firestore()
        let eventRef = db.collection("UpcomingEvents").document(event.documentID)
        
        eventRef.delete { error in
            completion(error)
            if error == nil {
                self.getUpcomingEvents()
            }
        }
    }
    
//    func filterByDate() -> [event]{
//        self.getUpcomingEvents()
//        self.alleventslist = self.allupcomingeventslist.sorted { first, second in
//            let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "MMM, d yyyy"
//            let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
//            let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
//            return firstDate < secondDate
//        }.reversed()
//        return(alleventslist)
//    }


    
}
