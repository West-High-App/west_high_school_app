//NEWSTS
//
//  ContentView.swift
//  West App
//
//  Created by Aiden Lee on 69/420/69
//

import SwiftUI
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

enum MenuItem: String, CaseIterable {

    case home
    case announcments
    case activities
    case calendar
    case profile

    var description: String {
        switch self {
        case .home:
            return "Home"
        case .activities:
            return "Clubs"
        case .announcments:
            return "Messages"
        case .calendar:
            return "Sports"
        case .profile:
            return "Info"
        }
    }
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .activities:
            return "dice.fill"
        case .announcments:
            return "megaphone.fill"
        case .calendar:
            return "basketball.fill"
        case .profile:
            return "info.circle.fill"
        }
    }
}
extension UIApplication {
    static var safeAreaInsets: UIEdgeInsets  {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets ?? .zero
    }
}
struct MenuView : View {
    var tabItems = MenuItem.allCases
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var dataManager: DataManager
    @State var selected: MenuItem = .home
    @State var isShutDown = false
    @State var shutdownMessage = ""
    @StateObject var shutdownmanager = ShutdownManager()
    let westyellow = Color(red:248/255, green:222/255, blue:8/255)
    let westblue = Color(red: 41/255, green: 52/255, blue: 134/255)
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View{
        if !isShutDown {
        VStack(spacing: 0){
            TabView(selection: $selected){

                HomeMainView()
                    .environmentObject(userInfo)
                    .tag(tabItems[0])
                    .ignoresSafeArea(.all)
                AnnouncementsView()
                    .environmentObject(userInfo)
                    .tag(tabItems[1])
                    .ignoresSafeArea(.all)
                ClubsHibabi()
                    .environmentObject(userInfo)
                    .tag(tabItems[2])
                    .ignoresSafeArea(.all)
                SportsHibabi()
                    .environmentObject(userInfo)
                    .tag(tabItems[3])
                    .ignoresSafeArea(.all)
                InformationView()
                    .environmentObject(userInfo)
                    .tag(tabItems[4])
                    .ignoresSafeArea(.all)
            }
            Spacer(minLength: 0)
            CustomTabbarView(tabItems: tabItems, selected: $selected)
        }
        .onAppear {
            shutdownmanager.fetchData { bool, string in
                print("FROM ON APPEAR")
                print(bool)
                print(string)
                isShutDown = bool
                shutdownMessage = string
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        } else {
            ZStack { // shut down view
                westblue
                    .ignoresSafeArea()
                VStack {
                    Text("West App has been temporarily shut down.")
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
                        .padding()
                        .foregroundColor(westyellow)
                        .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
                }
            }
        }
    }
}
struct CustomTabbarView: View {
    var tabItems: [MenuItem]
    @State var centerX : CGFloat = 2
    @Environment(\.verticalSizeClass) var size
    @Binding var selected: MenuItem

    init(tabItems: [MenuItem], selected: Binding<MenuItem>) {
        UITabBar.appearance().isHidden = true
        self.tabItems = tabItems
        self._selected = selected
    }

    var body: some View {
        HStack(spacing: 0){

            ForEach(tabItems,id: \.self){value in

                GeometryReader{ proxy in
                    BarButton(selected: $selected, centerX: $centerX, rect: proxy.frame(in: .global), value: value)
                        .onAppear(perform: {
                            if value == tabItems.first{
                                centerX = proxy.frame(in: .global).midX
                            }
                        })
                        .onChange(of: size) { (_) in
                            if selected == value{
                                centerX = proxy.frame(in: .global).midX
                            }
                        }
                }
                .frame(width: UIScreen.screenWidth/5.8, height: 50)
                if value != tabItems.last{Spacer(minLength: 0)}
            }
        }
        .padding(.horizontal,25)
        .padding(.top)
        .padding(.bottom,UIApplication.safeAreaInsets.bottom == 0 ? 15 : UIApplication.safeAreaInsets.bottom)
        .background(.ultraThinMaterial, in: CustomShape(centerX: centerX))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
        .padding(.top,-15)
        .ignoresSafeArea(.all, edges: .horizontal)
    }
}
struct BarButton : View {
    @Binding var selected : MenuItem
    @Binding var centerX : CGFloat

    var rect : CGRect
    var value: MenuItem

    var body: some View{
        Button(action: {
            withAnimation(.spring()){
                selected = value
                centerX = rect.midX
            }
        }, label: {
            VStack{
                Image(systemName: value.icon)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 26, height: 26)
                    .foregroundColor(selected == value ? .blue : .gray)

                Text(value.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .opacity(selected == value ? 1 : 0)
            }
            .padding(.top)
            .frame(width: 70, height: 50)
            .offset(y: selected == value ? -15 : 0)
        })
    }
}
struct CustomShape: Shape {
    var centerX : CGFloat
    var animatableData: CGFloat{
        get{return centerX}
        set{centerX = newValue}
    }

    func path(in rect: CGRect) -> Path {
        return Path{path in
            path.move(to: CGPoint(x: 0, y: 15))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 15))
            path.move(to: CGPoint(x: centerX - 35, y: 15))
            //length of bulge
            path.addQuadCurve(to: CGPoint(x: centerX + 35, y: 15), control: CGPoint(x: centerX, y: -30))
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().environmentObject(UserInfo())
    }
}