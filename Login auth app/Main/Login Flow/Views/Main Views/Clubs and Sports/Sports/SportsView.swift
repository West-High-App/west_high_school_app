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
    var userInfo = UserInfo()
    @State private var hasPermissionSportsNews = false
    @State private var hasPermissionSports = false
    @State var sportsNewsManager = sportsNewslist()
    @State var favoritesManager = FavoriteSports()
    @State var favorites: [sport] = []
    @ObservedObject var sportsmanager = sportsManager()
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
    @State var isFilteringNews = false
    @State var showingAllNews = 1
    @State private var count = 0
    @State public var templist: [sport] = []

    init() {
        sportsNewsManager.getSportsNews()
        newstitlearray = sportsNewsManager.allsportsnewslist
        print("WE WERE HERE")
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
    // MARK: functions
        
    func filteredList(fromList: [sport]) -> [sport] {
        templist = []
        for item in vm.filteredItems {
            var shouldAdd = true
            if selectedGender != 1 {
                if item.tags[0] != selectedGender {
                    shouldAdd = false
                }
            }
            if selectedSeason != 1 {
                if item.tags[1] != selectedSeason {
                    shouldAdd = false
                }
            }
            if selectedTeam != 1 {
                if item.tags[2] != selectedSeason {
                    shouldAdd = false
                }
            }
            if shouldAdd {
                templist.append(item)
            }
        }
        return templist
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
        NavigationView{
            VStack {

                Picker(selection: $selected, label: Text(""), content: { // picker at top
                    Text("My Sports").tag(1)
                    Text("Browse").tag(2)
                    Text("Sports News").tag(3)
                    
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
                if selected == 1 {
                    if hasPermissionSports {
                        NavigationLink {
                            SportsAdminView()
                        } label: {
                            Text("EDIT SPORTS")
                        }
                    }
                    if userInfo.loginStatus != "google" {
                        Text("Log in to save favorites!")
                    }
                    if selected == 1 && vm.savedItems.count == 0 {
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
                            ForEach(sportsmanager.favoriteslist) { item in
                                if searchText.isEmpty || item.sportname.localizedStandardContains(searchText) {
                                    NavigationLink {
                                        SportsMainView(selectedsport: item)
                                            .environmentObject(vm)
                                    }label: {
                                        HStack {
                                            Image(item.sportsimage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(1000)
                                                .padding(.trailing, 10)
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
                        .searchable(text: $searchText)
                    }
                }
                
                // MARK: browse
                else if selected == 2 {
                    
                    if hasPermissionSports {
                        NavigationLink {
                            SportsAdminView()
                        } label: {
                            Text("EDIT SPORTS")
                        }
                    }

                    if selected == 1 && vm.savedItems.count == 0 {
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
                        List { // MARK: foreach browse
                            ForEach(filteredSports) { item in
                                if searchText.isEmpty || item.sportname.localizedStandardContains(searchText) {
                                    NavigationLink {
                                        SportsMainView(selectedsport: item)
                                            .environmentObject(vm)
                                    }label: {
                                        HStack {
                                            Image(item.sportsimage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(1000)
                                                .padding(.trailing, 10)
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
                        .searchable(text: $searchText)
                    }
                }
                
                // MARK: sports news
                else if selected == 3 {
                    Button {
                        isFilteringNews = true
                    } label: {
                        HStack {
                            Label("Filter \(countFilters())", systemImage: "line.3.horizontal.decrease.circle")
                                .padding(.horizontal)
                                .padding(.top, 1)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    }
                    
                    if hasPermissionSportsNews {
                        NavigationLink {
                            SportsNewsAdminView()
                        } label: {
                            Text("edit sports news")
                        }
                    }

                    
                    List(sportsNewsManager.allsportsnewslist, id: \.id) { news in
                        
                        sportnewscell(feat: news)
                            .background( NavigationLink("", destination: SportsNewsDetailView(currentnews: news)).opacity(0) )
                        
                    }.searchable(text: $searchText)
                }
                    }
            .navigationTitle("Sports")
            
            .onAppear {
                permissionsManager.checkPermissions(dataType: "SportsNews", user: userInfo.email) { result in
                    self.hasPermissionSportsNews = result
                }
                permissionsManager.checkPermissions(dataType: "Sports", user: userInfo.email) { result in
                    self.hasPermissionSports = result
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
                            Text("Year-round")
                                .tag(5)
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
                            Text("JV")
                                .tag(3)
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

// MARK: sportnewscell
struct sportnewscell: View{
    var feat: sportNews
    
    var body:some View{
        VStack{
            Image(feat.newsimage.first!)
                .resizable()
                .cornerRadius(10)
                .aspectRatio(contentMode: .fit)
                .padding(.vertical, 2)
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
