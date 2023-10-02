//
//  SportsEventsData.swift
//  West High App
//
//  Created by August Andersen on 30/08/2023.
//
//MARK: this bitch is old we ain't gonna be using it
import Foundation
import SwiftUI
import Firebase

class sportEvent: NSObject, Identifiable {
    let id = UUID()
    let arrayId: String
    let documentID: String
    let title: String
    let subtitle: String
    let month: String
    let day: String
    let year: String
    var date: Date = Date()
    var isSpecial: Bool// should the score be shown in the view
    var score: [Int] = [0, 0] // score of game (if applicable), home team first
    var isUpdated: Bool // should it show on past games
    
    required init(documentID: String, arrayId: String, title: String, subtitle: String, month: String, day: String, year: String, publisheddate: String, isSpecial: Bool, score: [Int], isUpdated: Bool) {
        self.documentID = documentID
        self.arrayId = arrayId
        self.title = title
        self.subtitle = subtitle
        self.month = month
        self.day = day
        self.year = year
        self.isSpecial = isSpecial
        self.score = score
        self.isUpdated = isUpdated
 
        // Set the date formatter and optionally set the formatted date from string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        if let date = dateFormatter.date(from: publisheddate) {
            self.date = date
        }
    }
}

// TODO: Rewrite flows to allow for snapshot listener
// TODO: get this shit to work bro what :o

class sportEventManager: ObservableObject {
    @Published var sportsEvents: [sportEvent] = []
    @Published var pastSportsEvents: [sportEvent] = []
    @Published var topthree: [sportEvent] = []
    @Published var hasInitialized: Bool = false
    @Published var eventDictionary: [String: [sportEvent]] = [:]
    @Published var pastEventDictionary: [String: [sportEvent]] = [:]
    private var eventSnapshotListener: ListenerRegistration?
    private var pastEventSnapshotListener: ListenerRegistration?
    private var documentId = ""
    
    static let shared = sportEventManager() // singleton, i love you Per
     
    func getSportsEvent(forSport: String, completion: @escaping ([sportEvent]?, Error?) -> Void) {
        if eventSnapshotListener != nil {
            eventSnapshotListener?.remove()
            self.eventSnapshotListener = nil
        }
        
        let db = Firestore.firestore()
        let collection = db.collection("SportEvents")
        
        self.eventSnapshotListener = collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            if let snapshot = snapshot {
                var pastReturnValue: [sportEvent] = []
                var returnValue: [sportEvent] = [] {
                    didSet {
                        if returnValue.count == snapshot.count {
                            for event in returnValue{
                                if event.date < Date.yesterday{
                                    
                                    // returnValue.removeAll {$0 == event}
                                    pastReturnValue.append(event) // if its in the past, add it to the past list
                                    
                                }
                            }
                            
                            // past lists
                            
                            self.pastEventDictionary[forSport] = pastReturnValue
                            self.pastEventDictionary[forSport] = self.pastEventDictionary[forSport]?.sorted(by: {
                                $0.date.compare($1.date) == .orderedDescending
                            })
                            self.pastEventDictionary[forSport] = self.pastEventDictionary[forSport]?.reversed()
                            self.pastSportsEvents = pastReturnValue
                            self.pastSportsEvents = self.pastSportsEvents.sorted(by: {
                                $0.date.compare($1.date) == .orderedDescending
                            })
                            print("got past sports events")
                            print(self.pastSportsEvents)
                            
                            // upcoming lists

                            self.eventDictionary[forSport] = returnValue
                            self.eventDictionary[forSport] = self.eventDictionary[forSport]?.sorted(by: {
                                $0.date.compare($1.date) == .orderedDescending
                            })
                            self.eventDictionary[forSport] = self.eventDictionary[forSport]?.reversed()
                            self.sportsEvents = returnValue
                            self.sportsEvents = self.sportsEvents.sorted(by: {
                                $0.date.compare($1.date) == .orderedDescending
                            })
                            self.sportsEvents = self.sportsEvents.reversed()
                            print("got upcoming sports events")
                            print()
                            completion(returnValue, nil)
                        }
                    }
                }
                for document in snapshot.documents {
                    let data = document.data()
                    let sportID = data["sportID"] as? String ?? ""
                    let events = data["events"] as? [[String: Any]] ?? []
                    let documentID = document.documentID
                    
                    if sportID == forSport {
                        // making in into a sportEvent
                        self.documentId = document.documentID
                        for event in events {
                            let id = event["id"] as? String ?? UUID().uuidString
                            let eventname = event["title"] as? String ?? ""
                            let time = event["subtitle"] as? String ?? ""
                            let month = event["month"] as? String ?? ""
                            let day = event["day"] as? String ?? ""
                            let year = event["year"] as? String ?? ""
                            let isSpecial = event["isSpecial"] as? Bool ?? false
                            let score = event["score"] as? [Int] ?? []
                            let isUpdated = event["isUpdated"] as? Bool ?? false

                            let newEvent = sportEvent(documentID: documentID, arrayId: id, title: eventname, subtitle: time, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)", isSpecial: isSpecial, score: score, isUpdated: isUpdated)
                            returnValue.append(newEvent)
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    func getPastSportsEvents(forSport: String, completion: @escaping ([sportEvent]?, Error?) -> Void) {
        if pastEventSnapshotListener != nil {
            pastEventSnapshotListener?.remove()
            self.pastEventSnapshotListener = nil
        }
        
        let db = Firestore.firestore()
        let collection = db.collection("SportEvents")
        
        self.pastEventSnapshotListener = collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            if let snapshot = snapshot {
                var pastReturnValue: [sportEvent] = []
                var returnValue: [sportEvent] = [] {
                    didSet {
                        if returnValue.count == snapshot.count {
                            for event in returnValue{
                                if event.date < Date.yesterday{
                                    
                                    returnValue.removeAll {$0 == event}
                                    pastReturnValue.append(event) // if its in the past, add it to the past list
                                    
                                }
                            }
                            
                            // past lists
                            
                            self.pastEventDictionary[forSport] = pastReturnValue
                            self.pastEventDictionary[forSport] = self.pastEventDictionary[forSport]?.sorted(by: {
                                $0.date.compare($1.date) == .orderedDescending
                            })
                            self.pastEventDictionary[forSport] = self.pastEventDictionary[forSport]?.reversed()
                            self.pastSportsEvents = pastReturnValue
                            self.pastSportsEvents = self.pastSportsEvents.sorted(by: {
                                $0.date.compare($1.date) == .orderedDescending
                            })
                            print("got past sports events")
                            print(self.pastSportsEvents)
                            let completionValue = self.pastSportsEvents
                            
                            completion(completionValue, nil)
                        }
                    }
                }
                for document in snapshot.documents {
                    let data = document.data()
                    let sportID = data["sportID"] as? String ?? ""
                    let events = data["events"] as? [[String: Any]] ?? []
                    let documentID = document.documentID
                    
                    if sportID == forSport {
                        // making in into a sportEvent
                        self.documentId = document.documentID
                        for event in events {
                            let id = event["id"] as? String ?? ""
                            let eventname = event["title"] as? String ?? ""
                            let time = event["subtitle"] as? String ?? ""
                            let month = event["month"] as? String ?? ""
                            let day = event["day"] as? String ?? ""
                            let year = event["year"] as? String ?? ""
                            let isSpecial = event["isSpecial"] as? Bool ?? false
                            let score = event["score"] as? [Int] ?? []
                            let isUpdated = event["isUpdated"] as? Bool ?? false

                            let newEvent = sportEvent(documentID: documentID, arrayId: id, title: eventname, subtitle: time, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)", isSpecial: isSpecial, score: score, isUpdated: isUpdated)
                            returnValue.append(newEvent)
                        }
                        
                        
                    }
                }

            }
        }
    }
    
    func createParsedSportEvent(forSport: String, sportEvent: ParsedEvent) {
        var eventlist: [[String: Any]] = []
        var eventdocumentID = ""
        let db = Firestore.firestore()
        let collection = db.collection("SportEvents")
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                var docID = ""
                for doc in snapshot.documents {
                    let data = doc.data()
                    let sportID = data["sportID"] as? String ?? ""
                    let events = data["events"] as? [[String: Any]] ?? []
                    docID = doc.documentID
                    
                    if sportID == forSport {
                        eventlist = events // got up to here truw
                        eventdocumentID = docID
                        
                        let monthformat = DateFormatter()
                        monthformat.dateFormat = "MMM"
                        let month = monthformat.string(from: sportEvent.date)
                        let dayformat = DateFormatter()
                        dayformat.dateFormat = "d"
                        let day = dayformat.string(from: sportEvent.date)
                        let yearformat = DateFormatter()
                        yearformat.dateFormat = "yyyy"
                        let year = yearformat.string(from: sportEvent.date)
                        
                        // update that bitch
                        var eventtoadd: [String: Any] = [:]
                        let title = sportEvent.type
                        let subtitle = sportEvent.opponent
                        let publisheddate = "\(month) \(day), \(year)"
                        let isSpecial = false
                        let isUpdated = true
                        let score = [0, 0]
                        eventtoadd = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate, "score": score, "isSpecial": isSpecial, "isUpdated": isUpdated]
                        eventlist.append(eventtoadd) // here you fat fuck
                        
                        collection.document(eventdocumentID).updateData([
                            "events": eventlist
                        ]) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                    }
                }
                var Bool = true
                for _ in eventlist {
                    Bool = false
                }
                if Bool {
                    var eventtoadd: [String: Any] = [:]
                    
                    let monthformat = DateFormatter()
                    monthformat.dateFormat = "MMM"
                    let month = monthformat.string(from: sportEvent.date)
                    let dayformat = DateFormatter()
                    dayformat.dateFormat = "d"
                    let day = dayformat.string(from: sportEvent.date)
                    let yearformat = DateFormatter()
                    yearformat.dateFormat = "yyyy"
                    let year = yearformat.string(from: sportEvent.date)
                    
                    // update that bitch
                    let title = sportEvent.type
                    let subtitle = sportEvent.opponent
                    let publisheddate = "\(month) \(day), \(year)"
                    let isSpecial = false
                    let isUpdated = true
                    let score = [0, 0]
                    eventtoadd = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate, "score": score, "isSpecial": isSpecial, "isUpdated": isUpdated]

                    collection.addDocument(data: [
                        "sportID": forSport,
                        "events": [eventtoadd]
                    ]) { error in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    

    func createSportEvent(forSport: String, sportEvent: sportEvent) {
        var eventlist: [[String: Any]] = []
        var eventdocumentID = ""
        let db = Firestore.firestore()
        let collection = db.collection("SportEvents")
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                var docID = ""
                for doc in snapshot.documents {
                    let data = doc.data()
                    let sportID = data["sportID"] as? String ?? ""
                    let events = data["events"] as? [[String: Any]] ?? []
                    docID = doc.documentID
                    
                    if sportID == forSport {
                        eventlist = events // got up to here truw
                        eventdocumentID = docID
                        
                        // update that bitch
                        var eventtoadd: [String: Any] = [:]
                        let title = sportEvent.title
                        let subtitle = sportEvent.subtitle
                        let month = sportEvent.month
                        let day = sportEvent.day
                        let year = sportEvent.year
                        let publisheddate = "\(month) \(day), \(year)"
                        let isSpecial = sportEvent.isSpecial
                        let isUpdated = sportEvent.isUpdated
                        let score = sportEvent.score
                        eventtoadd = ["title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate, "score": score, "isSpecial": isSpecial, "isUpdated": isUpdated]
                        eventlist.append(eventtoadd) // here you fat fuck
                        
                        collection.document(eventdocumentID).updateData([
                            "events": eventlist
                        ]) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                    }
                }
                var Bool = true
                for _ in eventlist {
                    Bool = false
                }
                if Bool {
                    var eventtoadd: [String: Any] = [:]
                    let id = UUID().uuidString
                    let title = sportEvent.title
                    let subtitle = sportEvent.subtitle
                    let month = sportEvent.month
                    let day = sportEvent.day
                    let year = sportEvent.year
                    let publisheddate = "\(month) \(day), \(year)"
                    let isSpecial = sportEvent.isSpecial
                    let isUpdated = sportEvent.isUpdated
                    let score = sportEvent.score
                    eventtoadd = ["id": id, "title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate, "score": score, "isSpecial": isSpecial, "isUpdated": isUpdated]

                    collection.addDocument(data: [
                        "sportID": forSport,
                        "events": [eventtoadd]
                    ]) { error in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    func deleteSportEventNews(forSport: String, sportEvent: sportEvent, completion: @escaping (Error?) -> Void) {
        print("deleting event...")
        let db = Firestore.firestore()
        let ref = db.collection("SportEvents").document(sportEvent.documentID)
        
        var eventtoremove: [String: Any] = [:]
        let id = sportEvent.arrayId
        let title = sportEvent.title
        let subtitle = sportEvent.subtitle
        let month = sportEvent.month
        let day = sportEvent.day
        let year = sportEvent.year
        let publisheddate = "\(month) \(day), \(year)"
        let isSpecial = sportEvent.isSpecial
        let isUpdated = sportEvent.isUpdated
        let score = sportEvent.score
        eventtoremove = ["id": id, "title": title, "subtitle": subtitle, "month": month, "day": day, "year": year, "publisheddate": publisheddate, "score": score, "isSpecial": isSpecial, "isUpdated": true]
        
        print("try a remove:")
        print(eventtoremove)
        
        ref.updateData([
            "events": FieldValue.arrayRemove([eventtoremove])
        ]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(error)
            } else {
                print("deleted that shit")
                completion(nil)
            }
        }
    }

    
    func updateSportEventScore(forSport: String, sportEvent: sportEvent) {
        
        let db = Firestore.firestore()
        let ref = db.collection("SportEvents").document(self.documentId)
        
        if let pastSportsEventsIndex = self.pastSportsEvents.firstIndex(where: { $0.arrayId == sportEvent.arrayId }) {
            self.pastSportsEvents[pastSportsEventsIndex] = sportEvent
        }
        if let sportsEventsIndex = self.sportsEvents.firstIndex(where: { $0.arrayId == sportEvent.arrayId }) {
            self.sportsEvents[sportsEventsIndex] = sportEvent
        }
        
        let sportsEvents = self.sportsEvents.map { event in
            
            let id = event.arrayId
            let title = event.title
            let subtitle = event.subtitle
            let month = event.month
            let day = event.day
            let year = event.year
            let publisheddate = "\(month) \(day), \(year)"
            let isSpecial = event.isSpecial
            let isUpdated = event.isUpdated
            let score = event.score
            return ["id": id, "title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate, "score": score, "isSpecial": isSpecial, "isUpdated": isUpdated]
        }
        
        ref.updateData([
            "events": sportsEvents
        ]) { error in
            if let error = error {
                print("ERROR ADDING EVENT: \(error.localizedDescription)")
            }
        }
        
    }
    
//    func getDatePart(event: sportEvent, part: String) -> String {
//        let dateList = event.date.components(separatedBy: " ")
//        if dateList.count == 3 {
//            if part == "month" {
//                return dateList[0]
//            }
//            if part == "day" {
//                return dateList[1]
//            }
//            if part == "year" {
//                return dateList[2]
//            }
//        }
//        return ""
//    }
}

// MARK: all files for all the sports
