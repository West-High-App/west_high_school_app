//
//  HomeView.swift
//  West Ap
//
//  Created by August Andersen on 5/19/23.
// testing push from west_high_app_2 (i think)

import SwiftUI
import UserNotifications



struct HomeView: View {
//    func scrollToTop() {
//        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
//        setContentOffset(desiredOffset, animated: true)
//    }
    @State var clubmanager = clubManager()
    @ObservedObject var newsDataManager = Newslist()
    @ObservedObject var dataManager = upcomingEventsDataManager()

    // permissions
    @ObservedObject var sportsnewsmanager = sportsNewslist()
    var permissionsManager = permissionsDataManager()
    @State private var hasPermissionUpcomingEvents = false
    @State private var hasPermissionSpotlight = false
    @State private var hasAdmin = false

    @ObservedObject var spotlightManager = studentachievementlist()
    @State var newstitlearray: [studentachievement] = []
    //var notiManager = NotificationsManager()
    //var safeArea: EdgeInsets
    //var size: CGSize
    // delete init under if being stupid

    init(safeArea: EdgeInsets, size: CGSize) {
        self.safeArea = safeArea
        self.size = size
        newsDataManager.getAnnouncements()
        spotlightManager.getAchievements()
        dataManager.getUpcomingEvents()
        newstitlearray = newstitlearray.sorted { first, second in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
            let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
            return firstDate < secondDate
        }.reversed()
        }
    
    @State var hasAppeared = false
    
    @StateObject var imagemanager = imageManager()
    @State var spotlightarticles: [studentachievement] = []
    
    @EnvironmentObject var userInfo: UserInfo
    @State var date = Date()
    let yellow = Color(red: 0.976, green: 0.87, blue: 0.01)
    let blue = Color(red: 0.159, green: 0.207, blue: 0.525)
    
    func getTime() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12 : return "morning"
        case 12..<17 : return "afternoon"
        default: return "evening"
        }
    }
    

    // MARK: VIEW
    var safeArea: EdgeInsets
    var size: CGSize
    let westyellow = Color(red:248/255, green:222/255, blue:8/255)
    let westblue = Color(red: 41/255, green: 52/255, blue: 134/255)
    

    var body: some View {
        ZStack {
            ClubsHibabi()
            SportsHibabi()
            StaffView()
            LunchMenuView()
            ClassesView()
            SchoolPolicyGuideView()
            MentalHealthView()
            //MARK: HOME
            NavigationView{
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        // artwork
                        Artwork()
                        // Since We ignored Top Edge
                        GeometryReader{ proxy in
                            
                        }
                        .zIndex(1)
                        VStack{
                            VStack{
                                //temp
                                
                                NavigationLink {
                                    HomeAnnouncementsDetailView(currentnews: newsDataManager.topfive[0])
                                } label: {
                                    MostRecentAnnouncementCell(news: newsDataManager.topfive[0])
                                }
                            }
                            .padding(.bottom, 10)
                            
                            //SNACK SPLICE BOISSSSSS
                            
                            //MARK: upcoming events
                            VStack{
                                HStack {
                                    Text("Upcoming Events")
                                        .lineLimit(1)
                                        .padding(.leading, 15)
                                        .foregroundColor(westblue)
                                        .bold()
                                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    //.padding(.horizontal)
                                    //.padding(.vertical, -5)
                                    
                                    Spacer()
                                    NavigationLink {
                                        UpcomingEventsView()
                                    } label: {
                                        HStack{
                                            Text("See more")
                                                .padding(.trailing,-15)
                                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                        }
                                        .padding(.horizontal,34)
                                    }.foregroundStyle(.blue)
                                    
                                    //Button {
                                    //    AnnouncementsView()
                                    //} label: {
                                    //    Label("See more", systemImage: "greaterthan")
                                    //        .padding(.horizontal)
                                    //        .padding(.vertical, -5)
                                    //}
                                    
                                }
                                .foregroundStyle(.black)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Rectangle()
                                    .cornerRadius(9.0)
                                    .padding(.horizontal)
                                    .shadow(radius: 5, x: 3, y: 3)
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                                // edit button
                                
                                if hasPermissionUpcomingEvents {
                                    NavigationLink {
                                        UpcomingEventsAdminView()
                                    } label: {
                                        Text("Edit Upcoming Events")
                                            .foregroundColor(.blue)
                                            .padding(10)
                                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                                            .background(Rectangle()
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                                .shadow(radius: 2, x: 1, y: 1))                        }
                                }
                                
                                VStack {
                                    UpcomingEventCell(event: dataManager.firstcurrentevent)
                                    Divider()
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                    UpcomingEventCell(event: dataManager.secondcurrentEvent)
                                    Divider()
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                    UpcomingEventCell(event: dataManager.thirdcurrentEvent)
                                }
                                .foregroundStyle(.black)
                                .padding(.all) //EDIT
                                .background(Rectangle()
                                    .cornerRadius(9.0)
                                    .padding(.horizontal)
                                    .shadow(radius: 5, x: 2, y: 2)
                                            
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                            }
                            
                            //MARK: student spotlight
                            
                            VStack{
                                HStack {
                                    Text("Student Spotlight")
                                        .foregroundColor(westblue)
                                        .bold()
                                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                                        .padding(.horizontal)
                                    
                                    Spacer()
                                    
                                    NavigationLink {
                                        StudentSpotlight(spotlightarticles: spotlightarticles)
                                    } label: {
                                        HStack{
                                            Text("See more")
                                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                                .padding(.trailing,-15)
                                        }
                                        .padding(.horizontal,34)
                                    }.foregroundStyle(.blue)
                                    
                                    //Button {
                                    //    AnnouncementsView()
                                    //} label: {
                                    //    Label("See more", systemImage: "greaterthan")
                                    //        .padding(.horizontal)
                                    //        .padding(.vertical, -5)
                                    //}
                                    
                                }
                                .foregroundStyle(.black)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Rectangle()
                                    .cornerRadius(9.0)
                                    .padding(.horizontal)
                                    .shadow(radius: 5, x: 3, y: 3)
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                                
                                if hasPermissionSpotlight {
                                    NavigationLink {
                                        SpotlightAdminView()
                                    } label: {
                                        Text("Edit Spotlight Articles")
                                            .foregroundColor(.blue)
                                            .padding(10)
                                            .background(Rectangle()
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                                .shadow(radius: 2, x: 1, y: 1))
                                        
                                    }
                                    
                                }
                                
                                VStack { // MARK: student spotlight
                                    if spotlightarticles.count > 0 {
                                        NavigationLink {
                                            SpotlightArticles(currentstudentdub: spotlightarticles[0])
                                        } label: {
                                            MostRecentAchievementCell(feat: spotlightarticles[0])
                                        }
                                    }
                                    if spotlightarticles.count > 1 {
                                        NavigationLink {
                                            SpotlightArticles(currentstudentdub: spotlightarticles[1])
                                        } label: {
                                            MostRecentAchievementCell(feat: spotlightarticles[1])
                                        }
                                    }
                                    if spotlightarticles.count > 2 {
                                        NavigationLink {
                                            SpotlightArticles(currentstudentdub: spotlightarticles[2])
                                        } label: {
                                            MostRecentAchievementCell(feat: spotlightarticles[2])
                                        }
                                    }
                                    
                                    
                                    
                                }
                                .padding(.horizontal)
                            }
                            .padding(.top,10)
                            
                            
                            
                        }
                        .zIndex(0)
                        
                        if false {
                            Button {
                                let center = UNUserNotificationCenter.current()
                                
                                let content = UNMutableNotificationContent()
                                content.title = "Emergency Announcment"
                                content.body = "skool is getting shot up guys run"
                                
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                                
                                //creating request
                                let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
                                
                                center.add(request){error in
                                    if let error = error {
                                        print(error)
                                    }
                                }
                            } label: {
                                
                                HStack{
                                    Spacer()
                                    Image(systemName: "bell.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:20)
                                    Text("Send Notification")
                                        .fontWeight(.semibold)
                                        .font(                                        .custom("Apple SD Gothic Neo", fixedSize: 24))
                                    Image(systemName: "bell.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:20)
                                    Spacer()
                                    
                                }
                                .padding(.vertical, 8)
                                .background(Rectangle()
                                    .cornerRadius(9.0)
                                    .padding(.horizontal)
                                    .shadow(radius: 5, x: 3, y: 3)
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                            }
                        }
                        
                    }
                    .padding(.bottom, 10)
                    .overlay(alignment: .top) {
                        HeaderView()
                    }
                    
                    // checking for permissions on appear
                    .onAppear {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            // THIS IS SUPER SKETCHY PROB SHOULDN"T DO IT BUT FUCK IT NO NONONONON IF THERES AN ERROR THIS IS WHERE IT IS
                            // MARK: this is stupid but fuck it ERROR come from here
                            if !hasAppeared {
                                
                                permissionsManager.checkPermissions(dataType: "StudentAchievements", user: userInfo.email) { result in
                                    self.hasPermissionSpotlight = result
                                }
                                permissionsManager.checkPermissions(dataType: "UpcomingEvents", user: userInfo.email) { result in
                                    self.hasPermissionUpcomingEvents = result
                                }
                                permissionsManager.checkPermissions(dataType: "Admin", user: userInfo.email) { result in
                                    self.hasAdmin = result
                                }
                                
                                spotlightarticles = spotlightManager.allstudentachievementlist
                                var returnlist: [studentachievement] = []
                                
                                let dispatchGroup = DispatchGroup()
                                
                                for article in spotlightarticles {
                                    var tempimages: [UIImage] = []
                                    
                                    for imagepath in article.images {
                                        dispatchGroup.enter()
                                        imagemanager.getImageFromStorage(fileName: imagepath) { uiimage in
                                            if let uiimage = uiimage {
                                                tempimages.append(uiimage)
                                            }
                                            dispatchGroup.leave()
                                        }
                                    }
                                    
                                    dispatchGroup.notify(queue: .main) {
                                        returnlist.append(studentachievement(documentID: article.documentID, achievementtitle: article.achievementtitle, achievementdescription: article.achievementdescription, articleauthor: article.articleauthor, publisheddate: article.publisheddate, images: article.images, imagedata: tempimages))
                                        
                                        spotlightarticles = returnlist
                                    }
                                }
                                
                                hasAppeared = true
                            }
                        }
                        
                        
                    }
                    
                }
                .background(westblue)
                .coordinateSpace(name: "SCROLL")
                .padding(.top, -60)
            }
        }


    }

    
    @ViewBuilder
    func Artwork() -> some View {
        let height = size.height * 0.65
        GeometryReader{ proxy in
            
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            
            Image("west")
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
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
                            Text(date, style: .date)
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                                .font(.system(size: 50, weight: .semibold, design: .rounded))
                                .foregroundColor(yellow)
                                .padding(.horizontal)
                                .fontWeight(.semibold)
                                .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                            
                            //.font(.system(size: 45))
                            //.fontWeight(.bold)
                            //.multilineTextAlignment(.center)
                            if userInfo.loginStatus == "google"{
                                Text("Good \(getTime()), \(userInfo.firstName())!")
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.2)
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                                    .fontWeight(.medium)
                                    .padding(.horizontal)
                                    .foregroundColor(westyellow)
                                    .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                            }
                            else{
                                Text("Good \(getTime())!")
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.2)
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                                    .fontWeight(.medium)
                                    .fontWeight(.medium)
                                    .padding(.horizontal)
                                    .foregroundColor(westyellow)
                                    .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                            }
                        }
                        .opacity(1 + (progress > 0 ? -progress : progress))
                        .padding(.bottom, 25)
                        
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
                
                ZStack{
                    Image("Regents Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height:100)
                        .offset(y: -titleProgress < 0.75 ? 0 : 50)
                        .animation(.easeOut(duration: 0.35), value: -titleProgress > 0.75)
                        .opacity(1 + (progress > 0 ? -progress : progress))
                    VStack{
                        Spacer()
                        Text("REGENTS")
                            .offset(y:15)
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                            .foregroundStyle(westyellow)
                            .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                            .offset(y: -titleProgress < 0.75 ? 0 : 100)
                            .animation(.easeOut(duration: 0.55), value: -titleProgress > 0.75)
                            .opacity(1 + (progress > 0 ? -progress : progress))
                    }

                }
                

//                    Text("FOLLOWING")
//                        .font(.caption)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 6)
//                        .border(.white, width: 1.5)
                Spacer(minLength: 0)
                
            }
            .padding(.top,70)
            .overlay(content: {
//                Button {
////                    HomeView.scrollToTop()
//                } label: {
//                    Image("Regents Logo")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 70, height:70)
//                        .offset(y: -titleProgress > 0.75 ? 0 : 80)
//                        .clipped()
//                        .animation(.easeOut(duration: 0.25), value: -titleProgress > 0.75)
//                }
                Rectangle()
                    .fill(
                        .linearGradient(colors: [
                            westblue.opacity(0.5 - titleProgress),
                            westblue.opacity(0.4 - titleProgress),
                            westblue.opacity(0.3 - titleProgress),
                            westblue.opacity(0.2 - titleProgress),
                            westblue.opacity(0.1 - titleProgress),
                            westblue.opacity(0 - titleProgress),
                            westblue.opacity(0 - titleProgress),
                            westblue.opacity(0 - titleProgress),


                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(height:70)
                    .padding(.bottom,100)
                

            })
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

//LAINAH BRAUN
struct MostRecentAnnouncementCell: View{
    var news: Newstab
    
    var body:some View{
        VStack(alignment: .leading) {
            HStack {
                Text(news.title)
                    .foregroundColor(.black)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .fontWeight(.medium)
                    .padding(.horizontal)
                    .padding(.vertical, -5)
                Spacer()
                Text(news.publisheddate)
                    .foregroundColor(.gray)
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .padding(.horizontal)
                    .padding(.vertical, -5)
            }
            Divider()
                .padding(.horizontal)
                .padding(.vertical, 5)
            
            Text(news.description)
                .lineLimit(3)
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
                .padding(.horizontal)
            
            HStack {
                Spacer()
                Text("Read more...")
                    .padding(.horizontal)
                    .font(.system(size: 17, weight: .regular, design: .rounded))

                    .padding(.top, 1)
                    .foregroundColor(.gray)
                Spacer()
            }
        }.padding(.all) //EDIT
            .background(Rectangle()
                .cornerRadius(9.0)
                .padding(.horizontal)
                .shadow(radius: 5, x: 3, y: 3)
                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
    }
}



struct UpcomingEventCell: View{
    var event: event
    @State var hasAppeared = false
    var body:some View{
        HStack {
            VStack {
                Text(event.month)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.red)
                Text(event.day)
                    .font(.system(size: 24, weight: .regular, design: .rounded))
            }.padding(.vertical, -5)
                .padding(.leading, 20)
                .padding(.trailing, 10)
            Divider()
            VStack(alignment: .leading) {
                Text(event.eventname)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                Text(event.time)
                    .font(.system(size: 17, weight: .regular, design: .rounded))
            }.padding(.vertical, -5)
                .padding(.horizontal)
            Spacer()
        }

    }
}




struct MostRecentAchievementCell: View{
    var feat: studentachievement
    @StateObject var imagemanager = imageManager()
    @State var hasAppeared = false
    @State var imagedata = UIImage()
    
    var body:some View{
        VStack(alignment:.leading){
            Image(uiImage: imagedata)
                .resizable()
                .cornerRadius(10)
                .aspectRatio(contentMode: .fit)
                .padding(.vertical, 2)
            VStack(alignment: .leading, spacing:2){
                HStack {
                    Spacer()
                    Text(feat.achievementtitle)
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    Spacer()
                }
                Text(feat.achievementdescription)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .padding(.leading, 5)
                HStack{
                    Text("Read more")
                        .foregroundColor(.blue)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .padding(.leading, 5)
                    Spacer()
                    Text("By : " + feat.articleauthor)
                        .foregroundColor(.gray)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .padding(.trailing, 5)
                }
//                    Text("Click here to read more")
//                        .foregroundColor(.blue)
//                        .lineLimit(2)
//                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        .padding(.leading, 5)

            }
        }
        
        .onAppear {
            if !hasAppeared {
                imagemanager.getImageFromStorage(fileName: feat.images.first!) { uiimage in
                    if let uiimage = uiimage {
                        imagedata = uiimage
                    }
                }
                hasAppeared = true
            } else {
            }
            
        }
        
        .padding(.horizontal)
        .padding(.vertical)
        .background(Rectangle()
            .cornerRadius(20.0)
            //.padding(.leading,20)
            .shadow(radius: 10)
            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView().environmentObject(UserInfo())
   }
}

struct UpcomingEventsList: View{
    var UEC: event
    var body:some View{
        HStack {
            VStack {
                Text(UEC.eventname)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                Text(UEC.eventname)
                    .font(.system(size: 24))
            }.padding(.vertical, -5)
                .padding(.leading, 20)
                .padding(.trailing, 10)
            Divider()
            VStack(alignment: .leading) {
                Text(UEC.eventname)
                    .fontWeight(.semibold)
                Text(UEC.eventname)
            }.padding(.vertical, -5)
                .padding(.horizontal)
            Spacer()
        }
        Divider()
            .padding(.horizontal)
            .padding(.vertical, 5)
    }
}
