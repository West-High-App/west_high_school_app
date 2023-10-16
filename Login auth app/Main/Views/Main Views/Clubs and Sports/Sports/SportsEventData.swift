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
    var title: String
    var subtitle: String
    let month: String
    let day: String
    let year: String
    var date: Date
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
        } else {
            self.date = Date()
        }
    }
}

// TODO: Rewrite flows to allow for snapshot listener
// TODO: get this shit to work

class sportEventManager: ObservableObject {
    @Published var sportsEvents: [ParsedEvent] = []
    @Published var pastSportsEvents: [sportEvent] = []
    @Published var topthree: [sportEvent] = []
    @Published var hasInitialized: Bool = false
    @Published var eventDictionary: [String: [ParsedEvent]] = [:]
    @Published private(set) var isLoading = false
    @Published var pastEventDictionary: [String: [sportEvent]] = [:]
    private var eventSnapshotListener: ListenerRegistration?
    private var pastEventSnapshotListener: ListenerRegistration?
    private var currentSport: sport = sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], editoremails: [], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", favoritedusers: [], eventslink: "", rosterimage: "", rosterimagedata: UIImage(), imagedata: nil, documentID: "NAN", sportid: "SPORT ID", id: UUID())
    private var documentId = ""
    
    static let shared = sportEventManager() // singleton, i love you Per
    
    
    func getData(forSport sport: sport) {
        self.currentSport = sport
        self.getSportsEvent(forSport: "\(sport.sportname) \(sport.sportsteam)")
        self.getPastSportsEvents(forSport: "\(sport.sportname) \(sport.sportsteam)")
    }
    
//    private func getSportsEvents(forSport sport: sport, completion: (([sportEvent]?, Error?) -> Void)? = nil) {
//        guard currentSport == sport else { return }
//        
//        if self.eventDictionary["\(sport.sportname) \(sport.sportsteam)"] == nil {
//            self.isLoading = true
//        }
//        
//        HTMLParser.parseEvents(from: sport.eventslink) { parsedevents, error in
//            
//            // Convert all events
//            let allSportsEvents: [sportEvent] = parsedevents?.compactMap({ parsedEvent in
//                let calendar = Calendar.current
//                let components = calendar.dateComponents([.day, .month, .year], from: parsedEvent.date)
//                
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "MMM" // This will give you the abbreviated month name
//                
//                return sportEvent(
//                    documentID: "NAN",
//                    arrayId: "NAN",
//                    title: parsedEvent.type,
//                    subtitle: parsedEvent.opponent,
//                    month: dateFormatter.string(from: parsedEvent.date),
//                    day: "\(components.day ?? 0)",
//                    year: "\(components.year ?? 0)",
//                    publisheddate: parsedEvent.date.formatted(date: .abbreviated, time: .omitted),
//                    isSpecial: false,
//                    score: [0, 0],
//                    isUpdated: false
//                )
//            }) ?? []
//            
//            if let sportsEvents = parsedevents?.filter({ $0.date > Date() }) {
//                DispatchQueue.main.async {
//                    self.sportsEvents = sportsEvents
//                    self.eventDictionary["\(sport.sportname) \(sport.sportsteam)"] = sportsEvents
//                }
//            }
//            
//            let pastSortsEvents = allSportsEvents.filter({ $0.date < Date() })
//            
//            for event in pastSortsEvents {
//                if !self.pastSportsEvents.contains(where: {
//                    $0.date == event.date &&
//                    $0.title == event.title &&
//                    $0.subtitle == event.subtitle
//                }) {
//                    print("sportEvent: \(event.title); \(event.subtitle)")
//                    print("")
//                    self.createSportEvent(forSport: "\(sport.sportname) \(sport.sportsteam)", sportEvent: event)
//                }
//            }
//            
//            if let completion {
//                completion(allSportsEvents, error)
//            }
//            DispatchQueue.main.async {
//                self.isLoading = false
//            }
//            /* DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) {
//                self.getSportsEvents(forSport: sport)
//            } */ // MARK: this is duplicating the elements in the list and slowing down the app significantly
//        }
//    }
//     
    func getSportsEvent(forSport: String, completion: (([sportEvent]?, Error?) -> Void)? = nil) {
        if eventSnapshotListener != nil {
            eventSnapshotListener?.remove()
            self.eventSnapshotListener = nil
        }
        
        let db = Firestore.firestore()
        let collection = db.collection("SportEvents").document(forSport.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? forSport.replacingOccurrences(of: " ", with: "%20"))
        
        self.eventSnapshotListener = collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                if let completion {
                    completion(nil, error)
                }
                return
            }
            
            if let snapshot = snapshot {
                let documentID = snapshot.documentID
                self.documentId = documentID
                guard let upcomingArrayDict = snapshot.get("upcommingevents") as? [[String : Any]] else { return }
                let upcomingArray = upcomingArrayDict.map { event in
                    let type = event["type"] as? String ?? UUID().uuidString
                    let opponent = event["opponent"] as? String ?? ""
                    let location = event["location"] as? String ?? ""
                    let isTBD = event["isTBD"] as? Bool ?? false
                    let comments = event["comments"] as? String ?? ""
                    let date = (event["date"] as? Timestamp)?.dateValue() ?? Date()
                    
                    let newEvent = ParsedEvent(date: date, isTBD: isTBD, type: type, opponent: opponent, location: location, comments: comments)
                    return newEvent
                }
                
                self.eventDictionary[forSport] = upcomingArray.sorted(by: {
                    $0.date.compare($1.date) == .orderedAscending
                })
                
                self.sportsEvents = upcomingArray.sorted(by: {
                    $0.date.compare($1.date) == .orderedAscending
                })
            }
        }
    }
    
    private func getPastSportsEvents(forSport: String, completion: (([sportEvent]?, Error?) -> Void)? = nil) {
        if pastEventSnapshotListener != nil {
            pastEventSnapshotListener?.remove()
            self.pastEventSnapshotListener = nil
        }
        
        let db = Firestore.firestore()
        let collection = db.collection("SportEvents").document(forSport.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? forSport.replacingOccurrences(of: " ", with: "%20"))
        
        self.pastEventSnapshotListener = collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                if let completion {
                    completion(nil, error)
                }
                return
            }
            
            if let snapshot = snapshot {
                let document = snapshot
                guard let data = document.data() else { return }
                let events = data["pastevents"] as? [[String: Any]] ?? []
                let documentID = document.documentID
                
                self.documentId = document.documentID
                let returnValue: [sportEvent] = events.map { event in
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
                    return newEvent
                }
                
//                            self.pastEventDictionary[forSport] = returnValue
                self.pastEventDictionary[forSport] = returnValue.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
//                            self.pastEventDictionary[forSport] = self.pastEventDictionary[forSport]?.reversed()
//                            self.pastSportsEvents = returnValue
                self.pastSportsEvents = returnValue.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
                print("got past sports events")
                print(self.pastSportsEvents)
                let completionValue = self.pastSportsEvents
                
                if let completion {
                    completion(completionValue, nil)
                }

            } else {
                let returnValue: [sportEvent] = []
//                            self.pastEventDictionary[forSport] = returnValue
                self.pastEventDictionary[forSport] = returnValue.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
//                            self.pastEventDictionary[forSport] = self.pastEventDictionary[forSport]?.reversed()
//                            self.pastSportsEvents = returnValue
                self.pastSportsEvents = returnValue.sorted(by: {
                    $0.date.compare($1.date) == .orderedDescending
                })
                print("got past sports events")
                print(self.pastSportsEvents)
                let completionValue = self.pastSportsEvents
                
                if let completion {
                    completion(completionValue, nil)
                }
            }
        }
    }
    
    func createSportEvent(forSport: String, sportEvent: sportEvent) {
        var eventdocumentID = ""
        let db = Firestore.firestore()
        let collection = db.collection("SportEvents")
        let documentID = forSport.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? forSport
        
        let uploadEvent = [sportEvent].map { event in
            
            let id = UUID().uuidString
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
        
        let sportsEvents: [[String : Any]] = self.pastSportsEvents.map { event in
            
            let id = UUID().uuidString
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
        } + uploadEvent
        
        collection.document(documentID).setData([
            "sportID": forSport,
            "pastevents": FieldValue.arrayUnion(uploadEvent)
        ], merge: true) { error in
            if let error = error {
                print("ERROR ADDING EVENT: \(error.localizedDescription)")
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
            "pastevents": FieldValue.arrayRemove([eventtoremove])
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
        
        guard let pastSportEventsIndex = self.pastSportsEvents.firstIndex(where: { $0.arrayId == sportEvent.arrayId }) else {
            return
        }
        
        let sportsEvents = self.pastSportsEvents.map { event in
            let setEvent = (event.arrayId == sportEvent.arrayId) ? sportEvent : event
            
            let id = setEvent.arrayId
            let title = setEvent.title
            let subtitle = setEvent.subtitle
            let month = setEvent.month
            let day = setEvent.day
            let year = setEvent.year
            let publisheddate = "\(month) \(day), \(year)"
            let isSpecial = setEvent.isSpecial
            let isUpdated = setEvent.isUpdated
            let score = setEvent.score
            return ["id": id, "title": title, "subtitle": subtitle, "month" : month, "day" : day, "year" : year, "publisheddate" : publisheddate, "score": score, "isSpecial": isSpecial, "isUpdated": isUpdated]
        }
        
        ref.updateData([
            "pastevents": sportsEvents
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
