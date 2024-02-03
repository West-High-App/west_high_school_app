//
//  HomeView.swift
//  West App
//

import SwiftUI
import UserNotifications
import Firebase

struct HomeView: View {
     
     @State var firstcurrentevent = studentAchievement(
          documentID: "",
          achievementtitle: "",
          achievementdescription: "",
          articleauthor: "", publisheddate: "",
          date: Date(),
          images: [""],
          isApproved: false,
          writerEmail: "",
          imagedata: [])
     @State var secondcurrentevent = studentAchievement(documentID: "", achievementtitle: "", achievementdescription: "", articleauthor: "", publisheddate: "", date: Date(), images: [""], isApproved: false, writerEmail: "", imagedata: [])
     @State var thirdcurrentevent = studentAchievement(documentID: "", achievementtitle: "", achievementdescription: "", articleauthor: "", publisheddate: "", date: Date(), images: [""], isApproved: false, writerEmail: "", imagedata: [])
     
     var screen = ScreenSize()
     
     @StateObject var newsDataManager = Newslist.shared
     @ObservedObject var upcomingeventsdataManager = upcomingEventsDataManager.shared
     
     @State var homeImage: UIImage?
     
     // permissions
     @StateObject var hasPermission = PermissionsCheck.shared
     
     @StateObject var spotlightManager = studentachievementlist.shared
          
     @State var date = Date()
     
     let viewdateFormatter = DateFormatter()
     let dateFormatter = DateFormatter()
     
     var safeArea: EdgeInsets
     var size: CGSize
     
     init(safeArea: EdgeInsets, size: CGSize) {
          self.safeArea = safeArea
          self.size = size
          
          viewdateFormatter.dateFormat = "MMMM d, yyyy"
          dateFormatter.dateFormat = "MMM d, yyyy"
     }
     
     @State var hasAppeared = false
     
     @StateObject var imagemanager = imageManager()
     
     @EnvironmentObject var userInfo: UserInfo
          
     func getTime() -> String {
          let hour = Calendar.current.component(.hour, from: Date())
          
          switch hour {
          case 6..<12 : return "morning"
          case 12..<17 : return "afternoon"
          default: return "evening"
          }
     }
     
     @ObservedObject var webViews = WebViewLoader.shared
     
     // MARK: VIEW
     @StateObject var shutdownmanager = ShutdownManager()
     @State var isShutDown = false
     @State var shutdownMessage = ""
     
     var body: some View {
          ZStack {
               if webViews.shouldLoad {
                    StaffView()
                    LunchMenuView()
                    TransportationView()
                    ClassesView()
                    SchoolPolicyGuideView()
               }
               
               if !isShutDown {
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
                                                                                
                                        //MARK: upcoming events
                                        VStack{
                                             NavigationLink {
                                                  UpcomingEventsView(upcomingeventslist: upcomingeventsdataManager.allupcomingeventslist)
                                             } label: {
                                                  HStack {
                                                       Text("Upcoming Events")
                                                            .lineLimit(1)
                                                            .padding(.leading, 15)
                                                            .foregroundColor(Color.westBlue)
                                                            .bold()
                                                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                                                       //.padding(.horizontal)
                                                       //.padding(.vertical, -5)
                                                       
                                                       Spacer()
                                                       HStack{
                                                            Text("See more")
                                                                 .padding(.trailing,-15)
                                                                 .font(.system(size: 17, weight: .semibold, design: .rounded))
                                                       }
                                                       .padding(.horizontal,34)
                                                       .foregroundStyle(.blue)
                                                       
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
                                             }
                                             
                                             // edit button
                                             
                                             if hasPermission.upcomingevents {
                                                  NavigationLink {
                                                       UpcomingEventsAdminView()
                                                  } label: {
                                                       Text("Edit Upcoming Events")
                                                            .foregroundColor(.blue)
                                                            .padding(.vertical, 5)
                                                            .frame(width: screen.screenWidth-30)
                                                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                                                            .background(Rectangle()
                                                                 .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))                                                            .cornerRadius(10)
                                                                 .shadow(radius: 2, x: 1, y: 1))                        }
                                             }
                                             if let firstcurrentevent = upcomingeventsdataManager.firstcurrentevent {
                                                  VStack {
                                                       UpcomingEventCell(event: firstcurrentevent)
                                                       if let secondcurrentEvent = upcomingeventsdataManager.secondcurrentEvent {
                                                            Divider()
                                                                 .padding(.horizontal)
                                                                 .padding(.vertical, 5)
                                                            UpcomingEventCell(event: secondcurrentEvent)
                                                       }
                                                       if let thirdcurrentEvent = upcomingeventsdataManager.thirdcurrentEvent {
                                                            Divider()
                                                                 .padding(.horizontal)
                                                                 .padding(.vertical, 5)
                                                            UpcomingEventCell(event: thirdcurrentEvent)
                                                       }
                                                  }
                                                  .foregroundStyle(.black)
                                                  .padding(.all) //EDIT
                                                  .background(Rectangle()
                                                       .cornerRadius(9.0)
                                                       .padding(.horizontal)
                                                       .shadow(radius: 5, x: 2, y: 2)
                                                              
                                                       .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                                             } else {
                                                  Text("No upcoming events.")
                                                       .foregroundStyle(.black)
                                                       .padding(.all) //EDIT
                                                       .background(Rectangle()
                                                            .cornerRadius(9.0)
                                                            .padding(.horizontal)
                                                            .shadow(radius: 5, x: 2, y: 2)
                                                                   
                                                            .frame(width: screen.screenWidth)
                                                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                                             }
                                        }
                                        
                                        //MARK: student spotlight
                                        
                                        VStack{
                                             NavigationLink {
                                                  StudentSpotlight()
                                             } label: {
                                                  
                                                  HStack {
                                                       Text("Student Spotlight")
                                                            .foregroundColor(Color.westBlue)
                                                            .bold()
                                                            .minimumScaleFactor(0.8)
                                                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                                                            .padding(.horizontal)
                                                            .lineLimit(1)
                                                       
                                                       Spacer()
                                                       
                                                       HStack{
                                                            Text("See more")
                                                                 .font(.system(size: 17, weight: .semibold, design: .rounded))
                                                                 .padding(.trailing,-15)
                                                       }
                                                       .padding(.horizontal,34)
                                                       .foregroundStyle(.blue)
                                                       
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
                                             }
                                             
                                             if hasPermission.articles {
                                                  NavigationLink {
                                                       SpotlightAdminView()
                                                  } label: {
                                                       Text("Edit Spotlight Articles")
                                                            .foregroundColor(.blue)
                                                            .padding(.vertical, 5)
                                                            .frame(width: screen.screenWidth-30)
                                                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                                                            .background(Rectangle()
                                                                 .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))                                                            .cornerRadius(10)
                                                                 .shadow(radius: 2, x: 1, y: 1))
                                                       
                                                  }
                                                  
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
                                   
                                   /* if false {
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
                                    } */
                                   
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
                                             // this is where the view loads, should have been changed with the .onChange
                                             if !hasAppeared {
                                                  
                                                  // getting home image
                                                  
                                                  let db = Firestore.firestore()
                                                  let ref = db.collection("SpecialImages").document("HomeImage")
                                                  ref.getDocument { document, error in
                                                       if let error = error {
                                                            print("Error: \(error.localizedDescription)")
                                                       } else {
                                                            if let document = document, document.exists {
                                                                 if let filename = document.data()?["filename"] as? String {
                                                                      
                                                                      print("FILE NAME FOUND:")
                                                                      print(filename)
                                                                      imagemanager.getImage(fileName: filename) { image in
                                                                           if let image = image {
                                                                                homeImage = image
                                                                           }
                                                                      }
                                                                 }
                                                            }
                                                       }
                                                  }
                                             }
                                             
                                             hasAppeared = true
                                        }
                                        
                                   }
                              })
                              
                              // checking for permissions on appear
                              .onAppear {
                                   if spotlightManager.allstudentachievementlist.count < 1 {
                                        print("LIST IS LESS THAN 1")
                                   }
                              }
                              
                         }
                         
                         .background(Color.westBlue)
                         .coordinateSpace(name: "SCROLL")
                         .padding(.top, -60)
                    }
               } else {
                    ZStack {
                         Color.westBlue
                              .ignoresSafeArea()
                         VStack {
                              Text("West App has been temporarily shut down")
                                   .screenMessageStyle(size: 26)
                              Text(shutdownMessage)
                                   .screenMessageStyle(size: 20)
                         }
                         
                    }
               }
          }.onAppear() {

               if !hasAppeared {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                         hasPermission.updatePermissions()
                    }
               }
               
               hasAppeared = true
          }
     }
     
     
     @ViewBuilder
     func Artwork() -> some View {
          let height = size.height * 0.65
          GeometryReader{ proxy in
               
               let size = proxy.size
               let minY = proxy.frame(in: .named("SCROLL")).minY
               let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
               
               if let homeImage = homeImage {
                    Image(uiImage: homeImage)
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
                                                  Color.westBlue.opacity(0 - progress),
                                                  Color.westBlue.opacity(0 - progress),
                                                  Color.westBlue.opacity(0.05 - progress),
                                                  Color.westBlue.opacity(0.1 - progress),
                                                  Color.westBlue.opacity(0.5 - progress),
                                                  Color.westBlue.opacity(1),
                                             ], startPoint: .top, endPoint: .bottom)
                                        )
                                   VStack(spacing: 0) {
                                        Text(viewdateFormatter.string(from: date)) // Text(date, style: .date)
                                             .lineLimit(1)
                                             .minimumScaleFactor(0.2)
                                             .font(.system(size: 50, weight: .semibold, design: .rounded))
                                             .foregroundColor(Color.westYellow)
                                             .padding(.horizontal)
                                             .fontWeight(.semibold)
                                             .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                                        
                                        //.font(.system(size: 45))
                                        //.fontWeight(.bold)
                                        //.multilineTextAlignment(.center)
                                        if userInfo.loginStatus == "Google"{
                                             Text("Good \(getTime()), \(userInfo.firstName())!")
                                                  .lineLimit(2)
                                                  .minimumScaleFactor(0.2)
                                                  .multilineTextAlignment(.center)
                                                  .font(.system(size: 32, weight: .semibold, design: .rounded))
                                                  .fontWeight(.medium)
                                                  .padding(.horizontal)
                                                  .foregroundColor(Color.westYellow)
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
                                                  .foregroundColor(Color.westYellow)
                                                  .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                                        }
                                   }
                                   .opacity(1 + (progress > 0 ? -progress : progress))
                                   .padding(.bottom, 25)
                                   
                                   // Moving with Scroll View
                                   
                                   .offset(y: minY < 0 ? minY : 0 )
                              }
                         })                .offset(y: -minY)
                    
               } else {
                    Image("west-background")
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
                                                  Color.westBlue.opacity(0 - progress),
                                                  Color.westBlue.opacity(0 - progress),
                                                  Color.westBlue.opacity(0.05 - progress),
                                                  Color.westBlue.opacity(0.1 - progress),
                                                  Color.westBlue.opacity(0.5 - progress),
                                                  Color.westBlue.opacity(1),
                                             ], startPoint: .top, endPoint: .bottom)
                                        )
                                   VStack(spacing: 0) {
                                        Text(viewdateFormatter.string(from: date)) // Text(date, style: .date)
                                             .lineLimit(1)
                                             .minimumScaleFactor(0.2)
                                             .font(.system(size: 50, weight: .semibold, design: .rounded))
                                             .foregroundColor(Color.westYellow)
                                             .padding(.horizontal)
                                             .fontWeight(.semibold)
                                             .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                                        
                                        //.font(.system(size: 45))
                                        //.fontWeight(.bold)
                                        //.multilineTextAlignment(.center)
                                        if userInfo.loginStatus == "Google"{
                                             Text("Good \(getTime()), \(userInfo.firstName())!")
                                                  .lineLimit(2)
                                                  .minimumScaleFactor(0.2)
                                                  .multilineTextAlignment(.center)
                                                  .font(.system(size: 32, weight: .semibold, design: .rounded))
                                                  .fontWeight(.medium)
                                                  .padding(.horizontal)
                                                  .foregroundColor(Color.westYellow)
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
                                                  .foregroundColor(Color.westYellow)
                                                  .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                                        }
                                   }
                                   .opacity(1 + (progress > 0 ? -progress : progress))
                                   .padding(.bottom, 25)
                                   
                                   // Moving with Scroll View
                                   
                                   .offset(y: minY < 0 ? minY : 0 )
                              }
                         })                .offset(y: -minY)
                    
               }
               
               
               
               
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
                                   .foregroundStyle(Color.westYellow)
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
                                   Color.westBlue.opacity(0.5 - titleProgress),
                                   Color.westBlue.opacity(0.4 - titleProgress),
                                   Color.westBlue.opacity(0.3 - titleProgress),
                                   Color.westBlue.opacity(0.2 - titleProgress),
                                   Color.westBlue.opacity(0.1 - titleProgress),
                                   Color.westBlue.opacity(0 - titleProgress),
                                   Color.westBlue.opacity(0 - titleProgress),
                                   Color.westBlue.opacity(0 - titleProgress),
                                   
                                   
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
                    HStack {
                         Text(news.title)
                              .foregroundColor(.black)
                              .font(.system(size: 17, weight: .semibold, design: .rounded))
                              .padding(.horizontal)
                              .padding(.vertical, -5)
                              .lineLimit(1)
                         Spacer()
                    }
                    Text(news.publisheddate)
                         .foregroundColor(.gray)
                         .font(.system(size: 17, weight: .medium, design: .rounded))
                         .padding(.horizontal)
                         .padding(.vertical, -5)
               }
               Divider()
                    .padding(.horizontal)
                    .padding(.vertical, 5)
               
               Text(news.description.replacingOccurrences(of: "  ", with: " "))
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
     let event: event
     @State var hasAppeared = false
     var body:some View{
          HStack {
               VStack {
                    Text(event.date.monthName)
                         .font(.system(size: 14, weight: .medium, design: .rounded))
                         .foregroundColor(.red)
                    Text("\(event.date.dateComponent(.day))")
                         .font(.system(size: 24, weight: .regular, design: .rounded))
               }.padding(.vertical, -5)
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
               Divider()
               VStack(alignment: .leading) {
                    Text(event.eventname)
                         .font(.system(size: 17, weight: .semibold, design: .rounded))
                    Text(event.isAllDay ? "All Day" : event.date.twelveHourTime)
                         .font(.system(size: 17, weight: .regular, design: .rounded))
               }.padding(.vertical, -5)
                    .padding(.horizontal)
               Spacer()
          }
          
     }
}




struct MostRecentAchievementCell: View{
     var feat: studentAchievement
     @StateObject var imagemanager = imageManager()
     @ObservedObject var spotlightManager = studentachievementlist.shared
     @State var hasAppeared = false
     @State var imagedata = UIImage()
     @State var screen = ScreenSize()
     
     var body:some View{
          VStack(alignment:.leading){
               Image(uiImage: feat.imagedata.first ?? imagedata) // (uiImage: feat.imagedata.first ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .frame(maxWidth: screen.screenWidth - 60)
                    .clipped()
                    .cornerRadius(9)
               VStack(alignment: .leading, spacing:2){
                    HStack {
                         Text(feat.achievementtitle)
                              .multilineTextAlignment(.leading)
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
                    if feat.imagedata == [] || feat.imagedata.first == UIImage() || feat.imagedata.first == nil { //
                         guard let image = feat.images.first else { return }
                         print("IMAGE FUNCTION RUN hv")
                         imagemanager.getImage(fileName: image) { uiimage in
                              if let uiimage = uiimage {
                                   imagedata = uiimage
                                   
                                   
                                   // test
                                   var temparticle = spotlightManager.allstudentachievementlistUnsorted.first(where: { $0 == feat })
                                   if temparticle != nil {
                                        temparticle!.imagedata.append(uiimage)
                                        spotlightManager.allstudentachievementlistUnsorted.removeAll(where: { $0 == feat })
                                        spotlightManager.allstudentachievementlistUnsorted.append(temparticle!)
                                   }
                                   
                                   
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

class WebViewLoader: ObservableObject {
     static let shared = WebViewLoader()
     
     @Published var shouldLoad = true
}
