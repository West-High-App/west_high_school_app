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
    var userInfo = UserInfo()
    @State private var hasPermissionClub = false
    @State private var canEditClub = false
    @State var isFavorited = false
    @State var favoritesManager = FavoriteClubs()
    @State var clubsmanager = clubManager()
    @State var favorites: [club] = []
    @EnvironmentObject var vmm: ClubsHibabi.ClubViewModel
    @State private var confirming = false
    @State private var confirming2 = false
    @State var upcomingeventlist: [sportEvent] = [] // supposed to be clubEvent
    @StateObject var clubeventmanager = clubEventManager()
    
    @State var hasAppeared = false
    @State var displayedimage: UIImage?
    @State var originalimage = UIImage()
    @StateObject var imagemanager = imageManager()
    
    @EnvironmentObject var clubfavoritesmanager: FavoriteClubsManager
    
    var currentclub: club
    
    var safeArea: EdgeInsets
    var size: CGSize
    let westyellow = Color(red:248/255, green:222/255, blue:8/255)
    let westblue = Color(red: 41/255, green: 52/255, blue: 134/255)
    var body: some View {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    // MARK: - Artwork
                    Artwork()
                    GeometryReader{ proxy in
                        let minY = proxy.frame(in: .named("SCROLL")).minY - safeArea.top
                        
                        VStack {
                            if isFavorited == false {
                                Button {
                                    confirming = true
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.app")
                                            .resizable()
                                            .foregroundColor(westblue)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 24)
                                        Text("Add to my Clubs")
                                            .foregroundColor(westblue)
                                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    }.padding(.all, 10)
                                        .background(Color(hue: 0, saturation: 0, brightness: 0.95, opacity: 0.90))
                                        .cornerRadius(10)
                                }.confirmationDialog("Add to My Clubs", isPresented: $confirming) {
                                    Button("Add to My Clubs") {
                                        clubfavoritesmanager.addFavorite(club: currentclub)
                                        favoritesManager.addFavorite(club: currentclub)
                                        isFavorited = true
                                    }
                                }
                            } else {
                                Button (role: .destructive){
                                    confirming2 = true
                                } label: {
                                    HStack {
                                        Image(systemName: "xmark.app")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 24)
                                        Text("Remove Club")
                                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    }
                                    .padding(.all, 10)
                                        .background(Color(hue: 0, saturation: 0, brightness: 0.95, opacity: 0.90))
                                        .cornerRadius(10)
                                }.confirmationDialog("Remove from My Clubs", isPresented: $confirming2) {
                                    Button("Remove from My Clubs", role: .destructive) {
                                        clubfavoritesmanager.removeFavorite(club: currentclub)
                                        favoritesManager.removeFavorite(club: currentclub)
                                        isFavorited = false
                                    }
                                }
                            }
                        }
                        .padding(.top,-60)
                        .frame(maxWidth: .infinity, maxHeight:.infinity)
                        .offset(y: minY < 50 ? -(minY - 50) : 0)
                    }
                    .zIndex(1)
                    
                    VStack{
                        Text(currentclub.clubdescription)
                            .padding(.vertical, 2)
                            .foregroundStyle(westblue)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))

                        Picker(selection: $selected, label: Text(""), content: {
                            Text("Upcoming").tag(1)
                            Text("Members").tag(2)

                        })
                        .pickerStyle(SegmentedPickerStyle())


                        if selected == 1{
                            VStack {
                                
                                if hasPermissionClub {
                                    NavigationLink {
                                        ClubsEventsAdminView(currentclub: currentclub.clubname)
                                    } label: {
                                        Text("Edit Club Events")
                                            .foregroundColor(.blue)
                                            .padding(10)
                                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                                            .background(Rectangle()
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                                .shadow(radius: 2, x: 1, y: 1))                        }
                                }

                                ForEach(upcomingeventlist) { event in
                                    HStack {
                                        VStack {
                                            Text(clubeventmanager.getDatePart(event: event, part: "month"))
                                                .font(.system(size: 14))
                                                .foregroundColor(.red)
                                            Text(clubeventmanager.getDatePart(event: event, part: "day"))
                                                .font(.system(size: 24))
                                        }.padding(.vertical, -5)
                                            .padding(.leading, 20)
                                            .padding(.trailing, 10)
                                        Divider()
                                        VStack(alignment: .leading) {
                                            Text(event.title)
                                                .fontWeight(.semibold)
                                            Text(event.subtitle)
                                        }.padding(.vertical, -5)
                                            .padding(.horizontal)
                                        Spacer()
                                    }
                                    Divider()
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                }
                                
                            }

                            }
                        if selected == 2{
                            VStack{
                                NavigationView{
                                    List{
                                        Section{
                                            ForEach(currentclub.clubadvisor, id: \.self){captain in
                                                HStack{
                                                    //Image(systemName: "star")
                                                    Text(captain)
                                                }
                                            }
                                        }
                                        header:{
                                          Text("Advisors")
                                        }
                                        Section{
                                            ForEach(currentclub.clubcaptain!, id: \.self){captain in
                                                HStack{
                                                    //Image(systemName: "star")
                                                    Text(captain)
                                                }
                                            }
                                        }
                                        header:{
                                            Text("Captains")
                                        }
                                        Section{
                                            ForEach(currentclub.clubmembers, id: \.self){player in
                                                HStack{
                                                    //Image(systemName: "person.crop.circle")
                                                    Text(player)
                                                }
                                            }
                                        }
                                        header:{
                                            Text("Members")
                                        }
                                    }

                                }
                            }
                            .padding(.horizontal, -15)
                            .background(.gray)
                            .cornerRadius(12)

                            }
                    }
                    .padding()
                    .background(Rectangle()
                        .cornerRadius(20.0)
                        //.padding(.leading,20)
                        .shadow(radius: 10)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                    .padding(.horizontal)
                    
                }
                .onAppear {
                    clubeventmanager.getClubsEvent(forClub: currentclub.clubname) { events, error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        if let events = events {
                            var tempp: [sportEvent] = []
                            for item in events {
                                
                                tempp.append(sportEvent(documentID: item.documentID, title: item.title, subtitle: item.subtitle, date: item.date))
                                
                            }
                            upcomingeventlist = tempp
                        }
                    }
                    
                    favoritesManager.getFavorites { list in
                        for item in list {
                            if currentclub.clubname == item {
                                isFavorited = true
                            }
                        }
                    }
                    
                    permissionsManager.checkPermissions(dataType: "Clubs", user: userInfo.email) { permission in
                        hasPermissionClub = permission
                    }
                    if currentclub.adminemails.contains(userInfo.email) {
                        hasPermissionClub = true
                    }
                    
                    
                    
                        imagemanager.getImageFromStorage(fileName: currentclub.clubimage) { image in
                            displayedimage = image
                            originalimage = image ?? UIImage()
                    }
                    
                }
                .overlay(alignment: .top) {
                    HeaderView()
                }
            }
            .background(westblue)
            .coordinateSpace(name: "SCROLL")
    }

    @ViewBuilder
    func Artwork() -> some View {
        let height = size.height * 0.65
        GeometryReader{ proxy in
            
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            
            Image(uiImage: currentclub.imagedata)
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0 ))
                .clipped()
                .ignoresSafeArea()
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
                            Text(currentclub.clubname)
                                .font(                                .custom("Trebuchet MS", fixedSize: 60))
                                .foregroundStyle(westyellow)
                                .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Text(currentclub.clubmeetingroom)
                                .bold()
                                .font(
                                    .custom("Apple SD Gothic Neo", fixedSize: 30))
                                .foregroundStyle(westyellow)
                                .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                            Text(currentclub.clubmembercount + " members"
                                .uppercased())
                                .font(                                .custom("Apple SD Gothic Neo", fixedSize: 24))
                                .bold()
                                .foregroundStyle(westyellow)
                                .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                            
                            if hasPermissionClub {
                                NavigationLink {
                                    ClubDetailAdminView(editingclub: currentclub)
                                } label: {
                                    Text("Edit Club")
                                        .foregroundColor(.blue)
                                        .padding(10)
                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                                        .background(Rectangle()
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 2, x: 1, y: 1))                        }
                            }

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
                Text(currentclub.clubname)
                    .font(                                .custom("Apple SD Gothic Neo", fixedSize: 60))
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


struct ClubsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClubsMainView(selectedclub: clubManager().allclublist.first!).environmentObject(ClubsHibabi.ClubViewModel())
    }
}
