//
//  SportsNewsData.swift
//  West App
//
//  Created by August Andersen on 7/6/23. boom
//

import Foundation
import Firebase
import UIKit

struct sportNews: Identifiable, Equatable {
    var newstitle: String
    var newsimage: [String]
    var newsdescription: String
    var newsdate: String
    var newsdateSwift: Date
    var author: String
    var isApproved: Bool
    var imagedata: [UIImage] // , imagedata: []
    var id = UUID()
    let documentID: String
}

extension Array<sportNews> {
    func sortedByDate() -> Self {
        self.sorted { first, second in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let firstDate = dateFormatter.date(from: first.newsdate) ?? Date()
            let secondDate = dateFormatter.date(from: second.newsdate) ?? Date()
            return firstDate > secondDate
        }
    }
}

class sportsNewslist: ObservableObject {
    static let shared = sportsNewslist()
    
    @Published private var allsportsnewslistUnsorted: [sportNews] = [sportNews(
        newstitle: "Varsity Football Team Wins Regional Championship",
        newsimage: ["football"],
        newsdescription: "The Lincoln High School varsity football team emerged victorious in the regional championship, securing their spot in the state finals.",
        newsdate: "Nov 15, 2022", newsdateSwift: Date(),
        author: "Emily Thompson", isApproved: false, imagedata: [], documentID: "NAN")]
    
    var allsportsnewslist: [sportNews] {
        allsportsnewslistUnsorted.sortedByDate()
    }
    private let fetchLimit = 30
    private var lastDocument: DocumentSnapshot?
    @Published private(set) var allDocsLoaded = false
    @Published private(set) var allPendingDocsLoaded = false
    
    init() {
        connectSportsNews(getPending: true) // connect pending
        connectSportsNews(getPending: false) // connect approved
    }
    
    private func handleFirstore(_ templist: [sportNews]) {
        DispatchQueue.main.async {
            self.allsportsnewslistUnsorted.removeAll(where: { $0.documentID == "NAN" })
            for temp in templist {
                if let index = self.allsportsnewslistUnsorted.firstIndex(where: { $0.documentID == temp.documentID }) {
                    self.allsportsnewslistUnsorted[index].imagedata = temp.imagedata
                    self.allsportsnewslistUnsorted[index].newsdate = temp.newsdate
                    self.allsportsnewslistUnsorted[index].newsdescription = temp.newsdescription
                    self.allsportsnewslistUnsorted[index].newstitle = temp.newstitle
                    self.allsportsnewslistUnsorted[index].author = temp.author
                    self.allsportsnewslistUnsorted[index].newsimage = temp.newsimage
                    self.allsportsnewslistUnsorted[index].isApproved = temp.isApproved
                } else {
                    self.allsportsnewslistUnsorted.append(temp)
                }
                if temp == templist.last {
                    if let docId = templist.last?.documentID, let endIndex = self.allsportsnewslistUnsorted.firstIndex(where: { $0.documentID == docId }) {
                        let startIndex = endIndex-templist.count
                        
                        for (index, element) in self.allsportsnewslistUnsorted.enumerated() {
                            if startIndex < index, index <= endIndex, !templist.contains(where: { $0.documentID == element.documentID }) {
                                self.allsportsnewslistUnsorted.removeAll(where: { $0.documentID == element.documentID }) // Remove if not on server
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getMoreSportsNews(getPending: Bool) {
        guard let lastDocument else { return }
        
        let db = Firestore.firestore()
        let collection = db.collection("SportsNews")
        
        collection
            .order(by: "newsdateSwift", descending: true)
            .whereField("isApproved", isEqualTo: !getPending) // get approved dpcs if getPending is false or pending if getPending is true
            .limit(to: self.fetchLimit)
            .start(afterDocument: lastDocument)
            .getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let snapshot = snapshot {
                var templist: [sportNews] = [] {
                    didSet {
                        if templist.count == snapshot.documents.count {
                            self.handleFirstore(templist)
                        }
                    }
                }
                
                self.lastDocument = snapshot.documents.last
                for document in snapshot.documents {
                    let data = document.data()
                    let newstitle = data["newstitle"] as? String ?? ""
                    let newsimage = data["newsimage"] as? [String] ?? []
                    let newsdescription = data["newsdescription"] as? String ?? ""
                    let newsdate = data["newsdate"] as? String ?? ""
                    let newsdateSwift = (data["newsdateSwift"] as? Timestamp)?.dateValue() ?? Date()
                    let author = data["author"] as? String ?? ""
                    let isApproved = data["isApproved"] as? Bool ?? false
                    let documentID = document.documentID
                    var imagedata: [UIImage] = []
                    for file in newsimage {
                        imageManager().getImage(fileName: file) { image in
                            if let image = image {
                                imagedata = [image]
                                print("SPORT NEWS IMAGE FOUND")
                                print(imagedata)
                                print("1^")
                            }
                            let sportnews = sportNews(newstitle: newstitle, newsimage: newsimage, newsdescription: newsdescription, newsdate: newsdate, newsdateSwift: newsdateSwift, author: author, isApproved: isApproved, imagedata: imagedata, documentID: documentID)
                            templist.append(sportnews)
                        }
                    }
                }
                if snapshot.documents.count < self.fetchLimit {
                    if getPending {
                        self.allPendingDocsLoaded = true
                    } else {
                        self.allDocsLoaded = true
                    }
                }
            }
        }
    }
    
    func connectSportsNews(getPending: Bool) {
        let db = Firestore.firestore()
        let collection = db.collection("SportsNews")
        
        collection
            .order(by: "newsdateSwift", descending: true)
            .whereField("isApproved", isEqualTo: !getPending) // get approved dpcs if getPending is false or pending if getPending is true
            .limit(to: self.fetchLimit)
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let snapshot = snapshot {
                var templist: [sportNews] = [] {
                    didSet {
                        if templist.count == snapshot.documents.count {
                            self.handleFirstore(templist)
                        }
                    }
                }
                if self.lastDocument == nil {
                    self.lastDocument = snapshot.documents.last
                }
                for document in snapshot.documents {
                    let data = document.data()
                    let newstitle = data["newstitle"] as? String ?? ""
                    let newsimage = data["newsimage"] as? [String] ?? []
                    let newsdescription = data["newsdescription"] as? String ?? ""
                    let newsdate = data["newsdate"] as? String ?? ""
                    let newsdateSwift = (data["newsdateSwift"] as? Timestamp)?.dateValue() ?? Date()
                    let author = data["author"] as? String ?? ""
                    let isApproved = data["isApproved"] as? Bool ?? false
                    let documentID = document.documentID
                    var imagedata: [UIImage] = []
                    for file in newsimage {
                        imageManager().getImage(fileName: file) { image in
                            if let image = image {
                                imagedata = [image]
                                print("SPORT NEWS IMAGE FOUND")
                                print(imagedata)
                                print("1^")
                            }
                            let sportnews = sportNews(newstitle: newstitle, newsimage: newsimage, newsdescription: newsdescription, newsdate: newsdate, newsdateSwift: newsdateSwift, author: author, isApproved: isApproved, imagedata: imagedata, documentID: documentID)
                            templist.append(sportnews)
                        }
                    }
                }
                if snapshot.documents.count < self.fetchLimit {
                    if getPending {
                        self.allPendingDocsLoaded = true
                    } else {
                        self.allDocsLoaded = true
                    }
                }
            }
        }
    }
    
    func updateSportNews(sportNews: sportNews, completion: @escaping (Error?) -> Void) {
        print("Creating new sports news...")
        let db = Firestore.firestore()
        db.collection("SportsNews").document(sportNews.documentID).setData([
            "newstitle": sportNews.newstitle,
            "newsimage": sportNews.newsimage,
            "newsdescription": sportNews.newsdescription,
            "newsdate": sportNews.newsdate,
            "newsdateSwift": sportNews.newsdateSwift,
            "author": sportNews.author,
            "isApproved": sportNews.isApproved
        ]) { error in
            completion(error)
        }
        print("Sport news created with ID: \(sportNews.documentID)")
    }
    
    func createSportNews(sportNews: sportNews, completion: @escaping (Error?) -> Void) {
        print("Creating new sports news...")
        let db = Firestore.firestore()
        db.collection("SportsNews").addDocument(data: [
            "newstitle": sportNews.newstitle,
            "newsimage": sportNews.newsimage,
            "newsdescription": sportNews.newsdescription,
            "newsdate": sportNews.newsdate,
            "newsdateSwift": sportNews.newsdateSwift,
            "author": sportNews.author,
            "isApproved": sportNews.isApproved
        ]) { error in
            completion(error)
        }
        print("Sport news created with ID: \(sportNews.documentID)")
    }
    
    func deleteSportNews(sportNews: sportNews, completion: @escaping (Error?) -> Void) {
        print("Deleting sport news with ID: \(sportNews.documentID)")
        let db = Firestore.firestore()
        let ref = db.collection("SportsNews").document(sportNews.documentID)
        ref.delete { error in
            completion(error)
        }
        print("Article deleted")
    }
    
}

struct clubNews: Identifiable, Equatable {
    var newstitle: String
    var newsimage: [String]
    var newsdescription: String
    var newsdate: String
    var newsdateSwift: Date
    var author: String
    var isApproved: Bool
    var id = UUID()
    let documentID: String
    var imagedata: [UIImage] // , imagedata: []
}

extension Array<clubNews> {
    func sortedByDate() -> Self {
        self.sorted { first, second in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let firstDate = dateFormatter.date(from: first.newsdate) ?? Date()
            let secondDate = dateFormatter.date(from: second.newsdate) ?? Date()
            return firstDate > secondDate
        }
    }
}

class clubsNewslist: ObservableObject{
    @Published private var allclubsnewslistUnsorted = [clubNews(
        newstitle: "hardcoded title",
        newsimage: ["roboticsclub"],
        newsdescription: "this is a hardcoded example, is not from firebase and should never be shwon on the app", newsdate: "Apr 1, 2023", newsdateSwift: Date(),
        author: "aiden jamae lee lmfao remember",
        isApproved: false,
        documentID: "NAN", imagedata: [])]
    
    var allclubsnewslist: [clubNews] {
        allclubsnewslistUnsorted.sortedByDate()
    }
    private let fetchLimit = 30
    private var lastDocument: DocumentSnapshot?
    @Published private(set) var allDocsLoaded = false
    @Published private(set) var allPendingDocsLoaded = false
    
    static let shared = clubsNewslist()
    
    init() {
        connectClubNews(getPending: false)
        connectClubNews(getPending: true)
    }
    
    private func handleFirestore(_ templist: [clubNews]) {
        DispatchQueue.main.async {
            self.allclubsnewslistUnsorted.removeAll(where: { $0.documentID == "NAN" })
            for temp in templist {
                if let index = self.allclubsnewslistUnsorted.firstIndex(where: { $0.documentID == temp.documentID }) {
                    self.allclubsnewslistUnsorted[index].imagedata = temp.imagedata
                    self.allclubsnewslistUnsorted[index].newsdate = temp.newsdate
                    self.allclubsnewslistUnsorted[index].newsdescription = temp.newsdescription
                    self.allclubsnewslistUnsorted[index].newstitle = temp.newstitle
                    self.allclubsnewslistUnsorted[index].author = temp.author
                    self.allclubsnewslistUnsorted[index].newsimage = temp.newsimage
                    self.allclubsnewslistUnsorted[index].isApproved = temp.isApproved
                } else {
                    self.allclubsnewslistUnsorted.append(temp)
                }
                if temp.documentID == templist.last?.documentID {
                    if let docId = templist.last?.documentID, let endIndex = self.allclubsnewslistUnsorted.firstIndex(where: { $0.documentID == docId }) {
                        let startIndex = endIndex-templist.count
                        
                        for (index, element) in self.allclubsnewslistUnsorted.enumerated() {
                            if startIndex < index, index <= endIndex, !templist.contains(where: { $0.documentID == element.documentID }) {
                                self.allclubsnewslistUnsorted.removeAll(where: { $0.documentID == element.documentID }) // Remove if not on server
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getMoreClubNews(getPending: Bool) {
        guard let lastDocument else { return }
        
        let db = Firestore.firestore()
        let collection = db.collection("ClubNews")
        
        collection
            .order(by: "newsdateSwift", descending: true)
            .whereField("isApproved", isEqualTo: !getPending) // get approved dpcs if getPending is false or pending if getPending is true
            .limit(to: self.fetchLimit)
            .start(afterDocument: lastDocument)
            .getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let snapshot = snapshot {
                var templist: [clubNews] = [] {
                    didSet {
                        if templist.count == snapshot.documents.count {
                            self.handleFirestore(templist)
                        }
                    }
                }
                
                self.lastDocument = snapshot.documents.last
                for document in snapshot.documents {
                    let data = document.data()
                    let newstitle = data["newstitle"] as? String ?? ""
                    let newsimage = data["newsimage"] as? [String] ?? []
                    let newsdescription = data["newsdescription"] as? String ?? ""
                    let newsdate = data["newsdate"] as? String ?? ""
                    let newsdateSwift = (data["newsdateSwift"] as? Timestamp)?.dateValue() ?? Date()
                    let author = data["author"] as? String ?? ""
                    let isApproved = data["isApproved"] as? Bool ?? false
                    let documentID = document.documentID
                    var imagedata: [UIImage] = []
                    for file in newsimage {
                        imageManager().getImage(fileName: file) { image in
                            if let image = image {
                                imagedata.append(image)
                            }
                            let clubnews = clubNews(newstitle: newstitle, newsimage: newsimage, newsdescription: newsdescription, newsdate: newsdate, newsdateSwift: newsdateSwift, author: author, isApproved: isApproved, documentID: documentID, imagedata: imagedata)
                            templist.append(clubnews)
                        }
                    }
                }
                if snapshot.documents.count < self.fetchLimit {
                    if getPending {
                        self.allPendingDocsLoaded = true
                    } else {
                        self.allDocsLoaded = true
                    }
                }
            }
        }
    }
    
    func connectClubNews(getPending: Bool) {
        let db = Firestore.firestore()
        let collection = db.collection("ClubNews")
        
        collection
            .order(by: "newsdateSwift", descending: true)
            .whereField("isApproved", isEqualTo: !getPending) // get approved dpcs if getPending is false or pending if getPending is true
            .limit(to: self.fetchLimit)
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let snapshot = snapshot {
                var templist: [clubNews] = [] {
                    didSet {
                        if templist.count == snapshot.documents.count {
                            self.handleFirestore(templist)
                        }
                    }
                }
                
                
                if self.lastDocument == nil {
                    self.lastDocument = snapshot.documents.last
                }
                for document in snapshot.documents {
                    let data = document.data()
                    let newstitle = data["newstitle"] as? String ?? ""
                    let newsimage = data["newsimage"] as? [String] ?? []
                    let newsdescription = data["newsdescription"] as? String ?? ""
                    let newsdate = data["newsdate"] as? String ?? ""
                    let newsdateSwift = (data["newsdateSwift"] as? Timestamp)?.dateValue() ?? Date()
                    let author = data["author"] as? String ?? ""
                    let isApproved = data["isApproved"] as? Bool ?? false
                    let documentID = document.documentID
                    var imagedata: [UIImage] = []
                    for file in newsimage {
                        imageManager().getImage(fileName: file) { image in
                            if let image = image {
                                imagedata.append(image)
                            }
                            let clubnews = clubNews(newstitle: newstitle, newsimage: newsimage, newsdescription: newsdescription, newsdate: newsdate, newsdateSwift: newsdateSwift, author: author, isApproved: isApproved, documentID: documentID, imagedata: imagedata)
                            templist.append(clubnews)
                        }
                    }
                }
                if snapshot.documents.count < self.fetchLimit {
                    if getPending {
                        self.allPendingDocsLoaded = true
                    } else {
                        self.allDocsLoaded = true
                    }
                }
            }
        }
    }
    
    func updateClubNews(clubNews: clubNews, completion: @escaping (Error?) -> Void) {
        print("Updating new clubs news...")
        let db = Firestore.firestore()
        db.collection("ClubNews").document(clubNews.documentID).setData([
            "newstitle": clubNews.newstitle,
            "newsimage": clubNews.newsimage,
            "newsdescription": clubNews.newsdescription,
            "newsdate": clubNews.newsdate,
            "newsdateSwift": clubNews.newsdateSwift,
            "isApproved": clubNews.isApproved,
            "author": clubNews.author
        ]) { error in
            completion(error)
        }
        print("Club news created with ID: \(clubNews.documentID)")
    }
    
    func createClubNews(clubNews: clubNews, completion: @escaping (Error?) -> Void) {
        print("Creating new clubs news...")
        let db = Firestore.firestore()
        db.collection("ClubNews").addDocument(data: [
            "newstitle": clubNews.newstitle,
            "newsimage": clubNews.newsimage,
            "newsdescription": clubNews.newsdescription,
            "newsdate": clubNews.newsdate,
            "newsdateSwift": clubNews.newsdateSwift,
            "isApproved": clubNews.isApproved,
            "author": clubNews.author
        ]) { error in
            completion(error)
        }
        print("Club news created with ID: \(clubNews.documentID)")
    }
    
    func deleteClubNews(clubNews: clubNews, completion: @escaping (Error?) -> Void) {
        print("Deleting club news with ID: \(clubNews.documentID)")
        let db = Firestore.firestore()
        let ref = db.collection("ClubNews").document(clubNews.documentID)
        ref.delete { error in
            completion(error)
        }
        print("Article deleted :)")
    }
    
}
