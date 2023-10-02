//
//  CalendarView.swift
//  West App
//
//  Created by Aiden Lee on 5/19/23.
//


import SwiftUI

struct SportsHibabi: View {
    // MARK: initializers
    var permissionsManager = permissionsDataManager()
    @EnvironmentObject var userInfo: UserInfo
    @StateObject var sporteventmanager = sportEventManager.shared
    @StateObject var sporteventstorage = SportsEventStorage.shared
    @State private var hasPermissionSportsNews = false
    @State private var hasPermissionSports = false
    @ObservedObject var sportsNewsManager = sportsNewslist.shared
    @State var favorites: [sport] = []
    @ObservedObject var sportsmanager = sportsManager.shared // <---------
    @State var displaylist: [sport] = []
    @State var newstitlearray:[sportNews] = []
    @State var vm = ViewModel()
    @State var searchText = "" // text for search field
    @State var selected = 1 // which tab is selected
    @State var selectedGender = 1
    @State var selectedSeason = 1
    @State var tempSelection = 1
    @State var selectedTeam = 1
    
    @State var isFiltering = false
    @State var isLoading = false
    @State var isFilteringNews = false
    @State var showingAllNews = 1
    @State private var count = 0
    @State public var templist: [sport] = []
    @State private var hasAppeared = false
    @State var imagesManager = imageManager()

    init() {
        newstitlearray = sportsNewsManager.allsportsnewslist
    }
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
    private var filteredFavoriteSports: [sport] {
        return searchText == ""
            ? vm.filteredItems
            : vm.filteredItems.filter {
                $0.sportname.lowercased().contains(searchText.lowercased())
            }
    }
    private var filteredSports: [sport] {
        return searchText == ""
        ? sportsmanager.allsportlist
            : sportsmanager.allsportlist.filter {
                $0.sportname.lowercased().contains(searchText.lowercased())
            }
    }
    // sportsNewsManager.allsportsnewslist
    private var filteredSportsNews: [sportNews] {
        return searchText == ""
        ? sportsNewsManager.allsportsnewslist
            : sportsNewsManager.allsportsnewslist.filter {
                $0.newstitle.lowercased().contains(searchText.lowercased())
            }
    }
    
    private var allfavoriteslist: [sport] {
        var templist: [sport] = []
        for sport in sportsmanager.allsportlist {
            if sport.favoritedusers.contains(userInfo.email) {
                templist.append(sport)
            }
        }
        return templist
    }
    @State var refreshView = false
    
    // MARK: functions
        
    func filteredList(fromList list: [sport]) -> [sport] {
        let filteredlist = list.sorted { $0.sportname.lowercased() < $1.sportname.lowercased() }
        if selectedGender == 1 && selectedSeason == 1 && selectedTeam == 1 {
            // All filters are set to 1, return the original list
            return filteredlist
        } else {
            return filteredlist.filter { sport in
                let sportTags = sport.tags // Assuming tags is an array of ints [Int]
                
                // Check if the selected filters match the sport's tags
                let genderMatch = selectedGender == 1 || sportTags[0] == selectedGender
                let seasonMatch = selectedSeason == 1 || sportTags[1] == selectedSeason
                let teamMatch = selectedTeam == 1 || sportTags[2] == selectedTeam
                
                return genderMatch && seasonMatch && teamMatch
            }
        }
    }
    
    func countFilters() -> String{
        var filterz = 0
        if selectedTeam != 1 {
            filterz = 1
        }
        if selectedGender != 1 {
            filterz = filterz + 1
        }
        if selectedSeason != 1 {
            filterz = filterz + 1
        }
        if filterz == 0 {
            return ""
        }
        else {
            return "(\(filterz))"
        }
    }
    
    var body: some View {
        // MARK: body
        if userInfo.loginStatus == "google" {
            NavigationStack(path: $sportsmanager.sportsPath) {
                ZStack {
                    VStack {
                        
                        Picker(selection: $selected, label: Text(""), content: { // picker at top
                            Text("My Sports").tag(1)
                            Text("Browse").tag(2)
                            Text("News").tag(3)
                            
                        }).pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal,30)
                            .onAppear() {
                                if count == 0 {
                                    vm.sortFavs()
                                    count = 1
                                }
                                templist = filteredList(fromList: vm.filteredItems)
                                
                            }
                            .onChange(of: selected) { newValue in
                                if (selected == 1 && tempSelection == 2) {
                                    vm.sortFavs()
                                    tempSelection = selected
                                }
                                else if (selected == 2 && tempSelection == 1) {
                                    vm.sortFavs()
                                    tempSelection = selected
                                }
                                templist = filteredList(fromList: vm.filteredItems)
                            }
                        
                        // MARK: my sports
                        if selected == 1 || selected == 2{
                            if userInfo.loginStatus != "google" {
                                Text("Log in to save favorites!")
                            }
                            if selected == 1 && allfavoriteslist.count == 0 {
                                VStack {
                                    Spacer()
                                    Text("Add a sport to get started!")
                                    Button {
                                        selected = 2
                                    } label: {
                                        Text("Browse Sports")
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                            .padding(.all, 15.0)
                                            .background(.primary)
                                            .cornerRadius(15.0)
                                    }.searchable(text: $searchText)
                                    Spacer()
                                    
                                }
                            }
                            else {
                                Button {
                                    isFiltering = true
                                } label: {
                                    HStack {
                                        Label("Filter \(countFilters())", systemImage: "line.3.horizontal.decrease.circle")
                                            .padding(.horizontal)
                                            .padding(.top, 1)
                                            .foregroundColor(.blue)
                                        Spacer()
                                    }
                                }
                                List { // MARK: foreach my sports
                                    ForEach(filteredList(fromList: sportsmanager.allsportlist)) { item in
                                        if searchText.isEmpty || item.sportname.localizedStandardContains(searchText) {
                                            
                                            
                                            if (item.favoritedusers.contains(userInfo.email) && selected == 1) || selected == 2 {
                                                
//                                                NavigationLink(value: item) {
                                                NavigationLink {
                                                        SportsMainView(selectedsport: item)
                                                            .environmentObject(vm)
                                                            .environmentObject(sportsmanager)
                                                            .environmentObject(sporteventmanager)
                                                            .environmentObject(sporteventstorage)
                                                } label: {
                                                    HStack {
                                                        if item.imagedata != nil {
                                                            Image(uiImage: item.imagedata!)
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
                                                        VStack (alignment: .center){
                                                            HStack {
                                                                Text(item.sportname)
                                                                    .foregroundColor(.primary)
                                                                    .lineLimit(2)
                                                                    .minimumScaleFactor(0.9)
                                                                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                                                                Spacer()
                                                            }
                                                            HStack {
                                                                Text(item.sportsteam)
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
                                .searchable(text: $searchText)
                                .navigationDestination(for: sport.self) { item in
                                    if let index = filteredList(fromList: sportsmanager.allsportlist).firstIndex(where: { $0.documentID == item.documentID }) {
                                        SportsMainView(selectedsport: filteredList(fromList: sportsmanager.allsportlist)[index])
                                            .environmentObject(vm)
                                            .environmentObject(sportsmanager)
                                            .environmentObject(sporteventmanager)
                                            .environmentObject(sporteventstorage)
                                    }
                                }
                            }
                        }
                        
                        // MARK: sports news
                        else if selected == 3 {
                            
                            List(filteredSportsNews, id: \.id) { news in
                                
                                sportnewscell(feat: news)
                                    .background( NavigationLink("", destination: SportsNewsDetailView(currentnews: news)).opacity(0) )
                                
                            }.searchable(text: $searchText)
                        }
                    }
                    
                    .navigationBarItems(trailing:
                                            Group {
                        if selected == 3 {
                            if hasPermissionSportsNews {
                                NavigationLink {
                                    SportsNewsAdminView()
                                } label: {
                                    Text("Edit")
                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                                }
                            }
                        } else {
                            if hasPermissionSports {
                                NavigationLink {
                                    SportsAdminView()
                                } label: {
                                    Text("Edit")
                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                                }
                            }
                        }
                    }
                    )
                    
                    .navigationTitle("Sports")
                    
                    .onAppear { // MARK: onAppear
                        
                        // images
                        
                        if !hasAppeared {
//                            isLoading = true
                            
                            if userInfo.isAdmin {
                                self.hasPermissionSports = true
                                self.hasPermissionSportsNews = true
                            }
                            permissionsManager.checkPermissions(dataType: "SportsNews", user: userInfo.email) { result in
                                self.hasPermissionSportsNews = result
                            }
                            permissionsManager.checkPermissions(dataType: "Sports", user: userInfo.email) { result in
                                self.hasPermissionSports = result
                                if result {
                                    userInfo.isSportsAdmin = true
                                }
                            }
                            
//                            let dispatchGroup = DispatchGroup()
//                            
//                            var templist2: [sport] = []
//                            
//                            for sport in sportsmanager.favoriteslist {
//                                dispatchGroup.enter()
//                                
//                                imagesManager.getImage(fileName: sport.sportsimage) { image in
//                                    
//                                    var tempsport2 = sport
//                                    if let image = image {
//                                        tempsport2.imagedata = image
//                                    }
//                                    
//                                    templist2.append(tempsport2)
//                                    dispatchGroup.leave()
//                                    
//                                }
//                            }
//                            
//                            dispatchGroup.notify(queue: .main) { [self] in
//                                self.sportsmanager.favoriteslist = templist2
//                            }
//                            
//                            var templist: [sport] = []
//                            
//                            for sport in sportsmanager.allsportlist {
//                                dispatchGroup.enter()
//                                
//                                imagesManager.getImage(fileName: sport.sportsimage) { image in
//                                    
//                                    var tempsport = sport
//                                    if let image = image {
//                                        tempsport.imagedata = image
//                                    }
//                                    
//                                    templist.append(tempsport)
//                                    dispatchGroup.leave()
//                                }
//                            }
//                            
//                            dispatchGroup.notify(queue: .main) { [self] in
//                                self.sportsmanager.allsportlist = templist
//                            }
//                            
//                            var templist3: [sportNews] = []
//                            
//                            for news in sportsNewsManager.allsportsnewslist {
//                                dispatchGroup.enter()
//                                
//                                imagesManager.getImage(fileName: news.newsimage[0]) { uiimage in
//                                    
//                                    var tempnews = news
//                                    if let uiimage = uiimage {
//                                        tempnews.imagedata.removeAll()
//                                        tempnews.imagedata.append(uiimage)
//                                    }
//                                    
//                                    templist3.append(tempnews)
//                                    dispatchGroup.leave()
//                                }
//                            }
//                            
//                            dispatchGroup.notify(queue: .main) { [self] in
//                                self.sportsNewsManager.allsportsnewslist = templist3
                                isLoading = false
//                            }
                            hasAppeared = true
                        }
                    }
                    
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
                    
                    
                    // MARK: sheets and stuff
                }.sheet(isPresented: $isFiltering, content: {
                    HStack {
                        Button {
                            isFiltering = false
                            selectedTeam = 1
                            selectedGender = 1
                            selectedSeason = 1
                            templist = vm.filteredItems
                        } label: {
                            Text("Reset")
                                .padding(.top)
                                .padding(.bottom, 5)
                        }
                        Spacer()
                        Text("Filter Results")
                            .font(.title3)
                            .padding(.top)
                            .padding(.bottom, 5)
                        Spacer()
                        Button {
                            isFiltering = false
                            templist = filteredList(fromList: vm.filteredItems)
                        } label: {
                            Text("Done")
                                .padding(.top)
                                .padding(.bottom, 5)
                        }
                    }.padding(.horizontal)
                    
                    List {
                        HStack {
                            Picker(selection: $selectedGender) {
                                Text("All")
                                    .tag(1)
                                Text("Boys")
                                    .tag(2)
                                Text("Girls")
                                    .tag(3)
                                Text("Mixed")
                                    .tag(4)
                            } label: {
                                Text("Gender")
                            }
                            
                        }
                        HStack {
                            Picker(selection: $selectedSeason) {
                                Text("All")
                                    .tag(1)
                                Text("Fall")
                                    .tag(2)
                                Text("Winter")
                                    .tag(3)
                                Text("Spring")
                                    .tag(4)
                            } label: {
                                Text("Season")
                            }
                        }
                        
                        HStack {
                            Picker(selection: $selectedTeam) {
                                Text("All")
                                    .tag(1)
                                Text("Varsity")
                                    .tag(2)
                                Text("JV1")
                                    .tag(3)
                                Text("JV2")
                                    .tag(4)
                                Text("Freshman")
                                    .tag(5)
                            } label: {
                                Text("Team")
                            }
                            
                        }
                    }
                })
                .sheet(isPresented: $isFilteringNews, content: {
                    HStack {
                        Button {
                            isFilteringNews = false
                            showingAllNews = 1
                        } label: {
                            Text("Reset")
                                .padding(.top)
                                .padding(.bottom, 5)
                        }
                        Spacer()
                        Text("Filter Results")
                            .font(.title3)
                            .padding(.top)
                            .padding(.bottom, 5)
                        Spacer()
                        Button {
                            isFilteringNews = false
                        } label: {
                            Text("Done")
                                .padding(.top)
                                .padding(.bottom, 5)
                        }
                    }.padding(.horizontal)
                    
                    List {
                        HStack {
                            Picker(selection: $showingAllNews) {
                                Text("All sports")
                                    .tag(1)
                                Text("My sports only")
                                    .tag(2)
                            } label: {
                                Text("Showing")
                            }
                            
                        }
                    }
                })
                
            }
        }
        else {
            Text("Log in to view sports!")
                .lineLimit(2)
                .font(.system(size: 32, weight: .semibold, design: .rounded))
                .padding(.leading, 5)
        }

        }
    }

// MARK: sportnewscell
struct sportnewscell: View{
    var feat: sportNews
    
    var body:some View{
        VStack{
            if feat.imagedata.count > 0 {
                Image(uiImage: feat.imagedata[0])
                    .resizable()
                    .cornerRadius(10)
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical, 2)
            } else {
                Image(uiImage: UIImage())
                    .resizable()
                    .cornerRadius(10)
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical, 2)
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


struct SportsHibabi_Previews: PreviewProvider {
    static var previews: some View {
        SportsHibabi()
    }
}


class FavoriteSportsManager: ObservableObject {
    @Published var favoriteSports: [sport] = []

    func addFavorite(sport: sport) {
        favoriteSports.append(sport)
    }

    func removeFavorite(sport: sport) {
        if let index = favoriteSports.firstIndex(where: { $0.id == sport.id }) {
            favoriteSports.remove(at: index)
        }
    }
}
