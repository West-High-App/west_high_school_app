//
//  StudentSpotLight.swift
//  West App
//
//  Created by August Andersen on 5/28/23.
//

import SwiftUI

struct StudentSpotlight: View {
    @State private var hasPermissionSpotlight = false
    var permissionsManager = permissionsDataManager()
    var userInfo = UserInfo()
    var spotlightManager = studentachievementlist()
    @State var newstitlearray: [studentachievement] = []
    // delete init under if being stupid
    init() {
        spotlightManager.getAchievements()
        newstitlearray = newstitlearray.sorted { first, second in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
            let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
            return firstDate < secondDate
        }.reversed()
    }

    
    var body: some View {

        //NavigationView{
        VStack {

            List(spotlightManager.allstudentachievementlist, id: \.id)
            {news in
                achievementcell(feat: news)
                    .background( NavigationLink("", destination: SpotlightArticles(currentstudentdub: news)).opacity(0) )
                    .listRowSeparator(.hidden)
                
            }
        }
        .onAppear {
            permissionsManager.checkPermissions(dataType: "StudentAchievements", user: userInfo.email) { result in
                self.hasPermissionSpotlight = result
            }
        }            .navigationBarTitle(Text("Student Spotlight"))


        }
    }
    
    
    struct achievementcell: View{
        var feat: studentachievement
        
        var body:some View{
            VStack{
                Image(feat.images.first!)
                    .resizable()
                    .cornerRadius(10)
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical, 2)
                VStack(alignment: .leading, spacing:2){
                    HStack{
                        Text("By " + feat.articleauthor)
                            .foregroundColor(.secondary)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                        Spacer()
                        Text(feat.publisheddate)
                            .foregroundColor(.secondary)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                    Text(feat.achievementtitle)
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    Text(feat.achievementdescription)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                    Text("Click here to read more")
//                        .foregroundColor(.blue)
//                        .lineLimit(2)
//                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        .padding(.leading, 5)

                }
            }
                .padding(.vertical, 5)
                .listRowBackground(
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 7)
                        .shadow(radius: 5)
                )
        }
    }
//}

struct StudentSpotlight_Previews: PreviewProvider {
    static var previews: some View {
        StudentSpotlight()
    }
}
