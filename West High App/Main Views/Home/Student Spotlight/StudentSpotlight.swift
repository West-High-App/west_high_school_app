//
//  StudentSpotLight.swift
//  West High App
//

import SwiftUI

struct StudentSpotlight: View {
    @EnvironmentObject var userInfo: UserInfo
    @ObservedObject var spotlightManager = studentachievementlist.shared
    @StateObject var imagemanager = imageManager()
    var spotlightarticles: [studentAchievement] {
        spotlightManager.allstudentachievementlist
    }
    @StateObject var hasPermission = PermissionsCheck.shared
    @State var hasAppeared = false
    @State var newstitlearray: [studentAchievement] = []
    @State var isLoading = false
    
    @State var isConfirmingDeleteAchievement = false
    @State private var achievementToDelete: studentAchievement?
    @State var isPresentingAddAchievement = false
    @State var selectedAchievement: studentAchievement?
    
    @State var selectedArticle = studentAchievement(documentID: "", achievementtitle: "", achievementdescription: "", articleauthor: "", publisheddate: "", date: Date(), images: [], isApproved: false, writerEmail: "", imagedata: [])
    @State var selectedIndex = 0
    
    @State var usableType: studentAchievement?
    @State var usableTypeImageData: [UIImage] = []
    
    @State var isConfirmingApproveAchievement = false
    
    @State var presentingArticleSheet = false

    @State var screen = ScreenSize()
    
    @State private var tempAchievementTitle = ""
    
    class ScreenSize {
        let screen: CGRect
        let screenWidth: CGFloat
        let screenHeight: CGFloat
        
        init() {
            screen = UIScreen.main.bounds
            screenWidth = screen.width
            screenHeight = screen.height
        }
    }
    
    @State var showingPendingArticles = false
    
    var pendingCount: Int {
        return spotlightManager.allstudentachievementlist.filter { !$0.isApproved }.count
    }
    
    var pendingString: String {
        return pendingCount == 0 ? "" : " (\(pendingCount))"
    }
    
    var pendingArticlesEmpty: Bool {
        
        var flag = false
        for article in spotlightManager.allstudentachievementlist {
            if !flag {
                if !article.isApproved {
                    flag = true
                }
            }
        }
        
        return !flag
    }
    
    var body: some View {
        
        if !showingPendingArticles {
            
            ZStack {
                ScrollView {
                    LazyVStack {
                        HStack {
                            Text("Student Spotlight")
                                .foregroundColor(Color.black)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .lineLimit(2)
                                .padding(.leading)
                            Spacer()
                            
                            // add a spotlight article
                            if hasPermission.articleadmin {
                                
                                Button {
                                    isPresentingAddAchievement = true
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .foregroundColor(.blue)
                                        .padding(.trailing)
                                        .font(.system(size: 26, design: .rounded))
                                }
                                
                                .sheet(isPresented: $isPresentingAddAchievement) {
                                    AchievementDetailView(dataManager: spotlightManager, editingAchievement: nil, displayimages: [])
                                }
                                .sheet(item: $selectedAchievement) { achievement in
                                    AchievementDetailView(dataManager: spotlightManager, editingAchievement: achievement)
                                }
                            }
                            
                        }
                        HStack {
                            Text("Articles")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 26, weight: .semibold, design: .rounded))
                                .lineLimit(1)
                                .padding(.leading)
                            Spacer()
                        }
                        ForEach(spotlightarticles, id: \.id) { news in
                            if news.isApproved { // checking if article is approved
                                NavigationLink {
                                    SpotlightArticles(currentstudentdub: news)
                                } label: {
                                    achievementcell(feat: news)
                                    
                                        .contextMenu {
                                            if hasPermission.articleadmin {
                                                Button("Delete", role: .destructive) {
                                                    isConfirmingDeleteAchievement = true
                                                    achievementToDelete = news
                                                }
                                            }
                                        }
                                    
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                        .alert(isPresented: $isConfirmingDeleteAchievement) {
                            Alert(
                                title: Text("Delete Article?"),
                                message: Text("This action cannot be undone."),
                                primaryButton: .destructive(Text("Delete")) {
                                    if let achievementToDelete = achievementToDelete {
                                        withAnimation {
                                            spotlightManager.deleteAchievment(achievement: achievementToDelete) { error in
                                                if let error = error {
                                                    print("Error deleting achievement: \(error.localizedDescription)")
                                                }
                                            }
                                            withAnimation {
                                                spotlightManager.allstudentachievementlistUnsorted.removeAll {$0.achievementdescription == achievementToDelete.achievementdescription && $0.date == achievementToDelete.date}
                                            }
                                        }
                                    }
                                },
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
                        
                        
                        .padding(.horizontal)
                        if !spotlightManager.allstudentachievementlist.isEmpty && !spotlightManager.allDocsLoaded {
                            ProgressView()
                                .padding()
                                .onAppear {
                                    spotlightManager.getMoreAchievements()
                                }
                        }
                    }
                }
                
                .navigationBarItems(
                    trailing:
                        Group {
                            if hasPermission.articles {
                                Button(showingPendingArticles ? "Show Public Articles" : "Show Pending Articles\(pendingString)") {
                                    withAnimation {
                                        showingPendingArticles.toggle()
                                    }
                                }
                            }
                        }
                )
                
                .onAppear {
                    if  !hasAppeared { // !hasAppeared
                        print("LOADING....")
                        
                        var returnlist: [studentAchievement] = []
                        
                        let dispatchGroup = DispatchGroup() // Create a Dispatch Group
                        
                        for article in spotlightarticles {
                            var tempimages: [UIImage] = []
                            
                            for imagepath in article.images {
                                dispatchGroup.enter() // Enter the Dispatch Group before each async call
                                imagemanager.getImage(fileName: imagepath) { uiimage in
                                    if let uiimage = uiimage {
                                        tempimages.append(uiimage)
                                        print("FOUND SPOTLIGHT IMAGE")
                                    }
                                    dispatchGroup.leave() // Leave the Dispatch Group when the async call is done
                                }
                            }
                            
                            dispatchGroup.notify(queue: .main) { // This block will be executed after all async calls are done
                                returnlist.append(studentAchievement(documentID: article.documentID, achievementtitle: article.achievementtitle, achievementdescription: article.achievementdescription, articleauthor: article.articleauthor, publisheddate: article.publisheddate, date: article.date, images: article.images, isApproved: article.isApproved, writerEmail: article.writerEmail, imagedata: tempimages))
                                
                                isLoading = false
                                print("DONE LOADING")
                            }
                        }
                        
                        hasAppeared = true
                    }
                }
                if isLoading {
                    ZStack {
                        Color.white
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack {
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                    }
                }
                
                
            }
        } else {
            if hasPermission.articleadmin {
                ZStack {
                    ScrollView {
                        LazyVStack {
                            HStack {
                                Text("Pending Articles")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .lineLimit(2)
                                    .padding(.leading)
                                Spacer()
                            }
                            if !pendingArticlesEmpty {
                                ForEach(spotlightManager.allstudentachievementlist, id: \.id) { achievement in
                                    if !achievement.isApproved {
                                        achievementcell(feat: achievement)
                                            .contextMenu {
                                                Button("Edit") {
                                                    print(selectedArticle)
                                                    self.selectedArticle = achievement
                                                    if let index = spotlightManager.allstudentachievementlist.firstIndex(of: achievement) {
                                                        selectedIndex = index
                                                    }
                                                    presentingArticleSheet = true
                                                    self.selectedArticle = achievement
                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            .onTapGesture {
                                                print(selectedArticle)
                                                self.selectedArticle = achievement
                                                if let index = spotlightManager.allstudentachievementlist.firstIndex(of: achievement) {
                                                    selectedIndex = index
                                                }
                                                presentingArticleSheet = true
                                                self.selectedArticle = achievement
                                            }
                                            .sheet(isPresented: $presentingArticleSheet) {
                                                VStack {
                                                    if let usableType = usableType {
                                                        HStack {
                                                            Button("Cancel") {
                                                                presentingArticleSheet = false
                                                            }.padding()
                                                            Spacer()
                                                        }
                                                        VStack {
                                                            ScrollView{
                                                                VStack{
                                                                    HStack {
                                                                        Text(usableType.achievementtitle)
                                                                            .foregroundColor(Color.black)
                                                                            .titleText()
                                                                            .lineLimit(2)
                                                                            .minimumScaleFactor(0.3)
                                                                            .padding(.horizontal)
                                                                        Spacer()
                                                                    }
                                                                    HStack {
                                                                        Text(usableType.articleauthor)
                                                                            .foregroundColor(Color.gray)
                                                                            .font(.system(size: 26, weight: .semibold, design: .rounded))
                                                                            .lineLimit(1)
                                                                            .padding(.horizontal)
                                                                        Spacer()
                                                                    }
                                                                    HStack {
                                                                        Text(usableType.publisheddate)
                                                                            .foregroundColor(Color.gray)
                                                                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                                                                            .lineLimit(1)
                                                                            .padding(.horizontal)
                                                                        Spacer()
                                                                    }
                                                                    
                                                                    
                                                                    VStack {
                                                                        TabView {
                                                                            
                                                                            ForEach(usableTypeImageData.indices, id: \.self) { index in
                                                                                ZStack {
                                                                                    Rectangle()
                                                                                        .foregroundColor(.white)
                                                                                    
                                                                                    VStack(spacing: 0) {
                                                                                        Image(uiImage: usableTypeImageData[index])
                                                                                            .resizable()
                                                                                            .aspectRatio(contentMode: .fill)
                                                                                            .frame(width: screen.screenWidth - 30, height: 250)
                                                                                            .clipped()
                                                                                    }
                                                                                }
                                                                            }
                                                                            
                                                                            
                                                                        }
                                                                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                                                                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                                                                        
                                                                    }.cornerRadius(30)
                                                                        .frame(width: screen.screenWidth - 30, height: 250)
                                                                        .shadow(color: .gray, radius: 8, x:2, y:3)
                                                                    
                                                                        .padding(.horizontal)
                                                                    Spacer()
                                                                }.onAppear {
                                                                }
                                                                
                                                                LinkTextView(text: usableType.achievementdescription)
                                                                    .multilineTextAlignment(.leading)
                                                                    .foregroundColor(Color.black)
                                                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                                                    .padding(.horizontal, 25)
                                                                    .padding(.vertical, 5)
                                                                    .background(Rectangle()
                                                                        .cornerRadius(10)
                                                                        .padding(.horizontal)
                                                                        .shadow(radius: 5, x: 3, y: 3)
                                                                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                                                                    .padding(.bottom)
                                                                
                                                                if hasPermission.articleadmin {
                                                                    HStack {
                                                                        Spacer()
                                                                        Button {
                                                                            isConfirmingDeleteAchievement = true
                                                                            achievementToDelete = usableType
                                                                        } label: {
                                                                            Text("Delete")
                                                                                .foregroundColor(.white)
                                                                                .fontWeight(.semibold)
                                                                                .padding(10)
                                                                                .cornerRadius(15.0)
                                                                                .frame(width: screen.screenWidth/2-60)
                                                                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                                                                .background(Rectangle()
                                                                                    .foregroundColor(.red)
                                                                                    .cornerRadius(10)
                                                                                )
                                                                        }
                                                                        .alert(isPresented: $isConfirmingDeleteAchievement) {
                                                                            Alert(
                                                                                title: Text("Delete Article?"),
                                                                                message: Text("This action cannot be undone."),
                                                                                primaryButton: .destructive(Text("Delete")) {
                                                                                    if let achievementToDelete = achievementToDelete {
                                                                                        withAnimation {
                                                                                            spotlightManager.deleteAchievment(achievement: achievementToDelete) { error in
                                                                                                if let error = error {
                                                                                                    print("Error deleting achievement: \(error.localizedDescription)")
                                                                                                }
                                                                                            }
                                                                                            withAnimation {
                                                                                                spotlightManager.allstudentachievementlistUnsorted.removeAll {$0.achievementdescription == achievementToDelete.achievementdescription && $0.date == achievementToDelete.date}
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                },
                                                                                secondaryButton: .cancel(Text("Cancel"))
                                                                            )
                                                                        }
                                                                        Spacer()
                                                                        Button {
                                                                            presentingArticleSheet = false
                                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                                                tempAchievementTitle = selectedArticle.achievementtitle
                                                                                isConfirmingApproveAchievement = true
                                                                                achievementToDelete = usableType
                                                                            }
                                                                        } label: {
                                                                            Text("Approve")
                                                                                .foregroundColor(.white)
                                                                                .fontWeight(.semibold)
                                                                                .padding(10)
                                                                                .cornerRadius(15.0)
                                                                                .frame(width: screen.screenWidth/2-60)
                                                                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                                                                .background(Rectangle()
                                                                                    .foregroundColor(.blue)
                                                                                    .cornerRadius(10)
                                                                                )
                                                                        }
                                                                        Spacer()
                                                                    }.padding(.bottom)
                                                                }
                                                                
                                                                // TODO: add a button for if the user is an editor AND their email matches with the current article's editorEmail, then you can delete it :)
                                                                
                                                            }
                                                            
                                                        }
                                                    }
                                                }.onAppear {
                                                    print(selectedArticle)
                                                    usableType = spotlightManager.allstudentachievementlist[selectedIndex]
                                                    usableTypeImageData.removeAll()
                                                    let dispatchGroup = DispatchGroup()
                                                    
                                                    for images in usableType?.images ?? [] {
                                                        dispatchGroup.enter()
                                                        imagemanager.getImage(fileName: images) { uiimage in
                                                            if let uiimage = uiimage {
                                                                usableTypeImageData.append(uiimage)
                                                                print("FOUND SPOTLIGHT IMAGE")
                                                            }
                                                            dispatchGroup.leave() // Leave the Dispatch Group when the async call is done
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }
                                            .alert(isPresented: $isConfirmingApproveAchievement) {
                                                Alert(
                                                    title: Text("Approve Article?"),
                                                    message: Text("This action cannot be undone."),
                                                    primaryButton: .default(Text("Approve")) {
                                                        if let achievementToDelete = achievementToDelete {
                                                            withAnimation {
                                                                spotlightManager.deleteAchievment(achievement: achievementToDelete) { error in
                                                                    if let error = error {
                                                                        print("Error deleting achievement: \(error.localizedDescription)")
                                                                    }
                                                                }
                                                            }
                                                            var tempachievement = achievementToDelete
                                                            tempachievement.isApproved = true
                                                            
                                                            var i = 0
                                                            for image in tempachievement.images {
                                                                if tempachievement.imagedata.count > i {
                                                                    imagemanager.cacheImageInUserDefaults(image: tempachievement.imagedata[i], fileName: image)
                                                                }
                                                                i = i + 1
                                                            }
                                                            
                                                            spotlightManager.createAchievement(achievement: tempachievement) { error in
                                                                if let error = error {
                                                                    print("Error approving achievement: \(error.localizedDescription)")
                                                                }
                                                            }
                                                        }
                                                    },
                                                    secondaryButton: .cancel(Text("Cancel"))
                                                )
                                            }
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)
                                .navigationBarItems(
                                    trailing:
                                        Group {
                                            if hasPermission.articles {
                                                Button(showingPendingArticles ? "Show Public Articles" : "Show Pending Articles\(pendingString)") {
                                                    withAnimation {
                                                        showingPendingArticles.toggle()
                                                    }
                                                }
                                            }
                                        }
                                )
                            } else {
                                Spacer()
                                    .frame(height: 10)
                                Text("No pending articles.")
                                    .lineLimit(1)
                                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                                    .padding(.leading, 5)
                                Spacer()
                                    .navigationBarItems(
                                        trailing:
                                            Group {
                                                if hasPermission.articles {
                                                    Button(showingPendingArticles ? "Show Public Articles" : "Show Pending Articles\(pendingString)") {
                                                        withAnimation {
                                                            showingPendingArticles.toggle()
                                                        }
                                                    }
                                                }
                                            }
                                    )
                            }
                        }
                    }
                }
            } else if hasPermission.articlewriter {
                ZStack {
                    ScrollView {
                        LazyVStack {
                            HStack {
                                Text("Pending Articles")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .lineLimit(2)
                                    .padding(.leading)
                                Spacer()
                            }
                            if !pendingArticlesEmpty {
                                ForEach(spotlightManager.allstudentachievementlist, id: \.id) { achievement in
                                    if !achievement.isApproved {
                                        achievementcell(feat: achievement)
                                            .contextMenu {
                                                Button("Delete", role:.destructive) {
                                                    presentingArticleSheet = false
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        tempAchievementTitle = selectedArticle.achievementtitle
                                                        isConfirmingDeleteAchievement = true
                                                        achievementToDelete = usableType
                                                    }
                                                }
                                            }
                                            .alert(isPresented: $isConfirmingDeleteAchievement) {
                                                Alert(
                                                    title: Text("Delete Article?"),
                                                    message: Text("This action cannot be undone."),
                                                    primaryButton: .destructive(Text("Delete")) {
                                                        if let achievementToDelete = achievementToDelete {
                                                            withAnimation {
                                                                spotlightManager.deleteAchievment(achievement: achievementToDelete) { error in
                                                                    if let error = error {
                                                                        print("Error deleting achievement: \(error.localizedDescription)")
                                                                    }
                                                                }
                                                                withAnimation {
                                                                    spotlightManager.allstudentachievementlistUnsorted.removeAll {$0.achievementdescription == achievementToDelete.achievementdescription && $0.date == achievementToDelete.date}
                                                                }
                                                            }
                                                        }
                                                    },
                                                    secondaryButton: .cancel(Text("Cancel"))
                                                )
                                            }
                                            .onTapGesture {
                                                print(selectedArticle)
                                                self.selectedArticle = achievement
                                                if let index = spotlightManager.allstudentachievementlist.firstIndex(of: achievement) {
                                                    selectedIndex = index
                                                }
                                                presentingArticleSheet = true
                                                self.selectedArticle = achievement
                                            }
                                            .sheet(isPresented: $presentingArticleSheet) {
                                                VStack {
                                                    if let usableType = usableType {
                                                        HStack {
                                                            Button("Cancel") {
                                                                presentingArticleSheet = false
                                                            }.padding()
                                                            Spacer()
                                                        }
                                                        VStack {
                                                            ScrollView{
                                                                VStack{
                                                                    HStack {
                                                                        Text(usableType.achievementtitle)
                                                                            .foregroundColor(Color.black)
                                                                            .titleText()
                                                                            .lineLimit(2)
                                                                            .minimumScaleFactor(0.3)
                                                                            .padding(.horizontal)
                                                                        Spacer()
                                                                    }
                                                                    HStack {
                                                                        Text(usableType.articleauthor)
                                                                            .foregroundColor(Color.gray)
                                                                            .font(.system(size: 26, weight: .semibold, design: .rounded))
                                                                            .lineLimit(1)
                                                                            .padding(.horizontal)
                                                                        Spacer()
                                                                    }
                                                                    HStack {
                                                                        Text(usableType.publisheddate)
                                                                            .foregroundColor(Color.gray)
                                                                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                                                                            .lineLimit(1)
                                                                            .padding(.horizontal)
                                                                        Spacer()
                                                                    }
                                                                    
                                                                    
                                                                    VStack {
                                                                        TabView {
                                                                            
                                                                            // Loop through each recipe
                                                                            ForEach(usableTypeImageData.indices, id: \.self) { index in
                                                                                ZStack {
                                                                                    Rectangle()
                                                                                        .foregroundColor(.white)
                                                                                    
                                                                                    VStack(spacing: 0) {
                                                                                        Image(uiImage: usableTypeImageData[index])
                                                                                            .resizable()
                                                                                            .aspectRatio(contentMode: .fill)
                                                                                            .frame(width: screen.screenWidth - 30, height: 250)
                                                                                            .clipped()
                                                                                    }
                                                                                }
                                                                            }
                                                                            
                                                                            
                                                                        }
                                                                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                                                                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                                                                        
                                                                    }.cornerRadius(30)
                                                                        .frame(width: screen.screenWidth - 30, height: 250)
                                                                        .shadow(color: .gray, radius: 8, x:2, y:3)
                                                                    
                                                                        .padding(.horizontal)
                                                                    Spacer()
                                                                }.onAppear {
                                                                }
                                                                
                                                                LinkTextView(text: usableType.achievementdescription)
                                                                    .multilineTextAlignment(.leading)
                                                                    .foregroundColor(Color.black)
                                                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                                                    .padding(.horizontal, 25)
                                                                    .padding(.vertical, 5)
                                                                    .background(Rectangle()
                                                                        .cornerRadius(10)
                                                                        .padding(.horizontal)
                                                                        .shadow(radius: 5, x: 3, y: 3)
                                                                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                                                                    .padding(.bottom)
                                                            }
                                                            
                                                        }
                                                    }
                                                }.onAppear {
                                                    print(selectedArticle)
                                                    usableType = spotlightManager.allstudentachievementlist[selectedIndex]
                                                    usableTypeImageData.removeAll()
                                                    let dispatchGroup = DispatchGroup()
                                                    
                                                    for images in usableType?.images ?? [] {
                                                        dispatchGroup.enter()
                                                        imagemanager.getImage(fileName: images) { uiimage in
                                                            if let uiimage = uiimage {
                                                                usableTypeImageData.append(uiimage)
                                                                print("FOUND SPOTLIGHT IMAGE")
                                                            }
                                                            dispatchGroup.leave() // Leave the Dispatch Group when the async call is done
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }
                                    }
                                }
                                .padding(.horizontal)
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                Spacer()
                                    .frame(height: 10)
                                Text("No pending articles.")
                                    .lineLimit(1)
                                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                                    .padding(.leading, 5)
                                Spacer()
                                    .navigationBarItems(
                                        trailing:
                                            Group {
                                                if hasPermission.articles {
                                                    Button(showingPendingArticles ? "Show Public Articles" : "Show Pending Articles\(pendingString)") {
                                                        withAnimation {
                                                            showingPendingArticles.toggle()
                                                        }
                                                    }
                                                }
                                            }
                                    )
                            }
                        }
                    }
                }
            }
        }
    }
    }

class ScreenSize {
    let screen: CGRect
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    
    init() {
        screen = UIScreen.main.bounds
        screenWidth = screen.width
        screenHeight = screen.height
    }
}

    struct achievementcell: View{
        var feat: studentAchievement
        @StateObject var imagemanager = imageManager()
        @State var imagedata = UIImage()
        @State var screen = ScreenSize()
        @State var hasAppeared = false
        
        var body:some View{
            VStack{
                Image(uiImage: feat.imagedata.first ?? imagedata)
                    .resizable()
                    .padding(.bottom, 2)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screen.screenWidth - 20, height: 250)
                    .clipped()
                    .cornerRadius(30)
                VStack(alignment: .leading, spacing:2){
                    HStack{
                        Text("By " + feat.articleauthor)
                            .foregroundColor(.secondary)
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                        Text(feat.publisheddate)
                            .foregroundColor(.secondary)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    Text(feat.achievementtitle)
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                        .font(.system(size: 24, weight: .semibold))
                    Text(feat.achievementdescription)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .font(.system(size: 18, weight: .regular))
//                    Text("Click here to read more")
//                        .foregroundColor(.blue)
//                        .lineLimit(2)
//                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        .padding(.leading, 5)

                }
                //.padding(.horizontal)
                Divider()
                   // .padding(.horizontal)
            }.onAppear {
                if feat.imagedata == [] || feat.imagedata.first == UIImage() || feat.imagedata.first == nil { //
                     guard let image = feat.images.first else { return }
                    print("IMAGE FUNCTION RUN ss")
                     imagemanager.getImage(fileName: image) { uiimage in
                          if let uiimage = uiimage {
                               imagedata = uiimage
                          }
                     }
                     hasAppeared = true
                } else {
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


struct StudentSpotlight_Previews: PreviewProvider {
    static var previews: some View {
        StudentSpotlight()
    }
}
