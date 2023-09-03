//
//  ClubSportData.swift
//  West App
//
//  Created by August Andersen on 5/20/23.
//

import Foundation
import Firebase
// MARK: sports
struct sport: Identifiable {
    var sportname:String // name of sport
    var sportcoaches: [String] // coach
    var adminemails: [String]
    var sportsimage:String // image name
    var sportsteam: String // varsity, jv, etc.
    var sportsroster:[String] // array of students in sport
    var sportscaptains:[String] // array of captains in sports
    var tags: [Int] // [gender tag, season tag, team tag] all ints
    var info: String
    var documentID: String // NOT USED IN FIREBASE
    var sportid: String // NOT USED IN FIREBASE
    var id: Int // NOT USED IN FIREBASE
}
    
class sportsManager: ObservableObject {
    @Published var allsportlist: [sport] = []
    var favoritesports = FavoriteSports()
    @Published var favoriteslist: [sport] = []
    
    init() {
        getSports() { sports in }
        getFavorites { favorites in
            self.favoriteslist = favorites
        }
        print("GOT FAVORITES:")
        print(self.favoriteslist)
    }
    
    func getSports(completion: @escaping ([sport]) -> Void) {
        var returnvalue: [sport] = []
        var tempID = 0
        let db = Firestore.firestore()
        let collection = db.collection("Sport")
        
        
        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let sportname = data["sportname"] as? String ?? ""
                    let sportcoaches = data["sportscoaches"] as? [String] ?? []
                    let adminemails = data["adminemails"] as? [String] ?? []
                    let sportsimage = data["sportsimage"] as? String ?? ""
                    let sportsteam = data["sportsteam"] as? String ?? ""
                    let sportsroster = data["sportsroster"] as? [String] ?? []
                    let sportscaptains = data["sportscaptains"] as? [String] ?? []
                    let tags = data["tags"] as? [Int] ?? [1, 1, 1]
                    let info = data["info"] as? String ?? ""
                    let documentID = document.documentID
                    let sportid = "\(sportname) \(sportsteam)"
                    let id = tempID
                    
                    let sport = (sport(sportname: sportname, sportcoaches: sportcoaches, adminemails: adminemails, sportsimage: sportsimage, sportsteam: sportsteam, sportsroster: sportsroster, sportscaptains: sportscaptains, tags: tags, info: info, documentID: documentID, sportid: sportid, id: id))
                    tempID = tempID + 1
                    returnvalue.append(sport)
                }
                
                DispatchQueue.main.async {
                    self.allsportlist = returnvalue
                }
            }
            completion(returnvalue)
        }
    }
    
    func createSport(sport: sport, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("Sport").addDocument(data: [
            "sportname": sport.sportname,
            "sportcoaches": sport.sportcoaches,
            "adminemails": sport.adminemails,
            "sportsimage": sport.sportsimage,
            "sportsteam": sport.sportsteam,
            "sportsroster": sport.sportsroster,
            "sportscaptains": sport.sportscaptains,
            "tags": sport.tags,
            "info": sport.info,
        ]) { error in
            completion(error)
            if error == nil {
                self.getSports() { sports in }
            }
        }
    }
    
    func deleteSport(sport: sport, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("Sport").document(sport.documentID)
        
        ref.delete { error in
            completion(error)
            if error == nil {
                self.getSports() { sports in }
            }
        }
    }
    
    func updateSport(data: sport) {
        let db = Firestore.firestore()
        let ref = db.collection("Sport").document(data.documentID)
        ref.setData([
            "sportname": data.sportname,
            "sportscoaches": data.sportcoaches,
            "adminemails": data.adminemails,
            "sportsimage": data.sportsimage,
            "sportsteam": data.sportsteam,
            "sportsroster": data.sportsroster,
            "sportscaptains": data.sportscaptains,
            "tags": data.tags,
            "info": data.info,
        ])
    }
    
    func getFavorites(completion: @escaping ([sport]) -> Void) {
        var templist: [sport] = []
        var templist2: [String] = []
        var returnlist: [sport] = []
        
        returnlist = self.allsportlist
        
        favoritesports.getFavorites { [self] favorites in
            templist2 = favorites
            
            self.getSports() { sports in
                templist = sports
                print("SPORTS")
                print(templist)
                
                for item in templist {
                    for item2 in templist2 {
                        if "\(item.sportname) \(item.sportsteam)" == item2 {
                            returnlist.append(item)
                            print("HOLY SHIT BOIS")
                        }
                    }
                }
                
                completion(returnlist)
            }
        }
    }

    
}

struct club: Identifiable, Codable {
    let clubname:String
    let clubcaptain:[String]?
    let clubadvisor: [String]
    let clubmeetingroom:String
    let clubdescription:String
    let clubimage:String
    let clubmembercount:String
    let clubmembers:[String]
    let isFaved: Bool
    let tags: [Int]
    let id: Int
    
    static let allsportlist = [
        club(clubname: "DECA",
              clubcaptain: ["Mara Glinberg", "Wyatt Elmore"],
              clubadvisor: ["Lauren J Cole"],
              clubmeetingroom: "Room 1209",
              clubdescription: "Join DECA entrepernuers in their love of business and advertising! This club is both for beginners and experiences business-people. Come say hi in room 1209 during lunch of Thursdays!",
              clubimage: "deca",
              clubmembercount: "103",
              clubmembers: ["Parker Williams", "Wayne Johnson", "Johnny Depp", "Lil Durk", "Aiden Lee", "August Andersen", "Luke Field"], isFaved: false,
             tags: [1, 1, 1],id: 1),
        club(clubname: "Mock Trial",
              clubcaptain: ["Anna Field", "Caleb Ellenberg", "Eli Protisiewits"],
              clubadvisor: ["Antonio Zappia"],
              clubmeetingroom: "Room 2206",
              clubdescription: "Are you into legal things? Or do you want to know how to get out of a pickle? This club is for you!",
              clubimage: "mwmocktrial",
              clubmembercount: "43",
              clubmembers: ["Penis Parker", "Lil Wayne", "Johnny Peep", "Lil Durk", "El Prime from Brawl Stars", "Hay Day Chicken", "BTS Jimin"], isFaved: false, tags: [1, 1, 1], id: 2),
        club(clubname: "Student Council",
              clubcaptain: ["Olivia O'Callagan", "Tia Beirne"],
              clubadvisor: ["Timothy McLaughin"],
              clubmeetingroom: "Room 1702",
              clubdescription: "If you want to be an active and helpful member to our school community, this club is for you! Help with fundraisers, plan events, and more!",
              clubimage: "mwstuco",
              clubmembercount: "23",
              clubmembers: ["Madison Williams", "Johnathan Lee", "Bob Mendel", "Michelle Obama"], isFaved: false, tags: [1, 1, 1], id: 3),
        club(clubname: "Anime Club",
              clubcaptain: ["Claire Cho", "Timothy Brian"],
              clubadvisor: ["Jamie Riley"],
              clubmeetingroom: "Room 2077",
              clubdescription: "Are you a fan of the japanese animated television? Are you kind of a geek? This club is perfect for you!",
              clubimage: "animeclub",
              clubmembercount: "3",
              clubmembers: ["Sam Baller", "Agathon Westin", "Jussi-Matti Olafson", "Elsa from Frozen"], isFaved: false, tags: [1, 1, 1], id: 4),
        club(clubname: "Homework Club",
              clubcaptain: ["James Charles", "Jimmy Johnson"],
              clubadvisor: ["Senorita Byers"],
              clubmeetingroom: "Room 3021",
              clubdescription: "Perfect club for doing homework with friends, as well as getting help from councelers, teachers, and upperclassmen. Great for being productive!",
              clubimage: "homeworkclub",
              clubmembercount: "37",
              clubmembers: ["John Dole", "Sarah Li", "Edward Bradbury", "Ana from Frozen"], isFaved: false, tags: [1, 1, 1], id: 5),
        club(clubname: "Investing Club",
              clubcaptain: ["Wyatt Elmore", "Henry Johnson"],
              clubadvisor: ["Mr. Battaglia"],
              clubmeetingroom: "Room 1120",
              clubdescription: "Do you want to learn how to make money while you sleep? Do you want to be cool like Warrett Buffet or whatever his name is? This club is for you! Join Fridays at lunch, and there might even be pizza and donuts!",
              clubimage: "investing",
              clubmembercount: "60",
              clubmembers: ["August Andersen", "Aiden Lee", "Aurthur Boldrevoyz", "Henry Henklemenn", ""], isFaved: false, tags: [1, 1, 1], id: 6),
        club(clubname: "Piano Club",
        clubcaptain: ["Emily Chen", "Jonathan Adams"],
        clubadvisor: ["Ms. Williams"],
        clubmeetingroom: "Music Room 203",
        clubdescription: "Discover the joy of playing the piano! Whether you're a beginner or an advanced pianist, this club offers a supportive environment to learn, practice, and perform together. Join us for weekly jam sessions and occasional recitals.",
        clubimage: "piano",
        clubmembercount: "25",
        clubmembers: ["Sophia Thompson", "Michael Rodriguez", "Olivia Lee", "Benjamin Davis"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 7),

        club(clubname: "GSA",
        clubcaptain: ["Alex Johnson", "Jordan Ramirez"],
        clubadvisor: ["Ms. Anderson"],
        clubmeetingroom: "Room 405",
        clubdescription: "GSA is a safe space for LGBTQ+ students and allies. We aim to promote acceptance, equality, and understanding of diverse sexual orientations and gender identities. Join us for discussions, guest speakers, and community outreach projects.",
        clubimage: "gsa",
        clubmembercount: "40",
        clubmembers: ["Taylor Wilson", "Ethan Martinez", "Avery Thompson", "Sam Robinson"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 8),

        club(clubname: "Math Club",
        clubcaptain: ["Jessica Nguyen", "David Chen"],
        clubadvisor: ["Mr. Anderson"],
        clubmeetingroom: "Room 305",
        clubdescription: "Calling all math enthusiasts! Join the Math Club to challenge your problem-solving skills, participate in competitions, and explore fascinating mathematical concepts. We offer tutoring sessions and organize math-related events throughout the year.",
        clubimage: "math",
        clubmembercount: "30",
        clubmembers: ["Ryan Smith", "Sophie Johnson", "Daniel Kim", "Grace Thompson"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 9),

        club(clubname: "Gaming Club",
        clubcaptain: ["Jason Miller", "Megan Adams"],
        clubadvisor: ["Mr. Ramirez"],
        clubmeetingroom: "Room 207",
        clubdescription: "Are you a passionate gamer? Join our Gaming Club to connect with fellow gamers, discuss the latest trends in the gaming world, and participate in friendly competitions. We have console gaming, PC gaming, and board games for everyone to enjoy!",
        clubimage: "gaming",
        clubmembercount: "50",
        clubmembers: ["Jacob Wilson", "Isabella Martinez", "Nathan Davis", "Sophia Johnson"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 10),

        club(clubname: "Chess Club",
        clubcaptain: ["Alexander Brown", "Emma Thompson"],
        clubadvisor: ["Mrs. Hernandez"],
        clubmeetingroom: "Room 408",
        clubdescription: "Checkmate! Join the Chess Club and improve your strategic thinking skills while engaging in friendly matches. All skill levels are welcome, from beginners to experienced players. We provide chess boards and organize tournaments within the school and against other schools.",
        clubimage: "chess",
        clubmembercount: "20",
        clubmembers: ["William Johnson", "Samantha Davis", "James Wilson", "Olivia Martinez"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 11),

        club(clubname: "Dungeons & Dragons",
        clubcaptain: ["Ryan Adams", "Sophia Davis"],
        clubadvisor: ["Mr. Thompson"],
        clubmeetingroom: "Room 315",
        clubdescription: "Embark on epic adventures, fight mythical creatures, and unleash your imagination in our D&D Club! Create unique characters, solve puzzles, and work together as a team. No prior experience necessary—come and join the fun!",
        clubimage: "dnd",
        clubmembercount: "35",
        clubmembers: ["Michael Johnson", "Emily Wilson", "Daniel Martinez", "Oliver Brown"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 12),

        club(clubname: "Art Club",
        clubcaptain: ["Lily Anderson", "Ethan Davis"],
        clubadvisor: ["Ms. Ramirez"],
        clubmeetingroom: "Art Room 102",
        clubdescription: "Unleash your creativity in the Art Club! Whether you enjoy drawing, painting, sculpting, or any other form of art, this club provides a space to express yourself, learn new techniques, and collaborate with fellow artists. Join us for workshops, art exhibits, and community projects.",
        clubimage: "art",
        clubmembercount: "45",
        clubmembers: ["Sophie Wilson", "Jackson Thompson", "Ava Davis", "Noah Johnson"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 13),
        club(clubname: "Science Club",
        clubcaptain: ["Emma Roberts", "Andrew Johnson"],
        clubadvisor: ["Dr. Lewis"],
        clubmeetingroom: "Science Lab 301",
        clubdescription: "Calling all science enthusiasts! Join the Science Club to engage in hands-on experiments, discussions on scientific topics, and field trips to scientific institutions. Explore the wonders of biology, chemistry, physics, and more in a fun and interactive environment.",
        clubimage: "scienceclub",
        clubmembercount: "35",
        clubmembers: ["Sophia Anderson", "Ethan Davis", "Olivia Johnson", "Daniel Smith"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 14),

        club(clubname: "Book Club",
        clubcaptain: ["Emily Wilson", "Jacob Thompson"],
        clubadvisor: ["Ms. Roberts"],
        clubmeetingroom: "Library",
        clubdescription: "Are you passionate about reading and discussing books? Join the Book Club to explore various genres, exchange literary insights, and participate in book-related activities. We organize author visits, book swaps, and reading challenges throughout the year.",
        clubimage: "bookclub",
        clubmembercount: "30",
        clubmembers: ["Ava Johnson", "Noah Davis", "Isabella Thompson", "James Anderson"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 15),

        club(clubname: "Film Club",
        clubcaptain: ["Sophia Davis", "Benjamin Wilson"],
        clubadvisor: ["Mr. Roberts"],
        clubmeetingroom: "Auditorium",
        clubdescription: "Lights, camera, action! Join the Film Club to explore the art of filmmaking, analyze movies, and create your own short films. Whether you're interested in directing, screenwriting, or cinematography, this club offers a platform to learn, collaborate, and appreciate the world of cinema.",
        clubimage: "filmclub",
        clubmembercount: "40",
        clubmembers: ["Oliver Johnson", "Grace Thompson", "Lucas Davis", "Sophie Anderson"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 16),

        club(clubname: "Coding Club",
        clubcaptain: ["Ryan Thompson", "Sophie Roberts"],
        clubadvisor: ["Mr. Davis"],
        clubmeetingroom: "Computer Lab 201",
        clubdescription: "Interested in computer programming? Join the Coding Club to learn various programming languages, work on coding projects, and participate in coding competitions. We provide resources, guest speakers, and opportunities to develop practical skills in the rapidly evolving field of technology.",
        clubimage: "codingclub",
        clubmembercount: "25",
        clubmembers: ["Michael Anderson", "Emily Johnson", "Daniel Thompson", "Olivia Davis"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 17),

        club(clubname: "Environmental Club",
        clubcaptain: ["Sophia Wilson", "Ethan Thompson"],
        clubadvisor: ["Mrs. Roberts"],
        clubmeetingroom: "Outdoor Garden",
        clubdescription: "Passionate about the environment? Join the Environmental Club to raise awareness about sustainability, participate in eco-friendly projects, and make a positive impact on our planet. We organize clean-up campaigns, tree-planting events, and collaborate with local environmental organizations.",
        clubimage: "environmentalclub",
        clubmembercount: "50",
        clubmembers: ["Jackson Anderson", "Ava Johnson", "Noah Thompson", "Isabella Davis"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 18),

        club(clubname: "Debate Club",
        clubcaptain: ["Jacob Davis", "Olivia Wilson"],
        clubadvisor: ["Mr. Johnson"],
        clubmeetingroom: "Room 315",
        clubdescription: "Sharpen your communication skills and engage in lively debates! Join the Debate Club to discuss important topics, practice persuasive speaking, and participate in debate competitions. Develop critical thinking, research, and public speaking abilities in a supportive and intellectually stimulating environment.",
        clubimage: "debateclub",
        clubmembercount: "30",
        clubmembers: ["Lucas Thompson", "Sophie Davis", "Benjamin Anderson", "Grace Johnson"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 19),

        club(clubname: "Robotics Club",
        clubcaptain: ["Ethan Anderson", "Olivia Thompson"],
        clubadvisor: ["Mr. Davis"],
        clubmeetingroom: "Engineering Lab 401",
        clubdescription: "Join the Robotics Club to delve into the exciting world of robotics and automation. Build and program robots, compete in robotics competitions, and explore cutting-edge technologies. Whether you have prior experience or not, this club offers hands-on learning and problem-solving opportunities.",
        clubimage: "roboticsclub",
        clubmembercount: "40",
        clubmembers: ["Daniel Anderson", "Oliver Thompson", "Emily Davis", "Jacob Wilson"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 20),

        club(clubname: "Foreign Language Club",
        clubcaptain: ["Sophie Johnson", "Lucas Anderson"],
        clubadvisor: ["Ms. Hernandez"],
        clubmeetingroom: "Room 408",
        clubdescription: "¡Bienvenidos! Join the Foreign Language Club to explore different cultures, practice languages, and connect with students from around the world. We offer activities, language workshops, and cultural events that celebrate the diversity of languages spoken within our school community.",
        clubimage: "foreignlanguageclub",
        clubmembercount: "35",
        clubmembers: ["Ava Thompson", "Noah Davis", "Isabella Johnson", "James Anderson"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 21),

        club(clubname: "Photography Club",
        clubcaptain: ["Olivia Anderson", "Jackson Thompson"],
        clubadvisor: ["Ms. Roberts"],
        clubmeetingroom: "Art Room 102",
        clubdescription: "Capture moments, tell stories, and unleash your creativity through photography! Join the Photography Club to learn photography techniques, participate in photo walks, and showcase your work in exhibitions. Whether you're a beginner or an experienced photographer, this club is for you.",
        clubimage: "photographyclub",
        clubmembercount: "30",
        clubmembers: ["Isabella Anderson", "James Thompson", "Sophie Davis", "Benjamin Wilson"],
        isFaved: false,
        tags: [1, 1, 1],
        id: 22)
        ]
}


