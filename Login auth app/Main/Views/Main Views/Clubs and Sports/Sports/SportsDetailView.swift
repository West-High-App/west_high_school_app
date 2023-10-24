//
//  SportsDetailView.swift
//  West App
//
//  Created by Aiden Lee on 5/20/23.
//

import SwiftUI

struct SportsDetailView: View {
    @ObservedObject var hasPermission = PermissionsCheck.shared
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var sportsmanager: sportsManager // <------
    @EnvironmentObject var sporteventmanager: sportEventManager
    @EnvironmentObject var sporteventstorage: SportsEventStorage
    @StateObject var imagemanager = imageManager()
    @State private var hasPermissionSport = false
    @State private var canEditSport = false
    @State var selected = 1
    @State var isFavorited = false
    @State var favorites: [sport] = []
    //@EnvironmentObject var vm: SportsHibabi.ViewModel
    @State private var confirming = false
    @State private var confirming2 = false
    @State var screen = ScreenSize()
    @State var hasAppeared = false
    @State private var navigationBarHeight: CGFloat = 0.0
    var events: [ParsedEvent] {
        sporteventmanager.eventDictionary["\(currentsport.sportname) \(currentsport.sportsteam)"] ?? []
    }
    var pastSportEvents: [sportEvent] {
        sporteventmanager.pastEventDictionary["\(currentsport.sportname) \(currentsport.sportsteam)"] ?? []
    }
    @State var newpastevents: [sportEvent] = []
    @State var showingEditRoster = false
    @State var isDisplayingAddImage = false
    @State var temprosterimage: UIImage?
    @State var isConfirmingChanges = false
    @State var sporttoedit: sport?
    
    var isLoading: Bool {
        sporteventmanager.isLoading
    }
    
    @State var currentsport: sport
    
    func dateDate(date: Date) -> String {
        return date.formatted(date: .long, time: .omitted)
    }
    
    func dateTime(date: Date) -> String {
        return date.formatted(date: .omitted, time: .shortened)
    }
    
    func firstThree(input: String) -> String {
        if input.count > 2 {
            return String(input.prefix(3))
        }
        return ""
    }
    let calendar = Calendar.current
    
    func getFirstThreeCharactersOfMonth(from date: Date) -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MMM"

        let dateString = dateFormatter.string(from: date)

        let firstThreeCharacters = String(dateString.prefix(3))

        return firstThreeCharacters
    }
    
    @State var currentsportID = ""
    @State var upcomingeventslist: [sportEvent] = []
    @State var topthree: [sportEvent] = []
    @State var isEditing = false
    
    let westyellow = Color(red:248/255, green:222/255, blue:8/255)
    let westblue = Color(red: 41/255, green: 52/255, blue: 134/255)
    //MARK: view
    var body: some View {
        GeometryReader { geometry in
            ScrollView (showsIndicators: false){
                VStack {
                    VStack{
                        HStack {
                            Text(currentsport.sportname)
                                .foregroundColor(Color.black)
                                .font(.system(size: 35, weight: .bold, design: .rounded))
                                .lineLimit(2)
                                .minimumScaleFactor(0.3)
                                .padding(.horizontal)
                            Spacer()
                        }
                        HStack {
                            Text(currentsport.sportsteam)
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26, weight: .semibold, design: .rounded))
                                .lineLimit(1)
                                .padding(.horizontal)
                            Spacer()
                        }
                        
                        if currentsport.imagedata != nil {
                            VStack {
                                
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.white)
                                    
                                    VStack(spacing: 0) {
                                        Image(uiImage: currentsport.imagedata ?? UIImage())
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: screen.screenWidth - 30, height: 250)
                                            .clipped()
                                    }
                                }
                                
                            }.cornerRadius(30)
                                .frame(width: screen.screenWidth - 30, height: 250)
                                .shadow(color: .gray, radius: 8, x:2, y:3)
                            
                                .padding(.horizontal)
                        }
                        Spacer()
                    }
                    
                    Text(currentsport.info)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.black)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .padding(.horizontal, 25)
                        .padding(.vertical, 5)
                    
                    Picker(selection: $selected, label: Text(""), content: {
                        Text("Upcoming").tag(1)
                        Text("Past Events").tag(2)
                        Text("Roster").tag(3)
                    }).pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                    
                    
                    // upcoming events view
                    
                    if selected == 1 {
                        if !isLoading {
                        
                        if events.isEmpty {
                            Text("No upcoming events.")
                                .lineLimit(1)
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                                .padding(.leading, 5)
                        } else {
                            List {
                                ForEach(events, id: \.id) { event in
                                    HStack {
                                        VStack {
                                            Text(getFirstThreeCharactersOfMonth(from: event.date))
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                            Text(String(calendar.component(.day, from: event.date)))
                                                .font(.system(size: 32, weight: .regular, design: .rounded))
                                                .foregroundColor(.black)
                                        }
                                        .foregroundColor(.red)
                                        .frame(width:50,height:50)
                                        Divider()
                                            .padding(.vertical, 10)

                                        VStack {
                                            HStack {
                                                Text("\(event.type)")
                                                    .font(.headline)
                                                Spacer()
                                            }
                                            HStack {
                                                Text("\(event.opponent)")
                                                Spacer()
                                            }
                                            
                                            DisclosureGroup("See More") {
                                                HStack {
                                                    Image(systemName: "clock")
                                                        .resizable()
                                                        .frame(width: 15, height: 15)
                                                    Text(event.isTBD ? "TBD" : "\(event.date.formatted(date: .omitted, time: .shortened))")
                                                        .font(.system(size: 18, weight: .regular, design: .rounded))  // regular
                                                        .foregroundColor(.black)
                                                        .lineLimit(1)

                                                    Spacer()
                                                }.foregroundColor(.black)
                                                HStack {
                                                    Image(systemName: "location")
                                                        .resizable()
                                                        .frame(width: 15, height: 15)
                                                    Text("\(event.location)")
                                                    Spacer()
                                                }.foregroundColor(.black)
                                                
                                                if !event.comments.isEmpty {
                                                    HStack {
                                                        Text("Comments: \(event.comments)")
                                                        Spacer()
                                                    }.foregroundColor(.black)
                                                }

                                            }.padding(.top, -10)
                                                .accentColor(.gray)
                                                .foregroundColor(.gray)
                                            
                                        }
                                    }
                                }
                            }.frame(height: 450)                        }
                        } else {
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                    }
                    
                    // past games view
                    
                    if selected == 2 {
                        if currentsport.editoremails.contains(userInfo.email) || currentsport.adminemails.contains(userInfo.email) || hasPermission.sports {
                            NavigationLink {
                                PastSportEventsAdminView(currentsport: currentsport)
                            } label: {
                                Text("Edit past events")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .padding(10)
                                    .cornerRadius(15.0)
                                    .frame(width: screen.screenWidth-30)
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    .background(Rectangle()
                                        .foregroundColor(.blue)
                                        .cornerRadius(10)
                                    )

                            }
                        }
                        
                        if pastSportEvents.isEmpty {
                            Text("No past events.")
                                .lineLimit(1)
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                                .padding(.leading, 5)
                        } else {
                            List(pastSportEvents, id: \.id) { event in
                                HStack {
                                    VStack {
                                        Text(event.month)
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                        Text(event.day)
                                            .font(.system(size: 32, weight: .regular, design: .rounded))
                                            .foregroundColor(.black)

                                    }
                                    .foregroundColor(.red)
                                    .frame(width:50,height:50)
                                    Divider()
                                        .padding(.vertical, 10)
                                    Spacer()
                                        .frame(width: 10) // new
                                    VStack (alignment: .leading){
                                        Text(event.title)
                                            .font(.headline)
                                        if !event.isSpecial {
                                            Text(event.subtitle)
                                            HStack {
                                                if event.score.count > 1 {
                                                    if event.score[0] == 0 && event.score[1] == 0 {
                                                    } else {
                                                        if event.score[0] > event.score[1] {
                                                            Text(String(event.score[0]))
                                                            Text("-")
                                                            Text(String(event.score[1]))
                                                            Text("(Win)")
                                                                .foregroundColor(.green)
                                                        } else                                 if event.score[0] < event.score[1] {
                                                            Text(String(event.score[0]))
                                                            Text("-")
                                                            Text(String(event.score[1]))
                                                            Text("(Loss)")
                                                                .foregroundColor(.red)
                                                        } else {
                                                            Text(String(event.score[0]))
                                                            Text("-")
                                                            Text(String(event.score[1]))
                                                            Text("(Tie)")
                                                        }
                                                    }
                                                } else {
                                                }
                                            }
                                        } else {
                                            if event.subtitle.contains("$WIN$") {
                                                Text("Win")
                                                    .foregroundColor(.green)
                                            } else if event.subtitle.contains("$LOSS$") {
                                                Text("Loss")
                                                    .foregroundColor(.red)
                                            }
                                            else if event.subtitle.contains("$TIE$") {
                                                Text("Tie")
                                                    .foregroundColor(.black)
                                            }
                                            else {
                                                Text(event.subtitle)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(height: 450)
                        }
                    }
                    
                    // members view
                    
                    if selected == 3 {
                        VStack {
                            
                            if currentsport.rosterimagedata != nil {
                                NavigationLink {
                                    ZoomableImageView(image: currentsport.rosterimagedata ?? UIImage())
                                } label: {
                                    Image(uiImage: currentsport.rosterimagedata ?? UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(10)
                                        .frame(maxHeight: 800)
                                        .padding(10)
                                }
                            }
                            else {
                                Text("No roster.")
                                    .lineLimit(1)
                                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                                    .padding(.leading, 5)                            }
                        }
                    }
                    
                    
                }.padding(.top, 10 + screen.screenHeight / 10) // padding was here
                
                .navigationDestination(isPresented: $isEditing, destination: {
                    SportsDetailAdminView(editingsport: currentsport)
                        .environmentObject(sportsmanager)
                })
                
                .navigationBarItems(trailing:
                                        Group {
                    HStack {
                        if currentsport.adminemails.contains(userInfo.email) || hasPermission.sports  {
                            Button {
                                self.isEditing.toggle()
                            } label: {
                                Text("Edit")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                            }
                            
                        }
                        
                        if isFavorited {
                            Button {
                                confirming2 = true
                            } label : {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }
                        } else {
                            Button {
                                confirming = true
                            } label: {
                                Image(systemName: "heart")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                )
                
                // add/remove sports confirm
                .confirmationDialog("Add to Favorites", isPresented: $confirming) {
                    Button("Add to Favorites") {
                        // hello
                        var tempsport = currentsport // sets a temp sport
                        tempsport.favoritedusers.append(userInfo.email) // adds the user to favorited sports of the temp sport
                        sportsmanager.updateSport(data: tempsport) // updates the firebase of old sport to be new sport
                        sportsmanager.allsportlist.removeAll {$0 == currentsport} // removes the old sport from allsportslist
                        sportsmanager.allsportlist.append(tempsport) // append new updated sport to allsportslist
                        isFavorited = true
                    }
                }
                
                .confirmationDialog("Remove from Favorites", isPresented: $confirming2) {
                    Button("Remove from Favorites", role: .destructive) {
                        
                        var tempsport = currentsport
                        tempsport.favoritedusers.removeAll {$0 == userInfo.email}
                        sportsmanager.allsportlist.removeAll {$0 == currentsport}
                        sportsmanager.allsportlist.append(tempsport)
                        sportsmanager.updateSport(data: tempsport)
                        
                        sportsmanager.favoriteslist.removeAll {$0 == currentsport}
                        
                        isFavorited = false
                    }
                }
            }
        }
        .onAppear {
            sporteventmanager.getData(forSport: self.currentsport)
                                
            imagemanager.getImage(fileName: currentsport.rosterimage) { image in
                currentsport.rosterimagedata = image
            }
            
            // checking if club is a favorite
            if currentsport.favoritedusers.contains(userInfo.email) {
                isFavorited = true
            }
            
            // checking permissions
            if userInfo.isSportsAdmin || userInfo.isAdmin || currentsport.adminemails.contains(userInfo.email) {
                hasPermissionSport = true
            }
            
            // formatting stuff
            
        }
    }
}

struct SportsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SportsDetailView(currentsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], editoremails: [], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", favoritedusers: [], eventslink: "", rosterimage: "", rosterimagedata: UIImage(), imagedata: UIImage(), documentID: "NAN", sportid: "SPORT ID",  id: UUID()))
    }
}




