//
//  SportsDetailView.swift
//  West App
//
//  Created by Aiden Lee on 5/20/23.
//

import SwiftUI

struct SportsDetailView: View {
    var permissionsManager = permissionsDataManager()
    var userInfo = UserInfo()
    @State private var hasPermissionSport = false
    @State private var canEditSport = false
    @State var selected = 1
    @State var isFavorited = false
    @State var favoritesManager = FavoriteSports()
    @State var favorites: [sport] = []
    @EnvironmentObject var vm: SportsHibabi.ViewModel
    @StateObject var sporteventmanager = sportEventManager()
    @State private var confirming = false
    @State private var confirming2 = false
    var currentsport: sport
    @State var currentsportID = ""
    @State var upcomingeventslist: [sportEvent] = []
    @State var topthree: [sportEvent] = []
    @ObservedObject var sportfavoritesmanager = FavoriteSportsManager()

    var safeArea: EdgeInsets
    var size: CGSize
    let westyellow = Color(red:248/255, green:222/255, blue:8/255)
    let westblue = Color(red: 41/255, green: 52/255, blue: 134/255)
    //MARK: view
    var body: some View {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    Artwork()
                    // Since We ignored Top Edge
                    GeometryReader{ proxy in
                        let minY = proxy.frame(in: .named("SCROLL")).minY - safeArea.top
                        
                        HStack{
                            Spacer()
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
                                            Text("Add to my Sports")
                                                .foregroundColor(westblue)
                                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                        }.padding(.all, 10)
                                            .background(Color(hue: 0, saturation: 0, brightness: 0.95, opacity: 0.90))
                                            .cornerRadius(10)
                                    }.confirmationDialog("Add to My Sports", isPresented: $confirming) {
                                        Button("Add to My Sports") {
                                            sportfavoritesmanager.addFavorite(sport: currentsport)
                                            favoritesManager.addFavorite(sport: currentsport)
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
                                            Text("Remove Sport")
                                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                        }
                                        .padding(.all, 10)
                                        .background(Color(hue: 0, saturation: 0, brightness: 0.95, opacity: 0.90))
                                        .cornerRadius(10)
                                    }.confirmationDialog("Remove from My Sports", isPresented: $confirming2) {
                                        Button("Remove from My Sports", role: .destructive) {
                                            sportfavoritesmanager.removeFavorite(sport: currentsport)
                                            favoritesManager.removeFavorite(sport: currentsport)
                                            isFavorited = false
                                        }
                                    }
                                }
                            }
                            .padding(.top,-60)
                            .frame(maxWidth: .infinity, maxHeight:.infinity)
                            .offset(y: minY < 50 ? -(minY - 50) : 0)
                            Spacer()
                        }
                    }
                    
                    .zIndex(1)
                    
                    VStack{
                        
                        if canEditSport {
                            NavigationLink {
                                SportsDetailAdminView(editingsport: currentsport)
                            } label: {
                                Text("Edit Sport")
                                    .foregroundColor(.blue)
                                    .padding(10)
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    .background(Rectangle()
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 2, x: 1, y: 1))                        }
                        }

                        
                        Picker(selection: $selected, label: Text(""), content: {
                            Text("Upcoming").tag(1)
                            Text("Members").tag(2)
                            Text("Information").tag(3)

                        })
                        .pickerStyle(SegmentedPickerStyle())


                        if selected == 1{
                            VStack{
                                if canEditSport {
                                    NavigationLink {
                                        SportEventsAdminView(currentsport:  currentsportID)
                                    } label: {
                                        Text("Edit Sport Events")
                                            .foregroundColor(.blue)
                                            .padding(10)
                                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                                            .background(Rectangle()
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                                .shadow(radius: 2, x: 1, y: 1))                        }
                                }
                                VStack {
                                    ForEach(upcomingeventslist) { event in
                                        HStack {
                                            VStack {
                                                Text(sporteventmanager.getDatePart(event: event, part: "month"))
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.red)
                                                Text(sporteventmanager.getDatePart(event: event, part: "day"))
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
                                .foregroundStyle(.black)
                                .padding(.all) //EDIT
                                .background(Rectangle()
                                    .cornerRadius(9.0)
                                    .padding(.horizontal)
                                    .shadow(radius: 5, x: 2, y: 2)
                                            
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                            }
                                .padding(.all)
                                .background(Color(red: 250/255, green: 250/255, blue: 250/255))
                                .cornerRadius(12)
                            }
                        if selected == 2{
                            VStack{
                                NavigationView{
                                    List{
                                        Section{
                                            ForEach(currentsport.sportcoaches, id: \.self){captain in
                                                HStack{
                                                    //Image(systemName: "star")
                                                    Text(captain)
                                                }
                                            }
                                        }
                                        header:{
                                          Text("Coaches")
                                        }
                                        Section{
                                            ForEach(currentsport.sportscaptains, id: \.self){captain in
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
                                            ForEach(currentsport.sportsroster, id: \.self){player in
                                                HStack{
                                                    //Image(systemName: "person.crop.circle")
                                                    Text(player)
                                                }
                                            }
                                        }
                                        header:{
                                            Text("Roster")
                                        }
                                    }

                                }
                            }
                            .padding(.horizontal, -15)
                            .background(.gray)
                            .cornerRadius(12)

                            }
                        if selected == 3{
                            VStack {
                                Text(currentsport.info)
                                    .fontWeight(.semibold)
                            }
                            
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
                .onAppear { // all the shit yyayy
                    currentsportID = ("\(currentsport.sportname) \(currentsport.sportsteam)")
                    sporteventmanager.getSportsEvent(forSport: currentsportID, completion: { events, error in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                        if let events = events {
                            upcomingeventslist = events
                        }
                        
                    })
                    permissionsManager.checkPermissions(dataType: "Sports", user: userInfo.email) { result in
                        canEditSport = result
                    }
                    if currentsport.adminemails.contains(userInfo.email) {
                        canEditSport = true
                    }
                }
                .overlay(alignment: .top) {
                    HeaderView()
                }
            }
            .onAppear {
                favoritesManager.getFavorites { list in
                    for item in list {
                        if "\(currentsport.sportname) \(currentsport.sportsteam)" == item {
                            isFavorited = true
                        }
                    }
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
            
            Image(uiImage: currentsport.imagedata)
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 5)
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
        SportsMainView(selectedsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", imagedata: UIImage(), documentID: "NAN", sportid: "SPORT ID",  id: 1)).environmentObject(SportsHibabi.ViewModel())
    }
}
