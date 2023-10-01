//
//  NewsTopsData.swift
//  West App
//
//  Created by Aiden Lee on 5/20/23.
//

import SwiftUI
import Firebase

struct Newstab: Identifiable, Equatable {
    let id = UUID()
    let documentID: String // if ur basing it off my data you need to add documentID
    var title:String
    var publisheddate:String // format: Jun 15, 2023, Feb 28, 1998, etc.
    var description: String
}

extension Array<Newstab> {
    func sortedByDate() -> Self {
        self.sorted { first, second in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
            let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
            return firstDate > secondDate
        }
    }
}

class Newslist: ObservableObject {
    @Published private var topfiveUnsorted: [Newstab] = [Newstab(documentID: "TestID", title: "Loading...", publisheddate: "Loading...", description: "Loading...")]
    var topfive: [Newstab] {
        topfiveUnsorted.sortedByDate()
    }
    
    static let shared = Newslist()
    
    init() {
        getAnnouncements()
    }
    
    
    func getAnnouncements() {
        let db = Firestore.firestore()
        let collection = db.collection("Announcements")
        collection.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            if let snapshot = snapshot {
                var templist: [Newstab] = [] {
                    didSet {
                        if templist.count == snapshot.count {
                            DispatchQueue.main.async {
                                for temp in templist {
                                    if let index = self.topfiveUnsorted.firstIndex(where: { $0.documentID == temp.documentID }) {
                                        self.topfiveUnsorted[index].publisheddate = temp.publisheddate
                                        self.topfiveUnsorted[index].title = temp.title
                                        self.topfiveUnsorted[index].description = temp.description
                                    } else {
                                        self.topfiveUnsorted.append(temp)
                                    }
                                    if temp == templist.last {
                                        for element in self.topfiveUnsorted {
                                            if !templist.contains(where: { $0.documentID == element.documentID }) {
                                                self.topfiveUnsorted.removeAll(where: { $0.documentID == element.documentID }) // Remove if not on server
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
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let publisheddate = data["publisheddate"] as? String ?? ""
                    let newsimagename = data["newsimagename"] as? String ?? ""
                    let documentID = document.documentID
                    let newstab = Newstab(documentID: documentID, title: title, publisheddate: publisheddate, description: description)
                    templist.append(newstab)  // Add the newstab to the temporary array
                }
            }
        }
    }

    func createAnnouncement(announcement: Newstab, completion: @escaping (Error?) -> Void) {
        print("Creating new announcement...")
        let db = Firestore.firestore()
        db.collection("Announcements").addDocument(data: [
            "title": announcement.title,
            "description": announcement.description,
            "publisheddate": announcement.publisheddate,
        ]) { error in
            completion(error)
        }
        print("Announcement created with documentID: \(announcement.documentID)")
    }

    func deleteAnnouncement(announcement: Newstab, completion: @escaping (Error?) -> Void) { //
        print("Deleting announcement with documentID: \(announcement.documentID)...")
        let db = Firestore.firestore()
        let eventRef = db.collection("Announcements").document(announcement.documentID)
        
        eventRef.delete { error in
            completion(error)
        }
        print("Announcement deleted")
    }
}
