//
//  SportsDetailView.swift
//  West App
//
//  Created by Aiden Lee on 5/20/23.
//

import SwiftUI

struct SportsDetailView: View {
    var permissionsManager = permissionsDataManager()
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var sportsmanager: sportsManager // <------
    @EnvironmentObject var sporteventmanager: sportEventManager
    @EnvironmentObject var sporteventstorage: SportsEventStorage
    @State private var hasPermissionSport = false
    @State private var canEditSport = false
    @State var selected = 1
    @State var isFavorited = false
    @State var favorites: [sport] = []
    @State var sportEvents: [sportEvent] = []
    @State var pastSportEvents: [sportEvent] = []
    @EnvironmentObject var vm: SportsHibabi.ViewModel
    @State private var confirming = false
    @State private var confirming2 = false
    @State var screen = ScreenSize()
    @State var hasAppeared = false
    @State private var navigationBarHeight: CGFloat = 0.0
    @State var events: [ParsedEvent] = []
    @State var pastevents: [ParsedEvent] = []
    @State var newpastevents: [sportEvent] = []
    
    @State var isLoading = false
    
    let currentsport: sport
    
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
                        if !sportEvents.isEmpty { // calls it past events if it's a weird sport like cross country
                            if sportEvents[0].isSpecial {
                                Text("Past Events").tag(2)
                            } else {
                                Text("Past Games").tag(2)
                            }
                        } else {
                            Text("Past Games").tag(2)
                        }
                        Text("Members (\(currentsport.sportsroster.count + currentsport.sportscaptains.count))").tag(3)
                    }).pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                    
                    
                    // upcoming events view
                    
                    if selected == 1 {
                        if !isLoading {
                        //MARK: Aiden to the UI for this:
                        /// I think you have a pretty good idea of what needs to happen or what needs to be displayed. Basically just use the elements: date, type (like game, tournament, meet, etc.), opponent, and comments. You can change the date format using .formatted property.
                        
                        if events.isEmpty {
                            Text("No upcoming events.")
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .frame(maxHeight: .infinity)
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
                                                    .minimumScaleFactor(0.8)
                                                    .font(.system(size: 18, weight: .semibold, design: .rounded)) // semibold

                                                Spacer()
                                            }
                                            HStack {
                                                Text("\(event.opponent)")
                                                    .minimumScaleFactor(0.8)

                                                    .font(.system(size: 18, weight: .regular, design: .rounded))  // regular

                                                
                                                Spacer()
                                            }
                                            
                                            DisclosureGroup("See More") {
                                                HStack {
                                                    Image(systemName: "clock")
                                                        .resizable()
                                                        .frame(width: 15, height: 15)
                                                    Text("\(event.date.formatted(date: .omitted, time: .shortened))")
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
                        if currentsport.editoremails.contains(userInfo.email) || currentsport.adminemails.contains(userInfo.email) || userInfo.isAdmin || userInfo.isSportsAdmin {
                            NavigationLink {
                                PastSportEventsAdminView(currentsport: currentsport)
                            } label: {
                                Text("Edit Past Events")
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
                        
                        if sporteventmanager.pastSportsEvents.isEmpty {
                            Text("No past events.")
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .frame(maxHeight: .infinity)
                        } else {
                            List(sporteventmanager.pastSportsEvents, id: \.id) { event in
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
                                    VStack (alignment: .leading){
                                        Text(event.title)
                                            .font(.headline)
                                        if !event.isSpecial {
                                            Text(event.subtitle)
                                            HStack {
                                                if event.score.count > 1 {
                                                    if event.score[0] == 0 && event.score[1] == 0 {
                                                        Text("Pending score...")
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
                                                    Text("Pending score...")
                                                }
                                            }
                                        } else {
                                            Text(event.subtitle)
                                        }
                                    }
                                }
                            }
                            .frame(height: 450)
                        }
                    }
                    
                    // members view
                    
                    if selected == 3 {
                        
                        if currentsport.sportcoaches.count == 0 && currentsport.sportscaptains.count == 0 && currentsport.sportsroster.count == 0 {
                            Text("No members.")
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .frame(maxHeight: .infinity)
                        } else {
                            
                            List{
                                if currentsport.sportcoaches.count > 0 {
                                    Section{
                                        ForEach(currentsport.sportcoaches, id: \.self){coach in
                                            HStack{
                                                Text(coach)
                                            }
                                        }
                                    }
                                header:{
                                    if currentsport.sportcoaches.count == 1 {
                                        Text("Coach")
                                    } else {
                                        Text("Coaches")
                                    }
                                }
                                }
                                
                                if currentsport.sportscaptains.count > 0 {
                                    Section {
                                        ForEach(currentsport.sportscaptains, id: \.self) { captain in
                                            HStack {
                                                Text(captain)
                                            }
                                        }
                                    } header:{
                                        if currentsport.sportscaptains.count == 1 {
                                            Text("Captain")
                                        } else {
                                            Text("Captains")
                                        }
                                    }
                                }
                                
                                if currentsport.sportsroster.count > 0 {
                                    Section {
                                        ForEach(currentsport.sportsroster, id: \.self) { member in
                                            HStack {
                                                Text(member)
                                            }
                                        }
                                    } header: {
                                        Text("Members")
                                    }
                                }
                                
                            }.frame(height: 450)
                        }
                    }
                    
                    
                }.padding(.top, 10 + screen.screenHeight / 10) // padding was here
                
                .onAppear {
                    
                    //if sportsev MARK: run the dict functino before view appear
                    if sporteventstorage.sportsevents["\(currentsport.sportname) \(currentsport.sportsteam)"] == nil {
                        isLoading = true
                        HTMLParser.parseEvents(from: currentsport.eventslink) { parsedevents, error in
                            if let parsedevents = parsedevents {
                                let currentDate = Date()
                                let futureEvents = parsedevents.filter { event in
                                    return event.date > currentDate
                                }

                                let pastEvents = parsedevents.filter { event in
                                    return event.date <= currentDate
                                }

                                let sortedFutureEvents = futureEvents.sorted { (event1, event2) -> Bool in
                                    return event1.date < event2.date
                                }

                                let sortedPastEvents = pastEvents.sorted { (event1, event2) -> Bool in
                                    return event1.date > event2.date
                                }


                                self.events = sortedFutureEvents
                                self.events = self.events.sorted(by: {
                                    $0.date.compare($1.date) == .orderedDescending
                                })
                                self.events = self.events.reversed()
                                
                                sporteventstorage.sportsevents["\(currentsport.sportname) \(currentsport.sportsteam)"] = sortedFutureEvents
                                

                                self.pastevents = sortedPastEvents
                                self.pastevents = self.pastevents.sorted(by: {
                                    $0.date.compare($1.date) == .orderedDescending
                                })
                                self.pastevents = self.pastevents.reversed()
                                self.isLoading = false
                                sporteventmanager.getSportsEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)") { events, error in
                                    
                                }
                                
                                
                            } else if let error = error {
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                        
                    } else {
                        self.events = sporteventstorage.sportsevents["\(currentsport.sportname) \(currentsport.sportsteam)"] ?? []
                    }
                    
//                    // moved
//                    sporteventmanager.getSportsEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)") { events, error in
//                        
//                        for existingevent in self.pastevents {
//                            print("EVENT EXISTS")
//                            print(existingevent)
//                            if let matchingEvent = events?.first(where: { newEvent in
//                                
//                                let dateFormatter = DateFormatter()
//                                dateFormatter.dateFormat = "MMM d, yyyy"
//                                
//                                let existingeventformatteddate = dateFormatter.string(from: existingevent.date)
//                                let neweventformatteddate = dateFormatter.string(from: newEvent.date)
//                                
//                                return existingevent.type == newEvent.title && existingevent.opponent == newEvent.subtitle && existingeventformatteddate == neweventformatteddate
//                                
//                            }) {} else {
//                                print("adding new bitch")
//                                sporteventmanager.createParsedSportEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: existingevent)
//                            }
//                        }
                        sporteventmanager.getSportsEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)") { newevents, error in
                            if let newevents = newevents {
                                print(newpastevents)
                                print("NEW PAST EVENTS")
                            }
                        }
//                    }
                                        
//                    // getting events (only once, then it saves)
//                    if sporteventmanager.eventDictionary["\(currentsport.sportname) \(currentsport.sportsteam)"] == nil {
//                        sporteventmanager.getSportsEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)") { events, error in
//                            if let events = events {
//                                self.sportEvents = events
//                            }
//                        }
//                    } else {
//                        self.sportEvents = sporteventmanager.eventDictionary["\(currentsport.sportname) \(currentsport.sportsteam)"] ?? []
//                    }
                    
                    if sporteventmanager.pastEventDictionary["\(currentsport.sportname) \(currentsport.sportsteam)"] == nil {
                        sporteventmanager.getPastSportsEvents(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)") { events, error in
                            if let events = events {
                                self.pastSportEvents = events
                            }
                        }
                    } else {
                        self.pastSportEvents = sporteventmanager.pastSportsEvents
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
                .navigationDestination(isPresented: $isEditing, destination: {
                    SportsDetailAdminView(editingsport: currentsport)
                        .environmentObject(sportsmanager)
                })
                
                .navigationBarItems(trailing:
                                        Group {
                    HStack {
                        if hasPermissionSport {
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
                .confirmationDialog("Add to My Sports", isPresented: $confirming) {
                    Button("Add to My Sports") {
                        // hello
                        var tempsport = currentsport // sets a temp sport
                        tempsport.favoritedusers.append(userInfo.email) // adds the user to favorited sports of the temp sport
                        sportsmanager.updateSport(data: tempsport) // updates the firebase of old sport to be new sport
                        sportsmanager.allsportlist.removeAll {$0 == currentsport} // removes the old sport from allsportslist
                        sportsmanager.allsportlist.append(tempsport) // append new updated sport to allsportslist
                        isFavorited = true
                    }
                }
                
                .confirmationDialog("Remove from My Sports", isPresented: $confirming2) {
                    Button("Remove from My Sports", role: .destructive) {
                        
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
    }
    }

struct SportsDetailView_Previews: PreviewProvider {
    static var previews: some View {
            SportsDetailView(currentsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], editoremails: [], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", favoritedusers: [], eventslink: "", imagedata: UIImage(), documentID: "NAN", sportid: "SPORT ID",  id: 1))
    }
}




