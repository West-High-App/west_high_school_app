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
    var isAllDay: Bool
    var publishedDate: Date = Date()
    var date: Date

    required init(documentID: String, eventname: String, time: String, month: String, day: String, year: String, isAllDay: Bool, publisheddate: String, date: Date, convertDate: Bool = true) {
        self.documentID = documentID
        self.eventname = eventname
        self.time = time
        self.month = month
        self.day = day
        self.year = year
        self.isAllDay = isAllDay
 
        // Set the date formatter and optionally set the formatted date from string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        if let date = dateFormatter.date(from: publisheddate) {
            let convertedDate = date.convertToTimeZone(initTimeZone: .chicago, timeZone: .current)
            
            if convertDate {
                self.publishedDate = convertedDate
            } else {
                self.publishedDate = date
            }
        }
        let convertedDate = date.convertToTimeZone(initTimeZone: .chicago, timeZone: .current)
        if convertDate {
            self.date = convertedDate
        } else {
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
            $0.publishedDate.compare($1.publishedDate) == .orderedAscending
        })
    }
}

class upcomingEventsDataManager: ObservableObject {
    static let shared = upcomingEventsDataManager()
    
    @Published var allupcomingeventslistUnsorted: [event] = []
    var allupcomingeventslist: [event] {
        allupcomingeventslistUnsorted.sortedByDate()
    }
    @Published var alleventslist: [event] = []
    private let fetchLimit = 20
    private var lastDocument: DocumentSnapshot?
    @Published private(set) var allDocsLoaded = false
    
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
        connectUpcomingEvents() // initialising the updated data to get at beginning
    }
    
    private func handleFirestore(_ templist: [event]) {
        for temp in templist {
            if let index = self.allupcomingeventslistUnsorted.firstIndex(where: { $0.documentID == temp.documentID }) {
                self.allupcomingeventslistUnsorted[index].eventname = temp.eventname
                self.allupcomingeventslistUnsorted[index].publishedDate = temp.publishedDate
                self.allupcomingeventslistUnsorted[index].day = temp.day
                self.allupcomingeventslistUnsorted[index].month = temp.month
                self.allupcomingeventslistUnsorted[index].year = temp.year
                self.allupcomingeventslistUnsorted[index].time = temp.time
            } else {
                self.allupcomingeventslistUnsorted.append(temp)
            }
            if temp == templist.last {
                for (index, event) in self.allupcomingeventslistUnsorted.enumerated() {
                    if let docId = self.lastDocument?.documentID, let endIndex = self.allupcomingeventslistUnsorted.firstIndex(where: { $0.documentID == docId }) {
                        let startIndex = endIndex-templist.count
                        if startIndex < index, index <= endIndex, !templist.contains(where: { $0.documentID == event.documentID }) {
                            self.allupcomingeventslistUnsorted.removeAll(where: { $0.documentID == event.documentID }) // Remove if not on server
                        }
                    }
                    if event.publishedDate < Date.yesterday {
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
    func getMoreUpcomingEvents() {
        guard let lastDocument else { return }
        
        let db = Firestore.firestore()
        let ref = db.collection("UpcomingEvents") // finding collection
        ref
            .order(by: "date")
            .start(afterDocument: lastDocument)
            .limit(to: self.fetchLimit)
            .getDocuments { snapshot, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)") // if this happens everything is
                return
            }
            if let snapshot = snapshot {
                self.lastDocument = snapshot.documents.last
                let templist = snapshot.documents.map { document in
                    let data = document.data()
                    let eventname = data["eventname"] as? String ?? ""
                    let time = data["time"] as? String ?? ""
                    let month = data["month"] as? String ?? ""
                    let day = data["day"] as? String ?? ""
                    let year = data["year"] as? String ?? ""
                    let isAllDay = data["isAllDay"] as? Bool ?? false
                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                    let documentID = document.documentID
                    let event = event(documentID: documentID, eventname: eventname, time: time, month: month, day: day, year: year, isAllDay: isAllDay, publisheddate: "\(month) \(day), \(year)", date: date)
                    
                   return event // adding event with info from firebase
                }
                self.handleFirestore(templist)
                if snapshot.documents.count < self.fetchLimit {
                    self.allDocsLoaded = true
                }

            }
        }
    }

    func connectUpcomingEvents() {
        let db = Firestore.firestore()
        let ref = db.collection("UpcomingEvents") // finding collection
        ref
            .order(by: "date", descending: false)
            .limit(to: self.fetchLimit)
            .addSnapshotListener { snapshot, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)") // if this happens everything is
                return
            }
            if let snapshot = snapshot {
                
                
                if self.lastDocument == nil {
                    self.lastDocument = snapshot.documents.last
                }
                
                let templist = snapshot.documents.map { document in
                    let data = document.data()
                    let eventname = data["eventname"] as? String ?? ""
                    let time = data["time"] as? String ?? ""
                    let month = data["month"] as? String ?? ""
                    let day = data["day"] as? String ?? ""
                    let year = data["year"] as? String ?? ""
                    let isAllDay = data["isAllDay"] as? Bool ?? false
                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                    let documentID = document.documentID
                    let event = event(documentID: documentID, eventname: eventname, time: time, month: month, day: day, year: year, isAllDay: isAllDay, publisheddate: "\(month) \(day), \(year)", date: date)
                    
                   return event // adding event with info from firebase
                }
                self.handleFirestore(templist)
                if snapshot.documents.count < self.fetchLimit {
                    self.allDocsLoaded = true
                }

            }
        }
    }

    func createEvent(event: event, completion: @escaping (Error?) -> Void) { // creating a new event
        let db = Firestore.firestore()
        let convertedDate = event.date.convertToTimeZone(initTimeZone: .current, timeZone: .chicago)
        
        db.collection("UpcomingEvents").addDocument(data: [
            "eventname": event.eventname,
            "time": convertedDate.twelveHourTime,
            "month": convertedDate.monthName,
            "day": "\(convertedDate.dateComponent(.day))",
            "year": "\(convertedDate.dateComponent(.year))",
            "publisheddate": convertedDate,
            "date": convertedDate,
            "isAllDay": event.isAllDay
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
