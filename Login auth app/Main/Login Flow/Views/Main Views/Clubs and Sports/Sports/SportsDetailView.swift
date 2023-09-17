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
    @EnvironmentObject var sportsmanager: sportsManager
    @EnvironmentObject var sporteventmanager: sportEventManager
    @State private var hasPermissionSport = false
    @State private var canEditSport = false
    @State var selected = 1
    @State var isFavorited = false
    @State var favoritesManager = FavoriteSports()
    @State var favorites: [sport] = []
    @State var sportEvents: [sportEvent] = []
    @EnvironmentObject var vm: SportsHibabi.ViewModel
    @State private var confirming = false
    @State private var confirming2 = false
    @State var screen = ScreenSize()
    @State var hasAppeared = false
    
    var currentsport: sport
    
    @State var currentsportID = ""
    @State var upcomingeventslist: [sportEvent] = []
    @State var topthree: [sportEvent] = []
    @EnvironmentObject var sportfavoritesmanager: FavoriteSportsManager
    
    var safeArea: EdgeInsets
    var size: CGSize
    let westyellow = Color(red:248/255, green:222/255, blue:8/255)
    let westblue = Color(red: 41/255, green: 52/255, blue: 134/255)
    //MARK: view
    var body: some View {
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
                                    Image(uiImage: currentsport.imagedata!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: screen.screenWidth - 30, height: 250)
                                        .clipped()
                                        .onAppear {
                                            print(currentsport.imagedata)
                                        }
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
                    Text("Members (\(currentsport.sportsroster.count + currentsport.sportscaptains.count))").tag(2)
                }).pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                
                
                // upcoming events view
                
                if selected == 1 {
                    
                    if hasPermissionSport {
                        NavigationLink {
                            SportEventsAdminView(currentsport: "\(currentsport.sportname) \(currentsport.sportsteam)")
                        } label: {
                            Text("Edit Upcoming Events")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                        
                    }
                    if sportEvents.count < 1 {
                        Text("No upcoming events.")
                    } else {
                        List {
                            ForEach(sporteventmanager.eventDictionary["\(currentsport.sportname) \(currentsport.sportsteam)"] ?? sportEvents, id: \.id) {event in
                                HStack {
                                    VStack {
                                        Text(sporteventmanager.getDatePart(event: event, part: "month"))
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundColor(.red)
                                        Text(sporteventmanager.getDatePart(event: event, part: "day"))
                                            .font(.system(size: 26, weight: .regular, design: .rounded))
                                        
                                    }
                                    .frame(width:50,height:50)
                                    Divider()
                                        .padding(.vertical, 10)
                                    VStack(alignment: .leading) {
                                        Text(event.title)
                                            .lineLimit(2)
                                            .font(.system(size: 18, weight: .semibold, design: .rounded)) // semibold
                                        Text(event.subtitle)
                                            .font(.system(size: 18, weight: .regular, design: .rounded))  // regular
                                            .lineLimit(1)
                                    }
                                    .padding(.leading, 5)
                                    Spacer()
                                    
                                }
                            }
                        }.frame(height: 450)
                    }
                    
                }
                
                // members view
                
                if selected == 2 {
                    
                    if currentsport.sportcoaches.count == 0 && currentsport.sportscaptains.count == 0 && currentsport.sportsroster.count == 0 {
                        Text("No members.")
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
                
                
            }.padding(.top, 100)
            
                .onAppear {
                    // getting events (only once, then it saves)
                    if sporteventmanager.eventDictionary["\(currentsport.sportname) \(currentsport.sportsteam)"] == nil {
                        sporteventmanager.getSportsEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)") { events, error in
                            if let events = events {
                                self.sportEvents = events
                            }
                        }
                    } else {
                        self.sportEvents = sporteventmanager.eventDictionary["\(currentsport.sportname) \(currentsport.sportsteam)"] ?? []
                    }
                    
                    // checking if club is a favorite
                    if sportsmanager.favoriteslist.contains(currentsport) {
                        self.isFavorited = true
                    }
                    for sport in sportsmanager.favoriteslist {
                        let currentsportid = "\(currentsport.sportname) \(currentsport.sportsteam)"
                        if currentsportid == "\(sport.sportname) \(sport.sportsteam)" {
                            self.isFavorited = true
                        }
                    }
                    
                    // checking permissions
                    if userInfo.isSportsAdmin || userInfo.isAdmin || currentsport.adminemails.contains(userInfo.email) {
                        hasPermissionSport = true
                    }
                    
                    // formatting stuff
                    
                }
            
                .navigationBarItems(trailing:
                                        Group {
                    HStack {
                        if hasPermissionSport {
                            NavigationLink {
                                SportsDetailAdminView(editingsport: currentsport)
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
                        sportsmanager.favoriteslist.append(currentsport)
                        sportfavoritesmanager.addFavorite(sport: currentsport)
                        favoritesManager.addFavorite(sport: currentsport)
                        isFavorited = true
                    }
                }
            
                .confirmationDialog("Remove from My Sports", isPresented: $confirming2) {
                    Button("Remove from My Sports", role: .destructive) {
                        sportsmanager.favoriteslist.removeAll {$0 == currentsport}
                        sportfavoritesmanager.removeFavorite(sport: currentsport)
                        favoritesManager.removeFavorite(sport: currentsport)
                        isFavorited = false
                    }
                }
        }
    }
    
    
    // MARK: dumb shit
    @ViewBuilder
    func Artwork() -> some View {
        let height = size.height * 0.65
        GeometryReader{ proxy in
            
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            
            Image(uiImage: currentsport.imagedata ?? UIImage())
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0 ))
                .clipped()
                .overlay(content: {
                    ZStack(alignment: .bottom) {
                        // MARK: - Gradient Overlay
                        Rectangle()
                            .fill(
                                .linearGradient(colors: [
                                    westblue.opacity(0 - progress),
                                    westblue.opacity(0 - progress),
                                    westblue.opacity(0.05 - progress),
                                    westblue.opacity(0.1 - progress),
                                    westblue.opacity(0.5 - progress),
                                    westblue.opacity(1),
                                ], startPoint: .top, endPoint: .bottom)
                            )
                        VStack(spacing: 0) {
                            Text(currentsport.sportname)
                                .font(                                .custom("Trebuchet MS", fixedSize: 60))
                                .foregroundStyle(westyellow)
                                .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Text(currentsport.sportsteam)
                                .bold()
                                .font(
                                    .custom("Apple SD Gothic Neo", fixedSize: 30))
                                .foregroundStyle(westyellow)
                                .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)

                        }
                        .opacity(1 + (progress > 0 ? -progress : progress))
                        .padding(.bottom, 65)
                        
                        // Moving with Scroll View
                        
                        .offset(y: minY < 0 ? minY : 0 )
                    }
                })
            
                .offset(y: -minY)
            
            
             
        }
        .frame(height: height + safeArea.top )
    }
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader{ proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let height = size.height * 0.45
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            let titleProgress =  minY / height
            
            HStack {
                Spacer(minLength: 0)
                
//                HStack{
//                    VStack{
//                        Text(currentclub.clubmeetingroom)
//                            .font(                                .custom("Apple SD Gothic Neo", fixedSize: 32))
//                            .foregroundStyle(westblue)
//                            .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
//                            .offset(y: -titleProgress < 0.75 ? 0 : 100)
//                            .animation(.easeOut(duration: 0.55), value: -titleProgress > 0.75)
//                            .opacity(1 + (progress > 0 ? -progress : progress))
//                        Spacer()
//                    }
//                    .padding(.leading)
//                    Spacer()
//                }
            }
            .overlay(content: {
                Text(currentsport.sportname)
                    .font(                                .custom("Apple SD Gothic Neo", fixedSize: 60))
                    .bold()
                    .foregroundStyle(westyellow)
                    .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                    .offset(y: -titleProgress > 1 ? 0 : 80)
                    .clipped()
                    .animation(.easeOut(duration: 0.25), value: -titleProgress > 1)
            })
            .padding(.top,70)

            //.padding([.horizontal,.bottom], 15)
            //.padding(safeArea.top + 20)
//THIS PLACE IS THE LOGO DRAG EFFECT
            //.background(
             //   Color.blue
              //      .opacity(-progress > 1 ? 1 : 0)
            //)
            
            .offset(y: -minY)
            
            
            
        }
        .frame(height: 35)
    }
    }

struct SportsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            SportsDetailView(currentsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", imagedata: nil, documentID: "NAN", sportid: "SPORT ID",  id: 1), safeArea: safeArea, size: size)
        }
    }
}
