//
//  AnnouncementsView.swift
//  West App
//
//  Created by Aiden Lee on 5/19/23.
//

import SwiftUI

struct AnnouncementsView: View {
    @StateObject var newsDataManager = Newslist()
    var permissionsManager = permissionsDataManager()
    @StateObject var userInfo = UserInfo()
    
    @State private var hasPermission = false
    @State var hasAppeared = false
    
    init() {
        newsDataManager.getAnnouncements()    }
    
    
    var body: some View {
            NavigationView{
                VStack {
                    if hasPermission {
                        NavigationLink {
                            AnnouncementsAdminView()
                        } label: {
                            Text("Edit Announcements")
                                .foregroundColor(.blue)
                                .padding(10)
                                .background(Rectangle()
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 2, x: 1, y: 1))
                        }
                    }

                    List(newsDataManager.topfive, id: \.id){news in
                        NavigationLink {
                            AnnouncementsDetailView(currentnews: news)
                        } label: {
                            NewsCell(news: news)
                        }
                        .listRowBackground(
                            Rectangle()
                                .cornerRadius(15)
                                .foregroundColor(Color(red: 225/255, green: 225/255, blue: 225/255))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 7)
                                .shadow(radius: 2, x: 1, y: 1)

                        )
                        .listRowSeparator(.hidden)
                        
                        
                    }
                    .navigationBarTitle(
                        Text("Announcements"))
                }
            }.onAppear {
                if !hasAppeared {
                    permissionsManager.checkPermissions(dataType: "Announcements", user: userInfo.email) { result in
                        self.hasPermission = result
                    }
                    hasAppeared = true
                }
            }
    }
    
    struct NewsCell: View{
        var news: Newstab
        
        var body:some View{
            ZStack{
                HStack{
                    VStack(alignment: .leading, spacing:2){
                        Text(news.title)
                            .foregroundColor(.black)
                            .lineLimit(2)
                            .minimumScaleFactor(0.9)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .padding(.leading, 5)
                        Text(news.publisheddate)
                            .foregroundColor(.secondary)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .padding(.leading, 5)
                        Text(news.description)
                            .foregroundColor(.secondary)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .padding(.leading, 5)
                            .lineLimit(2)
                    }
                }
            }
            .padding(.vertical, 7)
            .padding(.horizontal, -5)

        }
    }
}

struct AnnouncementsView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementsView()

    }
}
