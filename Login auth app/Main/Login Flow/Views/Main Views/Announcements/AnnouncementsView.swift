//
//  AnnouncementsView.swift
//  West App
//
//  Created by Aiden Lee on 5/19/23.
//

import SwiftUI

struct AnnouncementsView: View {
    var newstitlearray:[Newstab] = Newslist.topfive
    
    // delete init under if being stupid
    init() {
        newstitlearray = newstitlearray.sorted { first, second in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM, d yyyy"
            let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
            let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
            return firstDate < secondDate
        }.reversed()
    }
    
    var body: some View {
            NavigationView{
                List(newstitlearray, id: \.id){news in
                    NavigationLink {
                        AnnouncementsDetailView(currentnews: news)
                    } label: {
                        NewsCell(news: news)
                    }
                    .listRowBackground(
                        Rectangle()
                            .cornerRadius(25)
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
