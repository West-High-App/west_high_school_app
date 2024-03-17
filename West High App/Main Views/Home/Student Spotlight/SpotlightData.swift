//
//  StudentSpotLightData.swift
//  West App
//
//  Created by Aiden Lee on 5/29/23.
//

import SwiftUI
import Firebase

struct studentAchievement: Identifiable, Equatable{
    let id = UUID()
    let documentID: String
    var achievementtitle:String
    var achievementdescription:String // localizedstringkey??
    var articleauthor:String
    var publisheddate:String
    var date:Date
    var images:[String]
    var isApproved: Bool
    var writerEmail: String
    var imagedata: [UIImage] // , imagedata: []
 }

extension Array<studentAchievement> {
    func sortedByDate() -> Self {
        return self.sorted { first, second in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
            let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
            return firstDate > secondDate
        }
    }
}

class studentachievementlist: ObservableObject{
    
    static let shared = studentachievementlist()
    
    @Published var allstudentachievementlistUnsorted: [studentAchievement] = []
    @Published private var allpendingstudentachievementlistUnsorted: [studentAchievement] = []
    var allstudentachievementlist: [studentAchievement] {
        (allstudentachievementlistUnsorted + allpendingstudentachievementlistUnsorted).sortedByDate()
    }
    @Published var newstitlearray: [studentAchievement] = []
    @Published var hasLoaded = false

    @StateObject var imagemanager = imageManager()
    private let fetchLimit = 20
    private var lastDocument: DocumentSnapshot?
    @Published private(set) var allDocsLoaded = false
    @Published private(set) var allPendingDocsLoaded = true
    
    init() {
        connectAchievements()
        connectPendingAchievements()
    }
    
    private func handleFirestore(_ templist: [studentAchievement]) {
        DispatchQueue.main.async {
            for temp in templist {
                if let index = self.allstudentachievementlistUnsorted.firstIndex(where: { $0.documentID == temp.documentID }) {
                    self.allstudentachievementlistUnsorted[index].achievementdescription = temp.achievementdescription
                    self.allstudentachievementlistUnsorted[index].achievementtitle = temp.achievementtitle
                    self.allstudentachievementlistUnsorted[index].articleauthor = temp.articleauthor
                    self.allstudentachievementlistUnsorted[index].images = temp.images
                    self.allstudentachievementlistUnsorted[index].publisheddate = temp.publisheddate
                    self.allstudentachievementlistUnsorted[index].isApproved = temp.isApproved
                    self.allstudentachievementlistUnsorted[index].imagedata = temp.imagedata
                    self.allstudentachievementlistUnsorted[index].writerEmail = temp.writerEmail
                } else {
                    self.allstudentachievementlistUnsorted.append(temp)
                }
                if temp == templist.last {
                    for (index, studentachievement) in self.allstudentachievementlistUnsorted.enumerated() {
                        if let docId = self.lastDocument?.documentID, let endIndex = self.allstudentachievementlistUnsorted.firstIndex(where: { $0.documentID == docId }) {
                            let startIndex = endIndex-templist.count
                            if startIndex <= index, index <= endIndex, !templist.contains(where: { $0.documentID == studentachievement.documentID }) {
                                self.allstudentachievementlistUnsorted.removeAll(where: { $0.documentID == studentachievement.documentID }) // Remove if not on server
                            }
                        }
                    }
                }
            }
            print(self.allstudentachievementlistUnsorted.count)
            self.hasLoaded = true
        }
    }
    
    func getMoreAchievements() {
        guard let lastDocument else { return }
        
        print("LOADING ACHIEVMENTS LIST")
        let db = Firestore.firestore()
        let collection = db.collection("StudentAchievements")
        
        collection
            .order(by: "date", descending: true)
            .whereField("isApproved", isEqualTo: true)
            .limit(to: fetchLimit)
            .start(afterDocument: lastDocument)
            .getDocuments { snapshot, error in
                print("FIREBASE READ")
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let snapshot = snapshot {
                    self.lastDocument = snapshot.documents.last
                    let templist: [studentAchievement] = snapshot.documents.map { document in
                        let data = document.data()
                        let achievementtitle = data["achievementtitle"] as? String ?? ""
                        let achievementdescription = data["achievementdescription"] as? String ?? ""
                        let articleauthor = data["articleauthor"] as? String ?? ""
                        let publisheddate = data["publisheddate"] as? String ?? ""
                        let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                        let images = data["images"] as? [String] ?? []
                        let isApproved = data["isApproved"] as? Bool ?? false
                        let writerEmail = data["writerEmail"] as? String ?? ""
                        let documentID = document.documentID
                        
                        var imagedata: [UIImage] = []
                        
                        //                    for file in images {
                        //                        imageManager().getImage(fileName: file) { image in
                        //                            if let image = image {
                        //                                imagedata.append(image)
                        //                            }
                        //                        }
                        //                    }
                        
                        let achievement = studentAchievement(documentID: documentID, achievementtitle: achievementtitle, achievementdescription: achievementdescription, articleauthor: articleauthor, publisheddate: publisheddate, date: date, images: images, isApproved: isApproved, writerEmail: writerEmail, imagedata: imagedata)
                        return achievement
                        
                    }
                    self.handleFirestore(templist)
                    if snapshot.documents.count < self.fetchLimit {
                        self.allDocsLoaded = true
                    }
                }
            }
    }
    
    func connectAchievements() {
        print("LOADING ACHIEVMENTS LIST")
        let db = Firestore.firestore()
        let collection = db.collection("StudentAchievements")
        
        collection
            .order(by: "date", descending: true)
            .whereField("isApproved", isEqualTo: true)
            .limit(to: fetchLimit)
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                
                if self.lastDocument == nil {
                    self.lastDocument = snapshot.documents.last
                }
                let templist: [studentAchievement] = snapshot.documents.map { document in
                    let data = document.data()
                    let achievementtitle = data["achievementtitle"] as? String ?? ""
                    let achievementdescription = data["achievementdescription"] as? String ?? ""
                    let articleauthor = data["articleauthor"] as? String ?? ""
                    let publisheddate = data["publisheddate"] as? String ?? ""
                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                    let images = data["images"] as? [String] ?? []
                    let isApproved = data["isApproved"] as? Bool ?? false
                    let writerEmail = data["writerEmail"] as? String ?? ""
                    let documentID = document.documentID
                    
                    var imagedata: [UIImage] = []
                    for file in images {
                        let _ = imageManager().getImage(fileName: file) { image in
                            if let image = image {
                                imagedata.append(image)
                            }
                        }
                    }
                    
                    let achievement = studentAchievement(documentID: documentID, achievementtitle: achievementtitle, achievementdescription: achievementdescription, articleauthor: articleauthor, publisheddate: publisheddate, date: date, images: images, isApproved: isApproved, writerEmail: writerEmail, imagedata: imagedata)
                    return achievement
                }
                self.handleFirestore(templist)
                if snapshot.documents.count < self.fetchLimit {
                    self.allDocsLoaded = true
                }
            }
        }
    }
    
    func connectPendingAchievements() {
        print("LOADING ACHIEVMENTS LIST")
        let db = Firestore.firestore()
        let collection = db.collection("StudentAchievements")
        
        collection
            .order(by: "date", descending: true)
            .whereField("isApproved", isEqualTo: false)
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                
                let templist: [studentAchievement] = snapshot.documents.map { document in
                    let data = document.data()
                    let achievementtitle = data["achievementtitle"] as? String ?? ""
                    let achievementdescription = data["achievementdescription"] as? String ?? ""
                    let articleauthor = data["articleauthor"] as? String ?? ""
                    let publisheddate = data["publisheddate"] as? String ?? ""
                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                    let images = data["images"] as? [String] ?? []
                    let isApproved = data["isApproved"] as? Bool ?? false
                    let writerEmail = data["writerEmail"] as? String ?? ""
                    let documentID = document.documentID
                    
                    var imagedata: [UIImage] = []
                    for file in images {
                        let _ = imageManager().getImage(fileName: file) { image in
                            if let image = image {
                                imagedata.append(image)
                            }
                        }
                    }
                    
                    let achievement = studentAchievement(documentID: documentID, achievementtitle: achievementtitle, achievementdescription: achievementdescription, articleauthor: articleauthor, publisheddate: publisheddate, date: date, images: images, isApproved: isApproved, writerEmail: writerEmail, imagedata: imagedata)
                    return achievement
                }
                DispatchQueue.main.async {
                    if templist.isEmpty {
                        self.allpendingstudentachievementlistUnsorted.removeAll()
                    }
                    
                    for temp in templist {
                        if let index = self.allpendingstudentachievementlistUnsorted.firstIndex(where: { $0.documentID == temp.documentID }) {
                            self.allpendingstudentachievementlistUnsorted[index].achievementdescription = temp.achievementdescription
                            self.allpendingstudentachievementlistUnsorted[index].achievementtitle = temp.achievementtitle
                            self.allpendingstudentachievementlistUnsorted[index].articleauthor = temp.articleauthor
                            self.allpendingstudentachievementlistUnsorted[index].images = temp.images
                            self.allpendingstudentachievementlistUnsorted[index].publisheddate = temp.publisheddate
                            self.allpendingstudentachievementlistUnsorted[index].isApproved = temp.isApproved
                            self.allpendingstudentachievementlistUnsorted[index].imagedata = temp.imagedata
                            self.allpendingstudentachievementlistUnsorted[index].writerEmail = temp.writerEmail
                        } else {
                            self.allpendingstudentachievementlistUnsorted.append(temp)
                        }
                        if temp == templist.last {
                            for studentachievement in self.allpendingstudentachievementlistUnsorted {
                                if !templist.contains(where: { $0.documentID == studentachievement.documentID }) {
                                    self.allpendingstudentachievementlistUnsorted.removeAll(where: { $0.documentID == studentachievement.documentID }) // Remove if not on server
                                }
                            }
                        }
                    }
                    self.hasLoaded = true
                }
            }
        }
    }

    
    func createAchievement(achievement: studentAchievement, completion: @escaping (Error?) -> Void) {
        print("Creating new student spotlight...")
        let db = Firestore.firestore()
        let userInfo = UserInfo.shared
        db.collection("StudentAchievements").addDocument(data: [
            "achievementtitle": achievement.achievementtitle,
            "achievementdescription": achievement.achievementdescription,
            "articleauthor": achievement.articleauthor,
            "images": achievement.images,
            "publisheddate": achievement.publisheddate,
            "date": achievement.date,
            "isApproved": achievement.isApproved,
            "writerEmail": userInfo.email
        ]) { error in
            completion(error)
        }
        print("Article creating with ID: \(achievement.documentID)")
        
    }
    
    func deleteAchievment(achievement: studentAchievement, completion: @escaping (Error?) -> Void) {
        print("Deleting article with documentID: \(achievement.documentID)...")
        let db = Firestore.firestore()
        let ref = db.collection("StudentAchievements").document(achievement.documentID)
        ref.delete { error in
            completion(error)
        }
        print("Achievement deleted")
    }
}
