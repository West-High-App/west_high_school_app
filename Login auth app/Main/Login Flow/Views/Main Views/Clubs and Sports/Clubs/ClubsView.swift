//
//  ActivitiesView.swift
//  West App
//
//  Created by Aiden Lee on 5/19/23.
//

import SwiftUI

struct ClubsHibabi: View {
    
    var permissionsManager = permissionsDataManager()
    var userInfo = UserInfo()
    @State private var hasPermissionClubNews = false
    @State private var hasPermissionClubs = false
    
    @StateObject var clubfavoritesmanager = FavoriteClubsManager()

    
    var clubNewsManager = clubsNewslist()
    @ObservedObject var clubsmanager = clubManager()
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
    
    init() {
        clubNewsManager.getClubNews()
        newstitlearray = clubNewsManager.allclubsnewslist
        
        // getting club favorites
    }
    
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
    
        // MARK: view
    var body: some View {
        ZStack {
            NavigationView{
                ZStack {
                    VStack {
                        
                        Picker(selection: $clubselected, label: Text(""), content: { // picker at top
                            Text("My Clubs").tag(1)
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
                        
                        if clubselected == 1 || clubselected == 2 {
                            
                            if clubselected == 1 && favoriteclublist.count == 0 {
                                VStack {
                                    Spacer()
                                    Text("Add a club to get started!")
                                    Button {
                                        clubselected = 2
                                    } label: {
                                        Text("Browse Clubs")
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                            .padding(.all, 15.0)
                                            .background(.primary)
                                            .cornerRadius(15.0)
                                    }.searchable(text: $clubsearchText)
                                    Spacer()
                                    
                                }
                            }
                            else {
                                VStack {
                                    if isLoading {
                                        Text("Loading")
                                    }
                                    if clubselected == 1 {
                                        if userInfo.loginStatus != "google" {
                                            Text("Log in to save favorites!")
                                        }
                                        List {// MARK: foreach 1 or 2
                                            ForEach(clubfavoritesmanager.favoriteClubs) { item in
                                                if clubsearchText.isEmpty || item.clubname.localizedStandardContains(clubsearchText) {
                                                    NavigationLink {
                                                        ClubsMainView(selectedclub: item)
                                                            .environmentObject(vmm)
                                                            .environmentObject(clubfavoritesmanager)
                                                    } label: {
                                                        HStack {
                                                            Image(uiImage: item.imagedata)
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fill)
                                                                .frame(width: 50, height: 50)
                                                                .cornerRadius(1000)
                                                                .padding(.trailing, 10)
                                                            VStack(alignment: .center) {
                                                                HStack {
                                                                    Text(item.clubname)
                                                                        .foregroundColor(.primary)
                                                                        .lineLimit(2)
                                                                        .minimumScaleFactor(0.9)
                                                                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                                                                    Spacer()
                                                                }
                                                                HStack {
                                                                    Text(item.clubname)
                                                                        .foregroundColor(.secondary)
                                                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
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
                                    if clubselected == 2 {
                                        List {// MARK: foreach 1 or 2
                                            ForEach(filteredclubs) { item in
                                                if clubsearchText.isEmpty || item.clubname.localizedStandardContains(clubsearchText) {
                                                    NavigationLink {
                                                        ClubsMainView(selectedclub: item)
                                                            .environmentObject(vmm)
                                                            .environmentObject(clubfavoritesmanager)
                                                    } label: {
                                                        HStack {
                                                            Image(uiImage: item.imagedata)
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fill)
                                                                .frame(width: 50, height: 50)
                                                                .cornerRadius(1000)
                                                                .padding(.trailing, 10)
                                                            VStack(alignment: .center) {
                                                                HStack {
                                                                    Text(item.clubname)
                                                                        .foregroundColor(.primary)
                                                                        .lineLimit(2)
                                                                        .minimumScaleFactor(0.9)
                                                                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                                                                    Spacer()
                                                                }
                                                                HStack {
                                                                    Text(item.clubname)
                                                                        .foregroundColor(.secondary)
                                                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
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
                                    
                                }.searchable(text: $clubsearchText)
                                    .navigationBarItems(trailing:
                                        Group {
                                            if hasPermissionClubs {
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
                            List(filteredClubsNews, id: \.id) { news in
                                clubnewscell(feat: news)
                                    .background(NavigationLink("", destination: ClubsNewsDetailView(currentclubnews: news)).opacity(0))
                            }
                            .searchable(text: $searchText)
                            .navigationBarItems(trailing:
                                Group {
                                    if hasPermissionClubNews {
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
                            isLoading = true
                            print("LOADING...")

                            permissionsManager.checkPermissions(dataType: "ClubNews", user: userInfo.email) { result in
                                self.hasPermissionClubNews = result
                            }
                            permissionsManager.checkPermissions(dataType: "Clubs", user: userInfo.email) { result in
                                self.hasPermissionClubs = result
                            }
                            
                            let dispatchGroup = DispatchGroup()
                            
                            var tempylist2: [club] = []
                            for club in clubsmanager.favoriteslist {
                                dispatchGroup.enter()
                                
                                imagemanager.getImageFromStorage(fileName: club.clubimage) { image in
                                    var tempclub2 = club
                                    if let image = image {
                                        tempclub2.imagedata = image
                                    }
                                    
                                    tempylist2.append(tempclub2)
                                    dispatchGroup.leave()
                                    
                                }
                            }
                            
                            dispatchGroup.notify(queue: .main) { [self] in
                                self.clubsmanager.favoriteslist = tempylist2
                                self.favoriteclublist = tempylist2
                                self.clubfavoritesmanager.favoriteClubs = tempylist2
                            }
                            var tempylist: [club] = []
                            
                            for club in clubsmanager.allclublist {
                                dispatchGroup.enter()
                                
                                imagemanager.getImageFromStorage(fileName: club.clubimage) { image in
                                    
                                    var tempclub = club
                                    if let image = image {
                                        tempclub.imagedata = image
                                    }
                                    tempylist.append(tempclub) //
                                    dispatchGroup.leave()
                                }
                            }
                            
                            dispatchGroup.notify(queue: .main) { [self] in
                                self.clubsmanager.allclublist = tempylist
                            }
                            
                            
                            var templist: [clubNews] = []
                            for news in clubNewsManager.allclubsnewslist {
                                dispatchGroup.enter()
                                
                                imagesManager.getImageFromStorage(fileName: news.newsimage[0]) { uiimage in
                                    var tempnews = news
                                    if let uiimage = uiimage {
                                        
                                        tempnews.imagedata.removeAll()
                                        tempnews.imagedata.append(uiimage)
                                    }
                                    templist.append(tempnews)
                                    dispatchGroup.leave()
                                }
                            }
                            
                            dispatchGroup.notify(queue: .main) { [self] in
                                self.clubNewsManager.allclubsnewslist = templist
                                self.clubNewsManager.allclubsnewslist = self.clubNewsManager.allclubsnewslist.sorted { first, second in
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "MMM dd, yyyy"
                                    let firstDate = dateFormatter.date(from: first.newsdate) ?? Date()
                                    let secondDate = dateFormatter.date(from: second.newsdate) ?? Date()
                                    return firstDate < secondDate
                                }.reversed()
                                print("DONE LOADING")
                                isLoading = false
                            }
                            
                            
                            hasAppeared = true
                            
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
                
                print("VIEW APPEARED")
                
            }

            
        }

    }
}

struct clubnewscell: View{
    var feat: clubNews
    @State var screen = ScreenSize()
    
    var body:some View{
        VStack{
            if feat.imagedata.count > 0 {
                Image(uiImage: feat.imagedata[0])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .frame(maxWidth: screen.screenWidth - 60)
                    .clipped()
                    .cornerRadius(9)
            } else {
                Image(uiImage: UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .frame(maxWidth: screen.screenWidth - 60)
                    .clipped()
                    .cornerRadius(9)
            }
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
