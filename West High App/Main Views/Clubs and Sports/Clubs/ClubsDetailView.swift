//
//  ClubsDetailView.swift
//  West App
//
//  Created by Aiden Lee on 5/20/23.
//

import SwiftUI

struct ClubsDetailView: View {
    
    var currentclub: club
    
    @EnvironmentObject var userInfo: UserInfo
    
    @ObservedObject var hasPermission = PermissionsCheck.shared
    @State private var isAdmin = false
    @State private var isEditor = false
    
    @State var isFavorited = false
    
    @EnvironmentObject var clubsmanager: clubManager
    
    @State private var confirming = false
    @State private var confirming2 = false
    
    var upcomingeventlist: [clubEvent] {
        self.clubeventmanager.clubsEvents
    }
    
    @ObservedObject var clubeventmanager = clubEventManager.shared
            
    @State var screen = ScreenSize()
    
    var body: some View {
        ScrollView{
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
                    if currentclub.imagedata != UIImage() {
                        VStack {
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 0) {
                                    Image(uiImage: currentclub.imagedata)
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
                
                Text(currentclub.clubdescription)
                //saygex
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.black)
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .padding(.horizontal, 25)
                    .padding(.vertical, 5)
                
                
                Divider()
                    .frame(width: screen.screenWidth / 2, height: 2)
                
                VStack {
                    HStack {
                        Text("Upcoming Events")
                            .lineLimit(1)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .padding(.leading, 15)
                            .padding(.top, 10)
                        
                        if isAdmin || isEditor {
                            NavigationLink {
                                ClubsEventsAdminView(currentclub: currentclub, admin: isAdmin ? true : false)
                            } label : {
                                Text("(Edit)")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    .padding(.leading, 5)
                                    .padding(.top, 10)
                            }
                        }
                        
                    }
                    Spacer()
                }
                
                if upcomingeventlist.count < 1 {
                    VStack {
                        HStack {
                            Spacer()
                            Text("No upcoming events.")
                                .lineLimit(1)
                                .font(.system(size: 20, weight: .regular, design: .rounded))
                                .padding(.leading, 15)
                            Spacer()
                        }
                        Spacer()
                    }.frame(height: 450)
                } else {
                    ScrollView { // List
                        ForEach(clubeventmanager.eventDictionary["\(currentclub.clubname)"] ?? upcomingeventlist, id: \.id) { event in
                            
                            if let eventDate = event.date {
                                HStack {
                                    VStack {
                                        Text(eventDate.monthName)
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundColor(.red)
                                        Text("\(eventDate.dateComponent(.day))")
                                            .font(.system(size: 26, weight: .regular, design: .rounded))
                                        
                                    }
                                    .padding(.leading, 20)
                                    .frame(width:60,height:50)
                                    Divider()
                                        .padding(.horizontal, 5)
                                    VStack(alignment: .leading) {
                                        Text(event.title)
                                            .minimumScaleFactor(0.8)
                                            .lineLimit(2)
                                            .font(.system(size: 18, weight: .semibold, design: .rounded)) // semibold
                                        if event.isAllDay {
                                            Text("All Day")
                                                .minimumScaleFactor(0.8)
                                                .font(.system(size: 18, weight: .regular, design: .rounded))  // regular
                                                .lineLimit(1)
                                        } else {
                                            Text(eventDate.twelveHourTime)
                                                .minimumScaleFactor(0.8)
                                                .font(.system(size: 18, weight: .regular, design: .rounded))  // regular
                                                .lineLimit(1)
                                        }
                                    }
                                    .padding(.leading, 5)
                                    Spacer()
                                    
                                }
                                .padding(.vertical, 12) // comment below + 10
                                .background(Rectangle()
                                    .cornerRadius(15.0)
                                    .shadow(color: Color.black.opacity(0.25), radius: 3, x: 1, y: 1)
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
                                    .padding(.vertical, 2) // 5
                                )
                                .padding(.horizontal, 5) // gone
                            }
                        }
                    }.frame(width: screen.screenWidth - 40, height: 450) // 30
                }
            }
        }
        
        .navigationBarTitleDisplayMode(.inline)
        
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
            }
        }
        
        .navigationBarItems(trailing: Group {
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
        })
        
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


#if DEBUG
struct ClubsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClubsMainView(selectedclub: 
            club(
                clubname: "Untitled Club",
                clubcaptain: ["Person 1"],
                clubadvisor: ["Person 2"],
                clubmeetingroom: "100",
                clubdescription: "Club description...",
                clubimage: "",
                clubmembercount: "3",
                clubmembers: ["Person 3", "Person 4"],
                adminemails: [""],
                editoremails: [],
                favoritedusers: [],
                imagedata: UIImage(),
                documentID: "",
                id: 0))
    }
}
#endif
