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
        
    init() {
        newsDataManager.getAnnouncements()    }
    
    
    var body: some View {
            NavigationView{
                VStack {
                    if hasPermission {
                        Text("has permission")
                    }
                    if hasPermission {
                        NavigationLink {
                            AnnouncementsAdminView()
                        } label: {
                            Text("edit announcements")
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
                                .foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 7)
                                .shadow(radius: 5)

                        )
                        .listRowSeparator(.hidden)
                        
                        
                    }
                    .navigationBarTitle(
                        Text("Announcements"))
                }
            }.onAppear {
                permissionsManager.checkPermissions(dataType: "Announcements", user: userInfo.email) { result in
                    self.hasPermission = result
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
