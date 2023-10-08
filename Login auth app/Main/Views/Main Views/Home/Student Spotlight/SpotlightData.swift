//
//  StudentSpotLightData.swift
//  West App
//
//  Created by Aiden Lee on 5/29/23.
//

import SwiftUI
import Firebase

struct studentachievement: Identifiable, Equatable{
    let id = UUID()
    let documentID: String
    var achievementtitle:String
    var achievementdescription:String // localizedstringkey??
    var articleauthor:String
    var publisheddate:String
    var images:[String]
    var isApproved: Bool
    var imagedata: [UIImage] // , imagedata: []
 }

extension Array<studentachievement> {
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
    
    @Published private var allstudentachievementlistUnsorted: [studentachievement] = []
    var allstudentachievementlist: [studentachievement] {
        allstudentachievementlistUnsorted.sortedByDate()
    }
    @Published var newstitlearray: [studentachievement] = []
    @Published var hasLoaded = false

    @StateObject var imagemanager = imageManager()
    @ObservedObject var loading = Loading()
    private let fetchLimit = 20
    private var lastDocument: DocumentSnapshot?
    @Published private(set) var allDocsLoaded = false
    @Published private(set) var allPendingDocsLoaded = false
    
    init() {
        connectAchievements(getPending: false)
        connectAchievements(getPending: true)
    }
    
    private func handleFirestore(_ templist: [studentachievement], handlePending: Bool) {
        DispatchQueue.main.async {
            if handlePending, templist.isEmpty {
                for element in self.allstudentachievementlistUnsorted where !element.isApproved {
                    if let index = self.allstudentachievementlistUnsorted.firstIndex(where: { element.documentID == $0.documentID }) {
                        self.allstudentachievementlistUnsorted.remove(at: index)
                    }
                }
                return
            }
            
            for temp in templist {
                if let index = self.allstudentachievementlistUnsorted.firstIndex(where: { $0.documentID == temp.documentID }) {
                    self.allstudentachievementlistUnsorted[index].achievementdescription = temp.achievementdescription
                    self.allstudentachievementlistUnsorted[index].achievementtitle = temp.achievementtitle
                    self.allstudentachievementlistUnsorted[index].articleauthor = temp.articleauthor
                    self.allstudentachievementlistUnsorted[index].images = temp.images
                    self.allstudentachievementlistUnsorted[index].publisheddate = temp.publisheddate
                    self.allstudentachievementlistUnsorted[index].isApproved = temp.isApproved
                    self.allstudentachievementlistUnsorted[index].imagedata = temp.imagedata
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
            self.loading.hasLoaded = true
            print(self.allstudentachievementlistUnsorted.count)
            self.hasLoaded = true
        }
    }
    
    func getMoreAchievements(getPending: Bool) {
        guard let lastDocument else { return }
        
        print("LOADING ACHIEVMENTS LIST")
        let db = Firestore.firestore()
        let collection = db.collection("StudentAchievements")
        
        collection
            .order(by: "publisheddate", descending: true)
            .whereField("isApproved", isEqualTo: !getPending) // get approved dpcs if getPending is false or pending if getPending is true
            .limit(to: fetchLimit)
            .start(afterDocument: lastDocument)
            .getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                self.lastDocument = snapshot.documents.last
                let templist: [studentachievement] = snapshot.documents.map { document in
                    let data = document.data()
                    let achievementtitle = data["achievementtitle"] as? String ?? ""
                    let achievementdescription = data["achievementdescription"] as? String ?? ""
                    let articleauthor = data["articleauthor"] as? String ?? ""
                    let publisheddate = data["publisheddate"] as? String ?? ""
                    let images = data["images"] as? [String] ?? []
                    let isApproved = data["isApproved"] as? Bool ?? false
                    let documentID = document.documentID
                    
                    var imagedata: [UIImage] = []
                    for file in images {
                        let _ = imageManager().getImage(fileName: file) { image in
                            if let image = image {
                                imagedata.append(image)
                            }
                        }
                    }
                    
                    let achievement = studentachievement(documentID: documentID, achievementtitle: achievementtitle, achievementdescription: achievementdescription, articleauthor: articleauthor, publisheddate: publisheddate, images: images, isApproved: isApproved, imagedata: imagedata)
                    return achievement
                }
                self.handleFirestore(templist, handlePending: getPending)
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
    
    func connectAchievements(getPending: Bool) {
        print("LOADING ACHIEVMENTS LIST")
        let db = Firestore.firestore()
        let collection = db.collection("StudentAchievements")
        
        collection
            .order(by: "publisheddate", descending: true)
            .whereField("isApproved", isEqualTo: !getPending) // get approved dpcs if getPending is false or pending if getPending is true
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
                let templist: [studentachievement] = snapshot.documents.map { document in
                    let data = document.data()
                    let achievementtitle = data["achievementtitle"] as? String ?? ""
                    let achievementdescription = data["achievementdescription"] as? String ?? ""
                    let articleauthor = data["articleauthor"] as? String ?? ""
                    let publisheddate = data["publisheddate"] as? String ?? ""
                    let images = data["images"] as? [String] ?? []
                    let isApproved = data["isApproved"] as? Bool ?? false
                    let documentID = document.documentID
                    
                    var imagedata: [UIImage] = []
                    for file in images {
                        let _ = imageManager().getImage(fileName: file) { image in
                            if let image = image {
                                imagedata.append(image)
                            }
                        }
                    }
                    
                    let achievement = studentachievement(documentID: documentID, achievementtitle: achievementtitle, achievementdescription: achievementdescription, articleauthor: articleauthor, publisheddate: publisheddate, images: images, isApproved: isApproved, imagedata: imagedata)
                    return achievement
                }
                self.handleFirestore(templist, handlePending: getPending)
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

    
    func createAchievement(achievement: studentachievement, completion: @escaping (Error?) -> Void) {
        print("Creating new student spotlight...")
        let db = Firestore.firestore()
        db.collection("StudentAchievements").addDocument(data: [
            "achievementtitle": achievement.achievementtitle,
            "achievementdescription": achievement.achievementdescription,
            "articleauthor": achievement.articleauthor,
            "images": achievement.images,
            "publisheddate": achievement.publisheddate,
            "isApproved": achievement.isApproved
        ]) { error in
            completion(error)
        }
        print("Article creating with ID: \(achievement.documentID)")
        
    }
    
    func deleteAchievment(achievement: studentachievement, completion: @escaping (Error?) -> Void) {
        print("Deleting article with documentID: \(achievement.documentID)...")
        let db = Firestore.firestore()
        let ref = db.collection("StudentAchievements").document(achievement.documentID)
        ref.delete { error in
            completion(error)
        }
        print("Achievement deleted")
    }
    
    
    func getImageData(articlelist: [studentachievement], completion: @escaping ([studentachievement]) -> Void) {
        var spotlightarticles = articlelist
        var returnlist: [studentachievement] = []
        
        let dispatchGroup = DispatchGroup()
        
        for article in spotlightarticles {
            var tempimages: [UIImage] = []
            
            for imagepath in article.images {
                dispatchGroup.enter()
                imagemanager.getImage(fileName: imagepath) { uiimage in
                    if let uiimage = uiimage {
                        tempimages.append(uiimage)
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                let updatedArticle = studentachievement(
                    documentID: article.documentID,
                    achievementtitle: article.achievementtitle,
                    achievementdescription: article.achievementdescription,
                    articleauthor: article.articleauthor,
                    publisheddate: article.publisheddate,
                    images: article.images,
                    isApproved: article.isApproved,
                    imagedata: tempimages
                )
                returnlist.append(updatedArticle)
                spotlightarticles = returnlist
                completion(spotlightarticles)
            }
        }
    }
}
