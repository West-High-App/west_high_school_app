//
//  ActivitiesView.swift
//  West App
//
//  Created by Aiden Lee on 5/19/23.
//

import SwiftUI
import Shimmer

struct ClubsHibabi: View {
    
    @ObservedObject var hasPermission = PermissionsCheck.shared
    @EnvironmentObject var userInfo: UserInfo
    @StateObject var clubsmanager = clubManager.shared 
    @StateObject var clubfavoritesmanager = FavoriteClubsManager()

    @ObservedObject var clubNewsManager = clubsNewslist.shared
    @State var newstitlearray:[clubNews] = []
    @StateObject var vmm = ClubViewModel()
    @State var clubsearchText = "" // text for search field
    @State var clubselected = 1 // which tab is selected
    @State var clubisFiltering = false
    @State var clubisFilteringNews = false
    @State var clubtempSelection = 1
    @State var clubshowingAllNews = 1
    @State private var clubcount = 0
    @State var favoriteclublist: [club] = []
    
    var hasFavorites: Bool {
        var returnvalue = false
        for item in clubsmanager.allclublist {
            if item.favoritedusers.contains(userInfo.email) {
                returnvalue = true
            }
        }
        return returnvalue
        
    }

    @State private var isLoading = false
    
    @State private var hasAppeared = false
    @State var imagemanager = imageManager()

    class ScreenSize {
        let screen: CGRect
        let screenWidth: CGFloat
        let screenHeight: CGFloat
        
        init() {
            screen = UIScreen.main.bounds
            screenWidth = screen.width
            screenHeight = screen.height
        }
    }
    class UsefulColors {
        let background = Color(UIColor.systemBackground)
    }
    let Colors = UsefulColors()
    let Screen = ScreenSize()
    private var filteredclubs: [club] {
        return clubsearchText == ""
        ? clubsmanager.allclublist
        : clubsmanager.allclublist.filter {
                $0.clubname.lowercased().contains(clubsearchText.lowercased())
            }
    }
    
    @State var favoritesManager = FavoriteClubs()
    @State var favorites: [club] = []
    @State var searchText = ""
    @State var imagesManager = imageManager()
    
    private var filteredClubs: [club] {
        return searchText == ""
        ? clubsmanager.allclublist
            : clubsmanager.allclublist.filter {
                $0.clubname.lowercased().contains(searchText.lowercased())
            }
    }
    
    private var filteredClubsNews: [clubNews] {
        return searchText == ""
        ? clubNewsManager.allclubsnewslist
            : clubNewsManager.allclubsnewslist.filter {
                $0.newstitle.lowercased().contains(searchText.lowercased())
            }
        
    }
    func filteredList(fromList list: [club]) -> [club]{
        let filteredlist = list.sorted { $0.clubname.lowercased() < $1.clubname.lowercased() }
        return filteredlist

    }
    
    var hasResults: Bool {
        var bool = false
        for item in filteredList(fromList: clubsmanager.allclublist) {
            if clubsearchText.isEmpty || item.clubname.localizedStandardContains(clubsearchText) {
                if (item.favoritedusers.contains(userInfo.email) && clubselected == 1) || clubselected == 2 {
                    bool = true
                }
            }
        }
        return bool
    }
    
    var hasResultsNews: Bool {
        var bool = false
        for news in clubNewsManager.allclubsnewslist {
            if searchText.isEmpty || news.newstitle.localizedStandardContains(searchText){
                if news.isApproved {
                    bool = true
                }
            }
        }
        return bool
    }
    
        // MARK: view
    var body: some View {
            ZStack {
                NavigationStack {
                    ZStack {
                        VStack {
                            
                            Picker(selection: $clubselected, label: Text(""), content: { // picker at top
                                if userInfo.loginStatus == "Google" {
                                    Text("Favorites").tag(1)
                                }
                                Text("Browse").tag(2)
                                Text("News").tag(3)
                                
                                
                            }).pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal,30)
                                .onAppear() {
                                    if clubcount == 0 {
                                        vmm.clubsortFavs()
                                        clubcount = 1
                                    }
                                }
                                .onChange(of: clubselected) { newValue in
                                    print("CHANGE THIS SHIT")
                                    if (clubselected == 1 && clubtempSelection == 2) {
                                        vmm.clubsortFavs()
                                        clubtempSelection = clubselected
                                    }
                                    else if (clubselected == 2 && clubtempSelection == 1) {
                                        vmm.clubsortFavs()
                                        clubtempSelection = clubselected
                                    }
                                }
                            
                            // TODO: Build clubs UI
                    
                            if clubselected == 1 || clubselected == 2 {
                                if clubsmanager.isLoading {
                                    List { // MARK: load sports
                                        ForEach(0..<8) { _ in
                                            HStack {
                                                Image(systemName: "questionmark.circle")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 50, height: 50)
                                                    .cornerRadius(1000)
                                                    .padding(.trailing, 10)
                                                    .redacted(reason: .placeholder)
                                                VStack (alignment: .center){
                                                    HStack {
                                                        Text("Chess Club")
                                                            .foregroundColor(.primary)
                                                            .lineLimit(2)
                                                            .minimumScaleFactor(0.9)
                                                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                                                            .redacted(reason: .placeholder)
                                                        Spacer()
                                                    }
                                                    HStack {
                                                        Text("304")
                                                            .foregroundColor(.secondary)
                                                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                                                            .redacted(reason: .placeholder)
                                                        Spacer()
                                                    }
                                                }
                                                Spacer()
                                            }
                                            .shimmering()
                                        }
                                    }
                                    .searchable(text: .constant(""))
                                    .navigationBarItems(trailing:
                                                            Group {
                                        if hasPermission.clubs {
                                            NavigationLink {
                                                ClubsAdminView(clubslist: clubsmanager.allclublist)
                                            } label: {
                                                Text("Edit")
                                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                            }
                                            .disabled(true)
                                        }
                                    }
                                    )
                                } else if (!hasFavorites && clubselected == 1) {
                                    VStack {
                                        Spacer()
                                        HStack{
                                            Spacer()
                                            Text("Save your favorite clubs by pressing the heart!")
                                                .multilineTextAlignment(.center)
                                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                            Spacer()
                                        }
                                        Button {
                                            clubselected = 2
                                        } label: {
                                            Text("Browse all Clubs")
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                                .padding(.all, 15.0)
                                                .background(.primary)
                                                .cornerRadius(15.0)
                                        }.searchable(text: $clubsearchText)
                                        Spacer()
                                        
                                    }.navigationBarItems(trailing:
                                                            Group {
                                        if hasPermission.clubs {
                                            NavigationLink {
                                                ClubsAdminView(clubslist: clubsmanager.allclublist)
                                            } label: {
                                                Text("Edit")
                                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                            }
                                        }
                                    }
                                    )
                                } else {
                                    VStack {
                                        // HERE WE GO
                                        if hasResults {
                                            List {// MARK: foreach 1 or 2
                                                ForEach(filteredList(fromList: clubsmanager.allclublist)) { item in
                                                    if clubsearchText.isEmpty || item.clubname.localizedStandardContains(clubsearchText) {
                                                        
                                                        if (item.favoritedusers.contains(userInfo.email) && clubselected == 1) || clubselected == 2 {
                                                            
                                                            NavigationLink {
                                                                ClubsMainView(selectedclub: item)
                                                                    .environmentObject(vmm)
                                                                    .environmentObject(clubfavoritesmanager)
                                                                    .environmentObject(clubsmanager)
                                                            } label: {
                                                                HStack {
                                                                    if item.imagedata != UIImage() {
                                                                        Image(uiImage: item.imagedata)
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fill)
                                                                            .frame(width: 50, height: 50)
                                                                            .cornerRadius(1000)
                                                                            .padding(.trailing, 10)
                                                                    } else {
                                                                        Image(systemName: "questionmark.circle")
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fill)
                                                                            .frame(width: 50, height: 50)
                                                                            .cornerRadius(1000)
                                                                            .padding(.trailing, 10)
                                                                    }
                                                                    VStack(alignment: .center) {
                                                                        HStack {
                                                                            Text(item.clubname)
                                                                                .foregroundColor(.primary)
                                                                                .lineLimit(1)
                                                                                .minimumScaleFactor(0.5)
                                                                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                                                            Spacer()
                                                                        }
                                                                        HStack {
                                                                            if item.clubmeetingroom != "" {
                                                                                Text("Room \(item.clubmeetingroom)")
                                                                                    .foregroundColor(.secondary)
                                                                                    .lineLimit(1)
                                                                                    .minimumScaleFactor(0.5)
                                                                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                                                            } else {
                                                                                Text("No meeting room")
                                                                                    .foregroundColor(.secondary)
                                                                                    .lineLimit(1)
                                                                                    .minimumScaleFactor(0.5)
                                                                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                                                            }
                                                                            Spacer()
                                                                        }
                                                                    }
                                                                    Spacer()
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            List {
                                                Text("No results.")
                                                    .lineLimit(1)
                                                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                                                    .padding(.leading, 5)
                                            }
                                        }
                                        
                                    }.searchable(text: $clubsearchText)
                                        .navigationBarItems(trailing:
                                                                Group {
                                            if hasPermission.clubs {
                                                NavigationLink {
                                                    ClubsAdminView(clubslist: clubsmanager.allclublist)
                                                } label: {
                                                    Text("Edit")
                                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                                                }
                                            }
                                        }
                                        )
                                }
                                
                            }
                            else if clubselected == 3 {
                                //mark
                                List {
                                    if hasResultsNews {
                                        ForEach(clubNewsManager.allclubsnewslist) { news in  // filteredClubNews
                                            if searchText.isEmpty || news.newstitle.localizedStandardContains(searchText){
                                                if news.isApproved {
                                                    NavigationLink {
                                                        ClubsNewsDetailView(currentclubnews: news)
                                                    } label: {
                                                        clubnewscell(feat: news)
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        Text("No results.")
                                            .lineLimit(1)
                                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                                            .padding(.leading, 5)
                                    }
                                    if !clubNewsManager.allclubsnewslist.map({ $0.documentID }).contains("NAN") && !clubNewsManager.allDocsLoaded {
                                        ProgressView()
                                            .onAppear {
                                                clubNewsManager.getMoreClubNews(getPending: false)
                                            }
                                    }
                                }
                                .searchable(text: $searchText)
                                .navigationBarItems(trailing:
                                                        Group {
                                    if hasPermission.clubs || hasPermission.articles || hasPermission.clubarticleadmin || hasPermission.clubarticlewriter {
                                        NavigationLink {
                                            ClubNewsAdminView()
                                        } label: {
                                            Text("Edit")
                                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                        }
                                    }
                                }
                                )
                            }
                            
                        }
                        
                        .onAppear { // MARK: on appear
                            
                            favoriteclublist = clubfavoritesmanager.favoriteClubs
                            
                            if !hasAppeared {
                                isLoading = false
                                hasAppeared = true
                                }
                            }
                        
                        }
                        
                        .navigationTitle("Clubs")
                        
                        if isLoading {
                            ZStack {
                                Color.white
                                    .edgesIgnoringSafeArea(.all)
                                
                                VStack {
                                    ProgressView("Loading...")
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                                }
                            }
                        }
                        
                    }
            }.onAppear {
                
                if userInfo.loginStatus != "Google" {
                    clubselected = 2
                }
                    
                }
            
        }
    }

struct clubnewscell: View{
    var feat: clubNews
    @State var imagedata: UIImage = UIImage()
    @StateObject var imagemanager = imageManager()
    @State var screen = ScreenSize()
    @State var hasAppeared = false
    
    var body:some View{
        VStack{
            Image(uiImage: imagedata)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .frame(maxWidth: screen.screenWidth - 60)
                .clipped()
                .cornerRadius(9)
            VStack(alignment: .leading, spacing:2){
                HStack {
                    Text(feat.newsdate)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .padding(.leading, 5)
                    Spacer()
                }
                Text(feat.newstitle)
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .padding(.leading, 5)
                Text(feat.newsdescription)
                    .foregroundColor(.secondary)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .padding(.leading, 5)
                    .lineLimit(1)
//                    Text("Click here to read more")
//                        .foregroundColor(.blue)
//                        .lineLimit(2)
//                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        .padding(.leading, 5)

            }
        }.onAppear {
            if !hasAppeared || feat.imagedata == [] || feat.imagedata.first == UIImage() || feat.imagedata.first == nil { //
                guard let image = feat.newsimage.first else { return }
                print("IMAGE FUNCTION RUN cv")
                 imagemanager.getImage(fileName: image) { uiimage in
                      if let uiimage = uiimage {
                          imagedata = uiimage
                      }
                 }
                 hasAppeared = true
            } else {
            }
            
       }
    }
}


struct ClubsHibabi_Previews: PreviewProvider {
    static var previews: some View {
        ClubsHibabi()
    }
}



class FavoriteClubsManager: ObservableObject {
    @Published var favoriteClubs: [club] = []

    func addFavorite(club: club) {
        favoriteClubs.append(club)
    }

    func removeFavorite(club: club) {
        if let index = favoriteClubs.firstIndex(where: { $0.id == club.id }) {
            favoriteClubs.remove(at: index)
        }
    }
}
