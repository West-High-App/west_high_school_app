//NEWSTS
//
//  ContentView.swift
//  West App
//
//  Created by Aiden Lee on 69/420/69
//

import SwiftUI

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
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View{
        
        VStack(spacing: 0){
            TabView(selection: $selected){
                
                HomeMainView()
                    .tag(tabItems[0])
                    .ignoresSafeArea(.all)
                AnnouncementsView()
                    .tag(tabItems[1])
                    .ignoresSafeArea(.all)
                ClubsHibabi()
                    .tag(tabItems[2])
                    .ignoresSafeArea(.all)
                SportsHibabi()
                    .tag(tabItems[3])
                    .ignoresSafeArea(.all)
                InformationView()
                    .tag(tabItems[4])
                    .ignoresSafeArea(.all)
            }
            Spacer(minLength: 0)
            CustomTabbarView(tabItems: tabItems, selected: $selected)
        }
        .ignoresSafeArea(.all, edges: .bottom)
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
                .frame(width: 67, height: 50)
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
