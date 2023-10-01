//
//  SportsNewsData.swift
//  West App
//
//  Created by August Andersen on 7/6/23. boom
//

import Foundation
import Firebase

struct sportNews: Identifiable {
    let newstitle: String
    let newsimage: [String]
    let newsdescription: String
    let newsdate: String
    let author: String
    var imagedata: [UIImage] // , imagedata: []
    var id = UUID()
    let documentID: String
}

class sportsNewslist: ObservableObject {
    static let shared = sportsNewslist()
    
    @Published var allsportsnewslist : [sportNews] = [sportNews(
        newstitle: "Varsity Football Team Wins Regional Championship",
        newsimage: ["football"],
        newsdescription: "The Lincoln High School varsity football team emerged victorious in the regional championship, securing their spot in the state finals.",
        newsdate: "Nov 15, 2022",
        author: "Emily Thompson", imagedata: [], documentID: "NAN")]
    init() {
        getSportsNews()
    }
    
    func getSportsNews() {
        let db = Firestore.firestore()
        let collection = db.collection("SportsNews")
        
        collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let snapshot = snapshot {
                var templist: [sportNews] = [] {
                    didSet {
                        if templist.count == snapshot.count {
                            DispatchQueue.main.async {
                                self.allsportsnewslist = templist.sorted { first, second in
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "MMM dd, yyyy"
                                    let firstDate = dateFormatter.date(from: first.newsdate) ?? Date()
                                    let secondDate = dateFormatter.date(from: second.newsdate) ?? Date()
                                    return firstDate > secondDate
                                }
                            }
                        }
                    }
                }
                for document in snapshot.documents {
                    let data = document.data()
                    let newstitle = data["newstitle"] as? String ?? ""
                    let newsimage = data["newsimage"] as? [String] ?? []
                    let newsdescription = data["newsdescription"] as? String ?? ""
                    let newsdate = data["newsdate"] as? String ?? ""
                    let author = data["author"] as? String ?? ""
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
                            let sportnews = sportNews(newstitle: newstitle, newsimage: newsimage, newsdescription: newsdescription, newsdate: newsdate, author: author, imagedata: imagedata, documentID: documentID)
                            templist.append(sportnews)
                        }
                    }
                }
            }
        }
    }
    
    func createSportNews(sportNews: sportNews, completion: @escaping (Error?) -> Void) {
        print("Creating new sports news...")
        let db = Firestore.firestore()
        db.collection("SportsNews").addDocument(data: [
            "newstitle": sportNews.newstitle,
            "newsimage": sportNews.newsimage,
            "newsdescription": sportNews.newsdescription,
            "newsdate": sportNews.newsdate,
            "author": sportNews.author
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

struct clubNews: Identifiable {
    let newstitle: String
    let newsimage: [String]
    let newsdescription: String
    let newsdate: String
    let author: String
    var id = UUID()
    let documentID: String
    var imagedata: [UIImage] // , imagedata: []
}

class clubsNewslist: ObservableObject{
    @Published var allclubsnewslist = [clubNews(
        newstitle: "hardcoded title",
        newsimage: ["roboticsclub"],
        newsdescription: "this is a hardcoded example, is not from firebase and should never be shwon on the app", newsdate: "Apr 1, 2023",
        author: "aiden jamae lee lmfao remember",
        documentID: "NAN", imagedata: [])]
    
    static let shared = clubsNewslist()
    
    init() {
        getClubNews()
    }
    
    func getClubNews() {
        let db = Firestore.firestore()
        let collection = db.collection("ClubNews")
        
        collection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let snapshot = snapshot {
                var templist: [clubNews] = [] {
                    didSet {
                        if templist.count == snapshot.count {
                            DispatchQueue.main.async {
                                self.allclubsnewslist = templist.sorted { first, second in
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "MMM dd, yyyy"
                                    let firstDate = dateFormatter.date(from: first.newsdate) ?? Date()
                                    let secondDate = dateFormatter.date(from: second.newsdate) ?? Date()
                                    return firstDate > secondDate
                                }
                            }
                        }
                    }
                }
                for document in snapshot.documents {
                    let data = document.data()
                    let newstitle = data["newstitle"] as? String ?? ""
                    let newsimage = data["newsimage"] as? [String] ?? []
                    let newsdescription = data["newsdescription"] as? String ?? ""
                    let newsdate = data["newsdate"] as? String ?? ""
                    let author = data["author"] as? String ?? ""
                    let documentID = document.documentID
                    var imagedata: [UIImage] = []
                    for file in newsimage {
                        imageManager().getImage(fileName: file) { image in
                            if let image = image {
                                imagedata.append(image)
                            }
                            let clubnews = clubNews(newstitle: newstitle, newsimage: newsimage, newsdescription: newsdescription, newsdate: newsdate, author: author, documentID: documentID, imagedata: imagedata)
                            templist.append(clubnews)
                        }
                    }
                    
                }
            }
        }
    }
    
    func createClubNews(clubNews: clubNews, completion: @escaping (Error?) -> Void) {
        print("Creating new clubs news...")
        let db = Firestore.firestore()
        db.collection("ClubNews").addDocument(data: [
            "newstitle": clubNews.newstitle,
            "newsimage": clubNews.newsimage,
            "newsdescription": clubNews.newsdescription,
            "newsdate": clubNews.newsdate,
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
