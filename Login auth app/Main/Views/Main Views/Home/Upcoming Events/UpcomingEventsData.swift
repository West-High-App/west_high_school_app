import SwiftUI
import Firebase
import FirebaseFirestore

class event: NSObject, Identifiable {
    let id = UUID()
    let documentID: String
    var eventname: String
    var time: String
    var month: String
    var day: String
    var year: String
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

extension Array<event> {
    func sortedByDate() -> Self {
        self.sorted(by: {
            $0.date.compare($1.date) == .orderedAscending
        })
    }
}

class upcomingEventsDataManager: ObservableObject {
    static let shared = upcomingEventsDataManager()
    
    @Published private var allupcomingeventslistUnsorted: [event] = []
    var allupcomingeventslist: [event] {
        allupcomingeventslistUnsorted.sortedByDate()
    }
    @Published var alleventslist: [event] = []
    var firstcurrentevent: event? {
        if let firstEvent = self.allupcomingeventslist.first {
            return firstEvent
        } else {
            return nil
        }
    }
    var secondcurrentEvent: event? {
        if self.allupcomingeventslist.count > 1 {
          return self.allupcomingeventslist[1]
        } else {
            return nil
        }
    }
    var thirdcurrentEvent: event? {
        if self.allupcomingeventslist.count > 2 {
          return self.allupcomingeventslist[2]
        } else {
            return nil
        }
    }


    var editingEvent: event?

    init() {
        getUpcomingEvents() // initialising the updated data to get at beginning
    }

    func getUpcomingEvents() {
        let db = Firestore.firestore()
        let ref = db.collection("UpcomingEvents") // finding collection
        ref.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)") // if this happens everything is
                return
            }
            if let snapshot = snapshot {
                var templist: [event] = [] {
                    didSet {
                        if templist.count == snapshot.count {
                            for temp in templist {
                                if let index = self.allupcomingeventslistUnsorted.firstIndex(where: { $0.documentID == temp.documentID }) {
                                    self.allupcomingeventslistUnsorted[index].eventname = temp.eventname
                                    self.allupcomingeventslistUnsorted[index].date = temp.date
                                    self.allupcomingeventslistUnsorted[index].day = temp.day
                                    self.allupcomingeventslistUnsorted[index].month = temp.month
                                    self.allupcomingeventslistUnsorted[index].year = temp.year
                                    self.allupcomingeventslistUnsorted[index].time = temp.time
                                } else {
                                    self.allupcomingeventslistUnsorted.append(temp)
                                }
                                if temp == templist.last {
                                    for event in self.allupcomingeventslistUnsorted {
                                        if !templist.contains(where: { $0.documentID == event.documentID }) {
                                            self.allupcomingeventslistUnsorted.removeAll(where: { $0.documentID == event.documentID }) // Remove if not on server
                                        }
                                        if event.date < Date.yesterday {
                                            self.deleteEvent(event: event) { error in // Remove if in the past
                                                if let error = error {
                                                    print("Error deleting event: \(error.localizedDescription)")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
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
        }
    }

    func deleteEvent(event: event, completion: @escaping (Error?) -> Void) { // who woulda fucking thought this one deletes an event
        let db = Firestore.firestore()
        let eventRef = db.collection("UpcomingEvents").document(event.documentID)
        
        eventRef.delete { error in
            completion(error)
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
