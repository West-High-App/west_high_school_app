//
//  ClubsDetailView.swift
//  West App
//
//  Created by Aiden Lee on 5/20/23.
//

import SwiftUI

struct ClubsDetailView: View {
    @State var selected = 1
    var permissionsManager = permissionsDataManager()

    @EnvironmentObject var userInfo: UserInfo
    @State private var hasPermissionClub = false
    @State private var canEditClub = false
    @State var isFavorited = false
    @State var favoritesManager = FavoriteClubs()
    @EnvironmentObject var clubsmanager: clubManager
    @State var favorites: [club] = []
    @EnvironmentObject var vmm: ClubsHibabi.ClubViewModel
    @State private var confirming = false
    @State private var confirming2 = false
    @State var upcomingeventlist: [clubEvent] = [] // supposed to be clubEvent
    @StateObject var clubeventmanager = clubEventManager.shared
    
    @State var hasAppeared = false
    @State var displayedimage: UIImage?
    @State var originalimage = UIImage()
    @StateObject var imagemanager = imageManager()
    
    @EnvironmentObject var clubfavoritesmanager: FavoriteClubsManager
    
    var currentclub: club
    @State var screen = ScreenSize()
    var safeArea: EdgeInsets
    var size: CGSize
    let westyellow = Color(red:248/255, green:222/255, blue:8/255)
    let westblue = Color(red: 41/255, green: 52/255, blue: 134/255)
    var body: some View {
        ScrollView (showsIndicators: false){
            VStack {
                VStack{
                    HStack {
                        Text(currentclub.clubname)
                            .foregroundColor(Color.black)
                            .font(.system(size: 35, weight: .bold, design: .rounded))
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                            .padding(.horizontal)
                        Spacer()
                    }
                    HStack {
                        if currentclub.clubmeetingroom != "" {
                            Text("Room \(currentclub.clubmeetingroom)")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26, weight: .semibold, design: .rounded))
                                .lineLimit(1)
                                .padding(.horizontal)
                        } else {
                            Text("No meeting room")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26, weight: .semibold, design: .rounded))
                                .lineLimit(1)
                                .padding(.horizontal)
                        }
                        Spacer()
                    }
                    
                    VStack {
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                            
                            VStack(spacing: 0) {
                                Image(uiImage: currentclub.imagedata )
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
                    
                    Spacer()
                }
                
                Text(currentclub.clubdescription)
                //saygex
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.black)
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .padding(.horizontal, 25)
                    .padding(.vertical, 5)
                
                Picker(selection: $selected, label: Text(""), content: {
                    Text("Upcoming").tag(1)
                    Text("Members (\(currentclub.clubmembers.count + (currentclub.clubcaptain?.count ?? 0)))").tag(2)
                }).pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                // upcoming events view
                
                if selected == 1 {
                    
                    if hasPermissionClub {
                        NavigationLink {
                            ClubsEventsAdminView(currentclub: currentclub)
                        } label: {
                            Text("Edit Upcoming Events")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                        
                    }
                    if upcomingeventlist.count < 1 {
                        Text("No upcoming events.")
                        Spacer()
                            .frame(height: 100)
                    } else {
                        List {
                            ForEach(clubeventmanager.eventDictionary["\(currentclub.clubname)"] ?? upcomingeventlist, id: \.id) {event in
                                HStack {
                                    VStack {
                                        Text(event.month)
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundColor(.red)
                                        Text(event.day)
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
                    if currentclub.clubadvisor.count == 0 && currentclub.clubcaptain?.count == 0 && currentclub.clubmembers.count == 0 {
                        Text("No members.")
                        Spacer()
                            .frame(height: 100)

                    } else {
                        
                        List{
                            if currentclub.clubadvisor.count > 0 {
                                Section{
                                    ForEach(currentclub.clubadvisor, id: \.self){coach in
                                        HStack{
                                            Text(coach)
                                        }
                                    }
                                }
                                header:{
                                    if currentclub.clubcaptain?.count == 1 {
                                        Text("Coach")
                                    } else {
                                        Text("Coaches")
                                    }
                                }
                            }
                            
                            if currentclub.clubcaptain?.count ?? 0 > 0 {
                                Section {
                                    ForEach(currentclub.clubcaptain!, id: \.self) { captain in
                                        HStack {
                                            Text(captain)
                                        }
                                    }
                                } header:{
                                    if currentclub.clubcaptain?.count ?? 0 == 1 {
                                        Text("Captain")
                                    } else {
                                        Text("Captains")
                                    }
                                }
                            }
                            
                            if currentclub.clubmembers.count > 0 {
                                Section {
                                    ForEach(currentclub.clubmembers
                                            , id: \.self) { member in
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

                
            }.padding(.top, 60) // MARK: this is cheating, works only on SE and iphone 8, change this depending on waht phone you have (100 for 14 pro fx)
            
                .onAppear {
                    // getting events (only once, then it saves)
                    if clubeventmanager.eventDictionary["\(currentclub.clubname)"] == nil {
                        print("accessing club events")
                        print(clubeventmanager.eventDictionary)
                        clubeventmanager.getClubsEvent(forClub: "\(currentclub.clubname)") { events, error in
                            print("GOT FROM FIREBASE")
                            if let events = events {
                                self.upcomingeventlist = events
                            }
                            //saygex
                        }
                    } else {
                        print("What")
                        self.upcomingeventlist = clubeventmanager.eventDictionary["\(currentclub.clubname)"] ?? []
                    }
                    // checking if club is a favorite
                    if currentclub.favoritedusers.contains(userInfo.email) {
                        isFavorited = true
                    }
                    
                    // checking permissions
                    if userInfo.isClubsAdmin || userInfo.isAdmin || currentclub.adminemails.contains(userInfo.email) {
                        hasPermissionClub = true
                    }
                    
                    // formatting stuff
                    
                }
            
                .navigationBarItems(trailing:
                                        Group {
                    HStack {
                        if hasPermissionClub {
                            NavigationLink {
                                ClubDetailAdminView(editingclub: currentclub)
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
                .confirmationDialog("Add to My Clubs", isPresented: $confirming) {
                    Button("Add to My Clubs") {
                        
                        var tempclub = currentclub
                        tempclub.favoritedusers.append(userInfo.email)
                        clubsmanager.updateClub(data: tempclub)
                        clubsmanager.allclublist.removeAll {$0 == currentclub}
                        clubsmanager.allclublist.append(tempclub)
                        
                        isFavorited = true
                    }
                }
            
                .confirmationDialog("Remove from My Clubs", isPresented: $confirming2) {
                    Button("Remove from My Clubs", role: .destructive) {
                        
                        var tempclub = currentclub
                        tempclub.favoritedusers.removeAll {$0 == userInfo.email}
                        clubsmanager.updateClub(data: tempclub)
                        clubsmanager.allclublist.removeAll {$0 == currentclub}
                        clubsmanager.allclublist.append(tempclub)
                        
                        clubsmanager.favoriteslist.removeAll {$0 == currentclub}
                        clubfavoritesmanager.removeFavorite(club: currentclub)
                        favoritesManager.removeFavorite(club: currentclub)
                        isFavorited = false
                    }
                }
        }

    }
        
        
    }


struct ClubsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClubsMainView(selectedclub: club(clubname: "Chess Club", clubcaptain: ["Andrea Botez"], clubadvisor: ["Hiakru Nikamura"], clubmeetingroom: "2013", clubdescription: "For seasoned pros, or newbeginners, chess is a game that everyone can learn and improve at.", clubimage: "chess", clubmembercount: "1", clubmembers: ["John Johnson", "Bob Bobson", "Anders Anderson", "Millie Millson"], adminemails: ["augustelholm@gmail.com"], favoritedusers: [], imagedata: UIImage(), documentID: "documentID", id: 1)).environmentObject(ClubsHibabi.ClubViewModel())
    }
}
