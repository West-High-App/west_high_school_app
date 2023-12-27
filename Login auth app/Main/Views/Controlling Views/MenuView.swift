//
// MenuView.swift
// West High App
//

import SwiftUI

enum MenuItem: String, CaseIterable {
    
    // Menu items at the bottom of the screen
    case Home
    case Announcements
    case Clubs
    case Sports
    case Information

    // Text for each menu item
    var description: String {
        switch self {
        case .Home:
            return "Home"
        case .Clubs:
            return "Clubs"
        case .Announcements:
            return "Messages"
        case .Sports:
            return "Sports"
        case .Information:
            return "Info"
        }
    }
    
    // Icon for each menu item
    var icon: String {
        switch self {
        case .Home:
            return "house.fill"
        case .Clubs:
            return "dice.fill"
        case .Announcements:
            return "megaphone.fill"
        case .Sports:
            return "basketball.fill"
        case .Information:
            return "info.circle.fill"
        }
    }
}

extension UIScreen {
    
    // Adding accessible screen size components
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    
}

extension UIApplication {
    
    // Finds safe area insets of the screen
    static var safeAreaInsets: UIEdgeInsets  {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets ?? .zero
    }
}

extension Color {
    
    // Creating custom West colors
    static let westYellow = Color(red: 248/255, green: 222/255, blue: 8/255)
    static let westBlue = Color(red: 41/255, green: 52/255, blue: 134/255)
}

struct MenuView: View {
    
    var tabItems = MenuItem.allCases
    @State var selectedItem: MenuItem = .Home
    
    @EnvironmentObject var userInfo: UserInfo
    
    @StateObject var shutdownDataManager = ShutdownManager()
    @State var isShutDown = false
    @State var shutdownMessage = ""
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        if !isShutDown {
            
            VStack(spacing: 0) {
                TabView(selection: $selectedItem){
                    
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
                
                CustomTabBarView(tabItems: tabItems, selected: $selectedItem)
            }
            .ignoresSafeArea(.all, edges: .bottom)
            
            .onAppear {
                
                // Checks if manual shutdown has been activated
                shutdownDataManager.fetchData { isShutDown, shutdownMessage in
                    self.isShutDown = isShutDown
                    self.shutdownMessage = shutdownMessage
                }
            }
        } 
        
        else {
            
            // Display if the app has been manually shut down
            ZStack {
                Color.westYellow
                    .ignoresSafeArea()
                VStack {
                    Text("West App has been temporarily shut down.")
                        .screenMessageStyle(size: 26)
                    Text(shutdownMessage)
                        .screenMessageStyle(size: 20)
                }
            }
            
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        MenuView()
            .environmentObject(UserInfo())
    }
}

struct CustomTabBarView: View {
    
    var tabItems: [MenuItem]
    @Binding var selectedItem: MenuItem

    @State var centerX: CGFloat = 2
    @Environment(\.verticalSizeClass) var size
    
    init(tabItems: [MenuItem], selected: Binding<MenuItem>) {
        UITabBar.appearance().isHidden = true
        self.tabItems = tabItems
        self._selectedItem = selected
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            ForEach(tabItems,id: \.self) { tabItem in
                
                // Animates around selected item
                GeometryReader { proxy in
                    
                    BarButton(selectedMenuItem: $selectedItem, menuItem: tabItem, centerX: $centerX, rect: proxy.frame(in: .global))
                        .onAppear {
                            if tabItem == tabItems.first {
                                centerX = proxy.frame(in: .global).midX
                            }
                        }
                    
                        .onChange(of: size) { (_) in
                            if selectedItem == tabItem {
                                centerX = proxy.frame(in: .global).midX
                            }
                        }
                    
                }
                .frame(width: UIScreen.screenWidth/5.8, height: 50)
                
                if tabItem != tabItems.last {
                    Spacer(minLength: 0)
                }
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

struct BarButton: View {
    
    @Binding var selectedMenuItem: MenuItem
    var menuItem: MenuItem

    @Binding var centerX: CGFloat
    var rect: CGRect

    var body: some View{
        
        Button {
            withAnimation(.spring()) {
                selectedMenuItem = menuItem
                centerX = rect.midX
            }
            
        } label: {
            
            VStack{
                Image(systemName: menuItem.icon)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 26, height: 26)
                    .foregroundColor(selectedMenuItem == menuItem ? .blue : .gray)

                Text(menuItem.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .opacity(selectedMenuItem == menuItem ? 1 : 0)
            }
            .padding(.top)
            .frame(width: 70, height: 50)
            .offset(y: selectedMenuItem == menuItem ? -15 : 0)
            
        }
    }
}

struct CustomShape: Shape {
    
    var centerX: CGFloat
    
    var animatableData: CGFloat {
        get { return centerX}
        set { centerX = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 15))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 15))
            path.move(to: CGPoint(x: centerX - 35, y: 15))
            // Length of bulge
            path.addQuadCurve(to: CGPoint(x: centerX + 35, y: 15), control: CGPoint(x: centerX, y: -30))
        }
    }
}

extension Text {
    
    func screenMessageStyle(size: CGFloat) -> some View {
        self
            .lineLimit(2)
            .minimumScaleFactor(0.2)
            .multilineTextAlignment(.center)
            .font(.system(size: size, weight: .semibold, design: .rounded))
            .fontWeight(.medium)
            .padding(.horizontal)
            .foregroundColor(Color.yellow)
            .shadow(color: .black, radius: 2, x: 1.5, y: 1.5)
    }
}
