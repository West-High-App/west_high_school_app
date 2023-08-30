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
    
    var clubNewsManager = clubsNewslist()
    init() {
        clubNewsManager.getClubNews()
        newstitlearray = clubNewsManager.allclubsnewslist
    }
    @State var newstitlearray:[clubNews] = []
    @StateObject var vmm = ClubViewModel()
    @State var clubsearchText = "" // text for search field
    @State var clubselected = 1 // which tab is selected
    @State var clubisFiltering = false
    @State var clubisFilteringNews = false
    @State var clubtempSelection = 1
    @State var clubshowingAllNews = 1
    @State private var clubcount = 0
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
            ? vmm.clubfilteredItems
            : vmm.clubfilteredItems.filter {
                $0.clubname.lowercased().contains(clubsearchText.lowercased())
            }
    }
    
    
    var body: some View {
        NavigationView{
            VStack {
                Picker(selection: $clubselected, label: Text(""), content: { // picker at top
                    Text("My Clubs").tag(1)
                    Text("Browse").tag(2)
                    Text("Clubs News").tag(3)
                    
                }).pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal,30)
                    .onAppear() {
                        if clubcount == 0 {
                            vmm.clubsortFavs()
                            clubcount = 1
                        }
                    }
                    .onChange(of: clubselected) { newValue in
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
                    if clubselected == 1 && vmm.clubsavedItems.count == 0 {
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
                            List {
                                ForEach(filteredclubs) { item in
                                    if clubsearchText.isEmpty || item.clubname.localizedStandardContains(clubsearchText) {
                                        NavigationLink {
                                            ClubsMainView(selectedclub: item)
                                                .environmentObject(vmm)
                                        } label: {
                                            HStack {
                                                Image(item.clubimage)
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
                            .searchable(text: $clubsearchText)
                        }
                    }

                }
                //you thought i was feeling you???
                else if clubselected == 3 { // penis
                    if hasPermissionClubNews {
                        NavigationLink {
                            ClubNewsAdminView()
                        } label: {
                            Text("edit club news")
                        }

                    }
                    List(clubNewsManager.allclubsnewslist, id: \.id) { news in
                        
                        clubnewscell(feat: news)
                            .background( NavigationLink("", destination: ClubsNewsDetailView(currentclubnews: news)).opacity(0) )
                        
                        
                        
                    }
                    .searchable(text: $clubsearchText)
                }
                
                    }
            
            .onAppear {
                permissionsManager.checkPermissions(dataType: "ClubNews", user: userInfo.email) { result in
                    self.hasPermissionClubNews = result
                }
            }
            
            .navigationTitle("Clubs")
            }

    }
}


struct clubnewscell: View{
    var feat: clubNews
    
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


struct ClubsHibabi_Previews: PreviewProvider {
    static var previews: some View {
        ClubsHibabi()
    }
}

