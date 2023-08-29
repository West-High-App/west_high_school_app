//
//  SportsNewsData.swift
//  West App
//
//  Created by August Andersen on 7/6/23.
//

import Foundation
import Firebase

struct sportNews: Identifiable, Codable {
    let newstitle: String
    let newsimage: [String]
    let newsdescription: String
    let newsdate: String
    let author: String
    var id = UUID()
    let documentID: String
}

class sportsNewslist: ObservableObject {
    @Published var allsportsnewslist = [sportNews(
        newstitle: "Varsity Football Team Wins Regional Championship",
        newsimage: ["football"],
        newsdescription: "The Lincoln High School varsity football team emerged victorious in the regional championship, securing their spot in the state finals.",
        newsdate: "Nov 15, 2022",
        author: "Emily Thompson", documentID: "NAN")]
    
    init() {
        print("getting sports news>>>>>")
        getSportsNews()
    }
    
    func getSportsNews() {
        var templist: [sportNews] = []
        print("GETTING SPORTS NEWS")
        let db = Firestore.firestore()
        let collection = db.collection("SportsNews")
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let newstitle = data["newstitle"] as? String ?? ""
                    let newsimage = data["newsimage"] as? [String] ?? []
                    let newsdescription = data["newsdescription"] as? String ?? ""
                    let newsdate = data["newsdate"] as? String ?? ""
                    let author = data["author"] as? String ?? ""
                    let documentID = document.documentID
                    
                    let sportnews = sportNews(newstitle: newstitle, newsimage: newsimage, newsdescription: newsdescription, newsdate: newsdate, author: author, documentID: documentID)
                    templist.append(sportnews)
                    print(sportnews)
                    print("^^^^ SPORTNEWS")
                }
                
                DispatchQueue.main.async {
                    self.allsportsnewslist = templist
                    print(self.allsportsnewslist)
                    print("^^^^^ ALL SPORTS LIS")
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
            if error == nil {
                self.getSportsNews()
            }
        }
        print("Sport news created with ID: \(sportNews.documentID)")
    }
    
    func deleteSportNews(sportNews: sportNews, completion: @escaping (Error?) -> Void) {
        print("Deleting sport news with ID: \(sportNews.documentID)")
        let db = Firestore.firestore()
        let ref = db.collection("SportsNews").document(sportNews.documentID)
        ref.delete { error in
            completion(error)
            if error == nil {
                self.getSportsNews()
            }
        }
        print("Article deleted")
    }
    
}

struct clubNews: Identifiable, Codable {
    let newstitle: String
    let newsimage: [String]
    let newsdescription: String
    let newsdate: String
    let author: String
    var id = UUID()
    let clubid: Int

}

struct clubsNewslist{
    static let allclubsnewslist = [
        clubNews(
        newstitle: "West High School Robotics Club Wins Regional Competition",
        newsimage: ["roboticsclub"],
        newsdescription: "The West High School Robotics Club celebrated a resounding victory at the highly competitive regional robotics competition. Their innovative robot design, precise programming, and strategic gameplay earned them the top spot, solidifying their reputation as one of the leading robotics teams in the state.",
        newsdate: "April 23, 2023",
        author: "Emily Thompson",
        clubid: 1),

        clubNews(
        newstitle: "West High School Debate Team Takes Home State Championship",
        newsimage: ["debateclub"],
        newsdescription: "The West High School Debate Team emerged triumphant at the state championship, showcasing their exceptional research skills, persuasive arguments, and impeccable public speaking abilities. Their dedication to critical thinking and effective communication earned them well-deserved recognition as the top debate team in the state.",
        newsdate: "March 12, 2023",
        author: "Jonathan Davis",
        clubid: 2),

        clubNews(
        newstitle: "West High School Science Olympiad Club Excels at National Level",
        newsimage: ["scienceclub"],
        newsdescription: "The West High School Science Olympiad Club showcased their scientific prowess at the national level, securing multiple top positions in various categories. Their extensive knowledge, rigorous preparation, and collaborative teamwork propelled them to success, highlighting their dedication to scientific exploration and discovery.",
        newsdate: "May 5, 2023",
        author: "Michelle Rodriguez",
        clubid: 3),

        clubNews(
        newstitle: "West High School Chess Club Dominates Regional Tournament",
        newsimage: ["chess"],
        newsdescription: "The West High School Chess Club demonstrated their mastery of strategy and critical thinking at the regional chess tournament, clinching numerous victories and emerging as the dominant force in the competition. Their passion for the game and dedication to honing their skills have solidified their position as a formidable chess club.",
        newsdate: "February 18, 2023",
        author: "Michael Sullivan",
        clubid: 4),

        clubNews(
        newstitle: "West High School Drama Club Receives Standing Ovation for Stellar Performance",
        newsimage: ["debateclub"],
        newsdescription: "The West High School Drama Club captivated audiences with their remarkable performance of the critically acclaimed play, leaving the crowd in awe and earning a well-deserved standing ovation. The club's exceptional acting skills, meticulous stage design, and seamless coordination made for an unforgettable theatrical experience.",
        newsdate: "November 29, 2022",
        author: "Sarah Anderson",
        clubid: 5),

        clubNews(
        newstitle: "West High School Photography Club Showcases Talent at State Exhibition",
        newsimage: ["photographyclub"],
        newsdescription: "The West High School Photography Club's artistic vision and technical expertise were on full display at the state photography exhibition. Their captivating compositions, mastery of light and shadow, and unique perspectives garnered praise from judges and fellow photographers alike, establishing the club as a creative force to be reckoned with.",
        newsdate: "June 9, 2023",
        author: "Alexandra Johnson",
        clubid: 6),

        clubNews(
        newstitle: "West High School Model United Nations Team Excels at International Conference",
        newsimage: ["mwdeca"],
        newsdescription: "The West High School Model United Nations (MUN) Team showcased their diplomacy and negotiation skills at an international conference, earning commendations for their in-depth research, persuasive speeches, and diplomatic prowess. Their ability to tackle complex global issues and propose effective solutions cemented their reputation as an exceptional MUN team.",
        newsdate: "March 27, 2023",
        author: "Jason Roberts",
        clubid: 7),

        clubNews(
        newstitle: "West High School Environmental Club Wins Statewide Conservation Award",
        newsimage: ["environmentalclub"],
        newsdescription: "The West High School Environmental Club's commitment to sustainability and environmental conservation was recognized with a prestigious statewide award. Their innovative initiatives, such as community clean-up campaigns, recycling drives, and awareness campaigns, have made a positive impact on the local ecosystem and inspired others to take action.",
        newsdate: "April 7, 2023",
        author: "Daniel Martin",
        clubid: 8),

        clubNews(
        newstitle: "West High School Music Club Achieves Perfect Scores at State Solo Competition",
        newsimage: ["piano"],
        newsdescription: "The West High School Music Club members showcased their exceptional musical talent and dedication at the state solo competition, earning perfect scores and accolades in various instrumental and vocal categories. Their commitment to musical excellence and hours of practice paid off, solidifying their status as exceptional musicians.",
        newsdate: "May 21, 2023",
        author: "Stephanie Thompson",
        clubid: 9),

        clubNews(
        newstitle: "West High School Coding Club Develops Award-Winning Mobile App",
        newsimage: ["codingclub"],
        newsdescription: "The West High School Coding Club's innovative mobile app received recognition at a national competition, where it was awarded first place for its user-friendly interface, seamless functionality, and creative design. The club's collaborative coding efforts and problem-solving skills were instrumental in the development of this groundbreaking application.",
        newsdate: "June 15, 2023",
        author: "David Wilson",
        clubid: 10)
    ]
}
