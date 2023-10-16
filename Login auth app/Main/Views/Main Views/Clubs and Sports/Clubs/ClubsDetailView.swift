//
//  ClubsDetailView.swift
//  West App
//
//  Created by Aiden Lee on 5/20/23.
//

import SwiftUI

struct ClubsDetailView: View {
    @State var selected = 1

    @ObservedObject var hasPermission = PermissionsCheck.shared
    @EnvironmentObject var userInfo: UserInfo
    @State private var isAdmin = false
    @State private var isEditor = false
    @State private var canEditClub = false
    @State var isFavorited = false
    @State var favoritesManager = FavoriteClubs()
    @EnvironmentObject var clubsmanager: clubManager
    @State var favorites: [club] = []
    @EnvironmentObject var vmm: ClubsHibabi.ClubViewModel
    @State private var confirming = false
    @State private var confirming2 = false
    var upcomingeventlist: [clubEvent] {
        self.clubeventmanager.clubsEvents
    }
    @ObservedObject var clubeventmanager = clubEventManager.shared
    
    @State var hasAppeared = false
    @State var displayedimage: UIImage?
    @State var originalimage = UIImage()
    @StateObject var imagemanager = imageManager()
    
    @EnvironmentObject var clubfavoritesmanager: FavoriteClubsManager
    
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
                    if isAdmin {
                        NavigationLink {
                            ClubsEventsAdminView(currentclub: currentclub, admin: true)
                        } label: {
                            Text("Edit Upcoming Events")
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
                    } else if isEditor {
                        NavigationLink {
                            ClubsEventsAdminView(currentclub: currentclub, admin: false)
                        } label: {
                            Text("Edit Upcoming Events")
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
                    if upcomingeventlist.count < 1 {
                             Text("No upcoming events.")
                                 .lineLimit(1)
                                 .font(.system(size: 22, weight: .semibold, design: .rounded))
                                 .padding(.leading, 5)
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
                    if userInfo.hasFullViewAccess {
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
                else {
                    Text("Members not available.")
                        .lineLimit(1)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .padding(.leading, 5)
                }
                    
                }

                
            }.padding(.top, 10 + screen.screenHeight / 10)
            
                .onAppear {
                    // getting events (only once, then it saves)
                    
                    clubeventmanager.getClubsEvent(forClub: "\(currentclub.clubname)")
                    // checking if club is a favorite
                    if currentclub.favoritedusers.contains(userInfo.email) {
                        isFavorited = true
                    }
                    
                    // checking permissions
                    if hasPermission.clubs || currentclub.adminemails.contains(userInfo.email) {
                        isAdmin = true
                    }
                    
                    if currentclub.editoremails.contains(userInfo.email) {
                        isEditor = true
                    } else {
                        print(currentclub.editoremails)
                        print(userInfo.email)
                        print("doesn't match")
                    }
                    
                    
                    // formatting stuff
                    
                }
            
                .navigationBarItems(trailing:
                                        Group {
                    HStack {
                        if isAdmin {
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
                .confirmationDialog("Add to Favorites", isPresented: $confirming) {
                    Button("Add to Favorites") {
                        
                        var tempclub = currentclub
                        tempclub.favoritedusers.append(userInfo.email)
                        print("1")
                        clubsmanager.allclublist.removeAll {$0 == currentclub} //
                        print("2")
                        clubsmanager.allclublist.append(tempclub) //
                        print("3")
                        print(tempclub)
                        clubsmanager.updateClub(data: tempclub) // this is the error

                        isFavorited = true
                    }
                }
            
                .confirmationDialog("Remove from Favorites", isPresented: $confirming2) {
                    Button("Remove from Favorites", role: .destructive) {
                        
                        var tempclub = currentclub
                        tempclub.favoritedusers.removeAll {$0 == userInfo.email}
                        clubsmanager.allclublist.removeAll {$0 == currentclub}
                        clubsmanager.allclublist.append(tempclub)
                        clubsmanager.updateClub(data: tempclub)
                        
                        clubsmanager.favoriteslist.removeAll {$0 == currentclub}
                        isFavorited = false
                    }
                }
        }

    }
        
        
    }


struct ClubsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClubsMainView(selectedclub: club(clubname: "Chess Club", clubcaptain: ["Andrea Botez"], clubadvisor: ["Hiakru Nikamura"], clubmeetingroom: "2013", clubdescription: "For seasoned pros, or newbeginners, chess is a game that everyone can learn and improve at.", clubimage: "chess", clubmembercount: "1", clubmembers: ["John Johnson", "Bob Bobson", "Anders Anderson", "Millie Millson"], adminemails: ["augustelholm@gmail.com"], editoremails: [], favoritedusers: [], imagedata: UIImage(), documentID: "documentID", id: 1)).environmentObject(ClubsHibabi.ClubViewModel())
    }
}
