//
//  HomeView.swift
//  West Ap
//
//  Created by blud what i litterally created this August Andersen on 5/19/23.
// testing push from west_high_app_2 (i think)

import SwiftUI
import UserNotifications



struct HomeView: View {
//    func scrollToTop() {
//        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
//        setContentOffset(desiredOffset, animated: true)
//    }
     @State var firstcurrentevent = studentachievement(documentID: "", achievementtitle: "", achievementdescription: "", articleauthor: "", publisheddate: "", images: [""], isApproved: false, imagedata: [])
    @State var secondcurrentevent = studentachievement(documentID: "", achievementtitle: "", achievementdescription: "", articleauthor: "", publisheddate: "", images: [""], isApproved: false, imagedata: [])
    @State var thirdcurrentevent = studentachievement(documentID: "", achievementtitle: "", achievementdescription: "", articleauthor: "", publisheddate: "", images: [""], isApproved: false, imagedata: [])
    @State var screen = ScreenSize()
    @State var clubmanager = clubManager()
     @StateObject var newsDataManager = Newslist.shared
     @ObservedObject var upcomingeventsdataManager = upcomingEventsDataManager.shared
     @StateObject var loading = Loading()

    // permissions
    @ObservedObject var sportsnewsmanager = sportsNewslist()
    var permissionsManager = permissionsDataManager()
    @State private var hasPermissionUpcomingEvents = false
    @State private var hasPermissionSpotlight = false
    @State private var hasAdmin = false

     @StateObject var spotlightManager = studentachievementlist.shared
    @State var newstitlearray: [studentachievement] = []
     
     @State private var isLoading = false
    
    @State var hasPermissionsUpcomingEvents = false
    //var notiManager = NotificationsManager()
    //var safeArea: EdgeInsets
    //var size: CGSize
    // delete init under if being stupid

    init(safeArea: EdgeInsets, size: CGSize) {
        self.safeArea = safeArea
        self.size = size
        upcomingeventsdataManager.getUpcomingEvents()
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
    @StateObject var shutdownmanager = ShutdownManager()
     @State var isShutDown = false
     @State var shutdownMessage = ""

    var body: some View {
        ZStack {
            SwiftUIWebView(url: URL(string:"https://www.google.com/maps")!)
                  .onAppear {
                       shutdownmanager.fetchData { bool, string in
                            isShutDown = bool
                            shutdownMessage = string
                       }
                  }
            StaffView()
            LunchMenuView() // tryna load this shit early
            ClassesView()
            SchoolPolicyGuideView()
            ClubsHibabi()
            SportsHibabi()
            AnnouncementsView()
            UpcomingEventsView(upcomingeventslist: upcomingeventsdataManager.allupcomingeventslist, permission: hasPermissionsUpcomingEvents)
            //MARK: HOME
             if !isShutDown {
                  NavigationView{
                       ScrollView(.vertical) {
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
                                                     UpcomingEventsView(upcomingeventslist: upcomingeventsdataManager.allupcomingeventslist, permission: hasPermissionsUpcomingEvents)
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
                                                          .frame(width: screen.screenWidth-30)
                                                          .font(.system(size: 17, weight: .semibold, design: .rounded))
                                                          .background(Rectangle()
                                                            .foregroundColor(.white)
                                                            .cornerRadius(10)
                                                            .shadow(radius: 2, x: 1, y: 1))                        }
                                           }
                                           
                                           VStack {
                                                UpcomingEventCell(event: upcomingeventsdataManager.firstcurrentevent)
                                                Divider()
                                                     .padding(.horizontal)
                                                     .padding(.vertical, 5)
                                                UpcomingEventCell(event: upcomingeventsdataManager.secondcurrentEvent)
                                                Divider()
                                                     .padding(.horizontal)
                                                     .padding(.vertical, 5)
                                                UpcomingEventCell(event: upcomingeventsdataManager.thirdcurrentEvent)
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
                                                     .minimumScaleFactor(0.8)
                                                     .font(.system(size: 24, weight: .semibold, design: .rounded))
                                                     .padding(.horizontal)
                                                     .lineLimit(1)
                                                
                                                Spacer()
                                                
                                                NavigationLink {
                                                     StudentSpotlight(spotlightarticles: spotlightManager.allstudentachievementlist)
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
                                                          .frame(width: screen.screenWidth-30)
                                                          .font(.system(size: 17, weight: .semibold, design: .rounded))
                                                          .background(Rectangle()
                                                            .foregroundColor(.white)
                                                            .cornerRadius(10)
                                                            .shadow(radius: 2, x: 1, y: 1))                        }
                                                
                                           }
                                           
                                           VStack { // MARK: student spotlight
                                                ForEach(spotlightManager.allstudentachievementlist.filter { $0.isApproved == true }.prefix(3), id: \.id) { article in
                                                    NavigationLink {
                                                        SpotlightArticles(currentstudentdub: article)
                                                    } label: {
                                                        MostRecentAchievementCell(feat: article)
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
                            
                            .onChange(of: spotlightManager.allstudentachievementlist, perform: { newValue in
                                 print("LIST CHANGED")
                                 if newValue.count > 0 { // onAppear content
                                      
                                      print("LOADING HOME VIEW")
                                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                           print("IS DONE LOADING?")
                                           print(loading.hasLoaded)
                                           // this is where the view loads, should have been changed with the .onChange
                                           if !hasAppeared {
                                                
                                                permissionsManager.checkPermissions(dataType: "StudentAchievements", user: userInfo.email) { result in
                                                     self.hasPermissionSpotlight = result
                                                }
                                                permissionsManager.checkPermissions(dataType: "Article Admin", user: userInfo.email) { result in
                                                     self.hasPermissionSpotlight = result
                                                }
                                                permissionsManager.checkPermissions(dataType: "Article Writer", user: userInfo.email) { result in
                                                     self.hasPermissionSpotlight = result
                                                }
                                                permissionsManager.checkPermissions(dataType: "UpcomingEvents", user: userInfo.email) { result in
                                                     self.hasPermissionUpcomingEvents = result
                                                }
                                                permissionsManager.checkPermissions(dataType: "Admin", user: userInfo.email) { result in
                                                     self.hasAdmin = result
                                                     if result {
                                                          userInfo.isAdmin = true
                                                          self.hasPermissionSpotlight = true
                                                          self.hasPermissionUpcomingEvents = true
                                                          self.hasPermissionUpcomingEvents = true
                                                     }
                                                }
                                                permissionsManager.checkPermissions(dataType: "UpcomingEvents", user: userInfo.email) { result in
                                                     self.hasPermissionsUpcomingEvents = result
                                                }
                                                
                                                spotlightManager.allstudentachievementlist = spotlightManager.allstudentachievementlist
                                                var returnlist: [studentachievement] = []
                                                
                                                let dispatchGroup = DispatchGroup()
                                                
                                                for article in spotlightManager.allstudentachievementlist {
                                                     var tempimages: [UIImage] = []
                                                     
                                                     for imagepath in article.images {
                                                          dispatchGroup.enter()
                                                          imagemanager.getImage(fileName: imagepath) { uiimage in
                                                               print("getting from firebase")

                                                               if let uiimage = uiimage {
                                                                    tempimages.append(uiimage)
                                                               }
                                                               dispatchGroup.leave()
                                                          }
                                                     }
                                                     // MARK: change get image from storgae to get image
                                                     dispatchGroup.notify(queue: .main) {
                                                          returnlist.append(studentachievement(documentID: article.documentID, achievementtitle: article.achievementtitle, achievementdescription: article.achievementdescription, articleauthor: article.articleauthor, publisheddate: article.publisheddate, images: article.images, isApproved: article.isApproved, imagedata: tempimages))
                                                          
                                                          spotlightManager.allstudentachievementlist = returnlist
                                                          self.spotlightManager.allstudentachievementlist = self.spotlightManager.allstudentachievementlist.sorted { first, second in
                                                               let dateFormatter = DateFormatter()
                                                               dateFormatter.dateFormat = "MMM dd, yyyy"
                                                               let firstDate = dateFormatter.date(from: first.publisheddate) ?? Date()
                                                               let secondDate = dateFormatter.date(from: second.publisheddate) ?? Date()
                                                               return firstDate < secondDate
                                                          }.reversed()
                                                          if self.spotlightManager.allstudentachievementlist.count > 0{
                                                               self.firstcurrentevent = self.spotlightManager.allstudentachievementlist[0]
                                                          }
                                                          if self.spotlightManager.allstudentachievementlist.count > 1 {
                                                               self.secondcurrentevent =   self.spotlightManager.allstudentachievementlist[1]
                                                          }
                                                          if self.spotlightManager.allstudentachievementlist.count > 2 {
                                                               self.thirdcurrentevent = self.spotlightManager.allstudentachievementlist[2]
                                                          }
                                                          print("DONE LOADING HOMEVIEW")
                                                     }
                                                     
                                                }
                                                
                                                hasAppeared = true
                                           }
                                      }
                                      
                                 }
                            })
                            
                            // checking for permissions on appear
                            .onAppear {
                                 isLoading = true
                                 if spotlightManager.allstudentachievementlist.count < 1 {
                                      print("LIST IS LESS THAN 1")
                                 }
                            }
                            
                       }
                       .background(westblue)
                       .coordinateSpace(name: "SCROLL")
                       .padding(.top, -60)
                  }
             } else {
                  ZStack {
                      westblue
                          .ignoresSafeArea()
                      VStack {
                          Text("West App has been temporarily shut down")
                              .lineLimit(2)
                              .minimumScaleFactor(0.2)
                              .multilineTextAlignment(.center)
                              .font(.system(size: 26, weight: .semibold, design: .rounded))
                              .fontWeight(.medium)
                              .padding(.horizontal)
                              .foregroundColor(westyellow)
                              .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                          Text(shutdownMessage)
                              .lineLimit(2)
                              .minimumScaleFactor(0.2)
                              .multilineTextAlignment(.center)
                              .font(.system(size: 20, weight: .semibold, design: .rounded))
                              .fontWeight(.medium)
                              .padding(.horizontal)
                              .foregroundColor(westyellow)
                              .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                      }

                  }
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
                    .font(.system(size: 14, weight: .medium, design: .rounded))
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
    @State var screen = ScreenSize()
    
    var body:some View{
        VStack(alignment:.leading){
            Image(uiImage: feat.imagedata.first ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .frame(maxWidth: screen.screenWidth - 60)
                .clipped()
                .cornerRadius(9)
            VStack(alignment: .leading, spacing:2){
                HStack {
                    Text(feat.achievementtitle)
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    Spacer()
                }
                HStack {
                    Text(feat.achievementdescription)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
                HStack{
                    Text("Read more...")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                }
//                    Text("Click here to read more")
//                        .foregroundColor(.blue)
//                        .lineLimit(2)
//                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        .padding(.leading, 5)

            }
        }.padding(.horizontal)
            .padding(.vertical)
            .background(Rectangle()
                .cornerRadius(9)
                //.padding(.leading,20)
                .shadow(radius: 10)
                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
        
        .onAppear {
            if !hasAppeared {
                 guard let image = feat.images.first else { return }
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

// github test plzplz

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