import SwiftUI
struct dubachievementcell: View{
    var feat: studentAchievement
    @StateObject var imagemanager = imageManager()
    @State var imagedata: UIImage = UIImage()
    @State var screen = ScreenSize()
    @State var hasAppeared = false
    
    var body:some View{
        VStack{
            Image(uiImage: imagedata)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .frame(maxWidth: screen.screenWidth - 60)
                .clipped()
                .cornerRadius(9)
            VStack(alignment: .leading, spacing:2){
                HStack {
                    Text(feat.articleauthor)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .padding(.leading, 5)
                    Spacer()
                    Text(feat.publisheddate)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .padding(.leading, 5)
                }
                Text(feat.achievementtitle)
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .padding(.leading, 5)
                Text(feat.achievementdescription)
                    .foregroundColor(.secondary)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .padding(.leading, 5)
                    .lineLimit(1)
                
            }
            
            
        }.onAppear {
            if !hasAppeared || feat.imagedata == [] || feat.imagedata.first == UIImage() || feat.imagedata.first == nil { //
                guard let image = feat.images.first else { return }
                print("IMAGE FUNCTION RUN sav")
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

struct SpotlightAdminView: View {
    @ObservedObject var dataManager = studentachievementlist.shared
    @ObservedObject var hasPermission = PermissionsCheck.shared
    @StateObject var userInfo = UserInfo.shared
    
    @State private var isPresentingAddAchievement = false
    @State private var selectedAchievement: studentAchievement?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var tempAchievementTitle = ""
    
    @State private var isConfirmingDeleteAchievement = false
    @State private var isConfirmingDeleteAchievementFinal = false
    @State private var isConfirmingApproveAchievement = false
    
    @State private var achievementToDelete: studentAchievement?
    
    @State var selectedIndex = 0
    @State var usableType: studentAchievement?
    @State var usableTypeImageData: [UIImage] = []
    
    @State var screen = ScreenSize()
    
    @State private var presentingArticleSheet = false
    @State var selectedArticle = studentAchievement(documentID: "", achievementtitle: "", achievementdescription: "", articleauthor: "", publisheddate: "", date: Date(), images: [], isApproved: false, writerEmail: "", imagedata: [])
    
    @State var selected = 1
    
    var pendingCount: Int {
        return dataManager.allstudentachievementlist.filter { !$0.isApproved }.count
    }
    var pendingString: String {
        if pendingCount == 0 {
            return ""
        } else {
            return " (\(pendingCount))"
        }
    }
    
    var articlesEmpty: Bool {
        
        var flag = false
        for article in dataManager.allstudentachievementlist {
            if !flag {
                if article.isApproved {
                    flag = true
                }
            }
        }
        
        return !flag
    }
    
    var pendingArticlesEmpty: Bool {
        
        var flag = false
        for article in dataManager.allstudentachievementlist {
            if !flag {
                if !article.isApproved {
                    flag = true
                }
            }
        }
        
        return !flag
    }
    
    @StateObject var imagemanager = imageManager()
    @State var displayimages: [UIImage] = []
    @State var currentimage: UIImage?
    @State private var isCropping: Bool = false
    @State var isDisplayingAddImage = false
    
    var body: some View {
        VStack {
            HStack {
                if hasPermission.articleadmin{
                    Text("Edit Spotlight Articles")
                        .foregroundColor(Color.black)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .lineLimit(2)
                        .padding(.leading)
                } else {
                    Text("Edit Spotlight Articles")
                        .foregroundColor(Color.black)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .lineLimit(2)
                        .padding(.leading)
                }
                Spacer()
            }
            
            
            if !hasPermission.articleadmin {
                HStack {
                    Text("Add a new pending article to be approved by an administrator using the button below. Press and hold an article you created to delete.")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .padding(.horizontal)
                    Spacer()
                }
            } else {
                HStack {
                    Text("Add a new article using the button below. Press and hold an article to delete. View pending student articles and approve or delete them under Pending.")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .padding(.horizontal)
                    Spacer()
                }
            }
            
            Button {
                isPresentingAddAchievement = true
            } label: {
                if hasPermission.articleadmin {
                    Text("Add Spotlight Article")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding(10)
                        .cornerRadius(15.0)
                        .frame(width: screen.screenWidth-30)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .background(Rectangle()
                            .foregroundColor(.blue)
                            .cornerRadius(10))
                } else {
                    Text("Add Pending Article")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding(10)
                        .cornerRadius(15.0)
                        .frame(width: screen.screenWidth-30)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .background(Rectangle()
                            .foregroundColor(.blue)
                            .cornerRadius(10))
                }
            }
            
            if hasPermission.articleadmin {
                Picker("Selected", selection: $selected) {
                    Text("Edit")
                        .tag(1)
                    Text("Pending\(pendingString)")
                        .tag(2)
                }.pickerStyle(.segmented)
                    .padding(.horizontal)
                
                if selected == 1 {
                    if !articlesEmpty {
                        List {
                            ForEach(dataManager.allstudentachievementlist, id: \.id) { achievement in
                                if achievement.isApproved {
                                    dubachievementcell(feat: achievement)
                                        .buttonStyle(PlainButtonStyle())
                                        .contextMenu {
                                            Button("Delete", role: .destructive) {
                                                tempAchievementTitle = achievement.achievementtitle
                                                isConfirmingDeleteAchievement = true
                                                achievementToDelete = achievement
                                            }
                                        }
                                }
                            }
                            if !dataManager.allstudentachievementlist.isEmpty && !dataManager.allDocsLoaded {
                                ProgressView()
                                    .padding()
                                    .onAppear {
                                        dataManager.getMoreAchievements()
                                    }
                            }
                        }
                    } else {
                        Text("No public articles.")
                            .lineLimit(1)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .padding(.leading, 5)
                    }
                }
                if selected == 2 {
                    if !pendingArticlesEmpty {
                        List {
                            ForEach(dataManager.allstudentachievementlist, id: \.id) { achievement in
                                if !achievement.isApproved {
                                    dubachievementcell(feat: achievement)
                                        .contextMenu {
                                            Button("Edit") {
                                                print(selectedArticle)
                                                self.selectedArticle = achievement
                                                if let index = dataManager.allstudentachievementlist.firstIndex(of: achievement) {
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
                                            if let index = dataManager.allstudentachievementlist.firstIndex(of: achievement) {
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
                                                                        .font(.system(size: 35, weight: .bold, design: .rounded))
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
                                                            
                                                            if hasPermission.articleadmin {
                                                                HStack {
                                                                    Spacer()
                                                                    Button {
                                                                        presentingArticleSheet = false
                                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                                            tempAchievementTitle = selectedArticle.achievementtitle
                                                                            isConfirmingDeleteAchievement = true
                                                                            achievementToDelete = usableType
                                                                        }
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
                                                usableType = dataManager.allstudentachievementlist[selectedIndex]
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
                                                            dataManager.deleteAchievment(achievement: achievementToDelete) { error in
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
                                                        
                                                        dataManager.createAchievement(achievement: tempachievement) { error in
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
                        }
                    } else {
                        Text("No pending articles.")
                            .lineLimit(1)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .padding(.leading, 5)
                        Spacer()
                    }
                }
            } else {
                if pendingCount != 0 {
                    Text("Current pending articles:")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .padding(5)
                    List {
                        ForEach(dataManager.allstudentachievementlist, id: \.id) { achievement in
                            if !achievement.isApproved {
                                dubachievementcell(feat: achievement)
                                    .contextMenu {
                                        Button("Edit") {
                                            print(selectedArticle)
                                            self.selectedArticle = achievement
                                            if let index = dataManager.allstudentachievementlist.firstIndex(of: achievement) {
                                                selectedIndex = index
                                            }
                                            presentingArticleSheet = true
                                            self.selectedArticle = achievement
                                        }
                                    }
                                    .onTapGesture {
                                        print(selectedArticle)
                                        self.selectedArticle = achievement
                                        if let index = dataManager.allstudentachievementlist.firstIndex(of: achievement) {
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
                                                                    .font(.system(size: 35, weight: .bold, design: .rounded))
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
                                                        
                                                        if hasPermission.articleadmin {
                                                            HStack {
                                                                Spacer()
                                                                Button {
                                                                    presentingArticleSheet = false
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                                        tempAchievementTitle = selectedArticle.achievementtitle
                                                                        isConfirmingDeleteAchievement = true
                                                                        achievementToDelete = usableType
                                                                    }
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
                                                        else if usableType.writerEmail == userInfo.email {
                                                            HStack {
                                                                Spacer()
                                                                Button {
                                                                    presentingArticleSheet = false
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                                        tempAchievementTitle = selectedArticle.achievementtitle
                                                                        isConfirmingDeleteAchievement = true
                                                                        achievementToDelete = usableType
                                                                    }
                                                                } label: {
                                                                    Text("Remove From Pending")
                                                                        .foregroundColor(.white)
                                                                        .fontWeight(.semibold)
                                                                        .padding(10)
                                                                        .cornerRadius(15.0)
                                                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                                                                        .background(Rectangle()
                                                                            .foregroundColor(.red)
                                                                            .cornerRadius(10)
                                                                        )
                                                                }
                                                                Spacer()
                                                            }
                                                        }
                                                        
                                                        // TODO: add a button for if the user is an editor AND their email matches with the current article's editorEmail, then you can delete it :)
                                                        
                                                    }
                                                    
                                                }
                                            }
                                        }.onAppear {
                                            print(selectedArticle)
                                            usableType = dataManager.allstudentachievementlist[selectedIndex]
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
                    }
                } else {
                    Text("No pending articles.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .padding(5)
                    Spacer()
                }
                
            }
            Spacer()
            
        }
        .onAppear {
            if !dataManager.allstudentachievementlist.isEmpty {
                guard let selectedArticle = dataManager.allstudentachievementlist.first(where: { $0.isApproved == false })
                else {
                    return
                }
                self.selectedArticle = selectedArticle
            }
        }
        .sheet(isPresented: $isPresentingAddAchievement) {
            AchievementDetailView(dataManager: dataManager, editingAchievement: nil, displayimages: [])
        }
        .sheet(item: $selectedAchievement) { achievement in
            AchievementDetailView(dataManager: dataManager, editingAchievement: achievement)
        }
        .alert(isPresented: $isConfirmingDeleteAchievement) {
            Alert(
                title: Text("Delete Article?"),
                message: Text("This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let achievementToDelete = achievementToDelete {
                        withAnimation {
                            dataManager.deleteAchievment(achievement: achievementToDelete) { error in
                                if let error = error {
                                    print("Error deleting achievement: \(error.localizedDescription)")
                                }
                            }
                            dataManager.allstudentachievementlistUnsorted.removeAll {$0.achievementdescription == achievementToDelete.achievementdescription && $0.date == achievementToDelete.date}
                        }
                    }
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
}

struct AchievementRowView: View {
    var achievement: studentAchievement
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(achievement.achievementtitle)
                    .font(.headline)
                Text(achievement.publisheddate)
                    .font(.subheadline)
                Text(achievement.achievementdescription)
                    .font(.subheadline)
                    .lineLimit(3)
                Text(achievement.articleauthor)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
        .background(
            Rectangle()
                .cornerRadius(9.0)
                .shadow(radius: 5, x: 0, y: 0)
                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
        )
    }
}

struct AchievementDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager: studentachievementlist
    @State private var achievementTitle = ""
    @ObservedObject var hasPermission = PermissionsCheck.shared
    @State private var achievementDescription = ""
    @State private var articleAuthor = ""
    @State private var publishedDate = ""
    @State var isApproved = false
    
    @ObservedObject var userInfo = UserInfo.shared
    
    let calendar = Calendar.current
    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedDayIndex = Calendar.current.component(.day, from: Date()) - 1
    @State private var selectedYearIndex = 0
    let year = Calendar.current.component(.year, from: Date())
    
    @State var hasAppeared = false
    
    @StateObject var imagemanager = imageManager()
    var editingAchievement: studentAchievement?
    @State var displayimages: [String] = []// make string
    @State var displayimagesdata: [UIImage] = [] // init to get this from displayimages
    @State var currentimage: UIImage?
    @State private var isCropping: Bool = false
    @State var isDisplayingAddImage = false
    
    // Define arrays for month and day options
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let days = Array(1...31)
    
    @State private var isConfirmingAddAchievement = false
    @State private var isConfirmingDeleteAchievement = false
    
    @State var screen = ScreenSize()
    
    @State var hasAppeared2 = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Article Details")) {
                    TextField("Title", text: $achievementTitle)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                    TextField("Author", text: $articleAuthor)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                
                Section(header: Text("Article Content")) {
                    TextField("Content", text: $achievementDescription)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                    HStack {
                        Text("This can be pasted from MMSD emails or from the West website, and the formatting will automatically update. It can also be enterred manually (a double space signifies a paragraph break).")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                        Spacer()
                    }
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                
                Section("Images") {
                    List {
                        ForEach(displayimagesdata, id: \.self) { image in
                            Button {} label: {
                                ZStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 200, height: 150)
                                        .aspectRatio(contentMode: .fill)
                                        .cornerRadius(10)
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Button {
                                                withAnimation {
                                                    displayimagesdata.removeAll(where: {$0 == image})
                                                }
                                            } label: {
                                                Image(systemName: "trash")
                                                    .foregroundStyle(.red)
                                                    .frame(width: 20, height: 20)
                                                    .background(Rectangle()
                                                        .frame(width: 25, height: 25)
                                                        .foregroundStyle(.white)
                                                        .opacity(0.7)
                                                        .cornerRadius(5)
                                                    )
                                                    .padding(10)
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                                .frame(width: 200, height: 150)
                            }

                        }
                    }
                    Button("Upload New Image") {
                        isDisplayingAddImage = true
                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                    
                        .sheet(isPresented: $isDisplayingAddImage) {
                            ImagePicker(selectedImage: $currentimage, isPickerShowing: $isDisplayingAddImage)
                        }
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                    .onChange(of: currentimage) { newImage in
                        if let currentimage = newImage {
                            displayimagesdata.append(currentimage)
                        }
                    }
                
                
                if displayimagesdata.isEmpty || achievementTitle == "" || articleAuthor == "" || achievementDescription == "" {
                    Text("Publish New Article")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding(10)
                        .cornerRadius(15.0)
                        .frame(width: screen.screenWidth-60)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .background(Rectangle()
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                        )
                    HStack {
                        Text("Article can only be published when all fields are filled out and at least one image has been uploaded.")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                        Spacer()
                    }
                } else {
                    Button {
                        isConfirmingAddAchievement = true
                    } label: {
                        Text("Publish New Article")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding(10)
                            .cornerRadius(15.0)
                            .frame(width: screen.screenWidth-60)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .background(Rectangle()
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                            )
                    }
                }
            }
            .navigationBarTitle(editingAchievement == nil ? "Add Article" : "Edit Article")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $isConfirmingAddAchievement) {
                Alert(
                    title: Text("Publish Article?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .default(Text("Publish")) {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM dd, yyyy"
                        guard let date = dateFormatter.date(from: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(year)") else {
                            return
                        }
                        
                        
                        var images: [String] = []
                        for image in displayimagesdata {
                            images.append(imagemanager.uploadPhoto(file: image))
                        }
                        
                        var check = false
                        if hasPermission.articleadmin {
                            check = true
                        }
                        
                        let achievementToSave = studentAchievement(
                            documentID: "NAN",
                            achievementtitle: achievementTitle,
                            achievementdescription: achievementDescription,
                            articleauthor: articleAuthor,
                            publisheddate: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(year)",
                            date: date,
                            images: images, isApproved: check, writerEmail: userInfo.email, imagedata: displayimagesdata
                        )
                        
                        var i = 0
                        for image in achievementToSave.images {
                            if achievementToSave.imagedata.count > i {
                                imagemanager.cacheImageInUserDefaults(image: achievementToSave.imagedata[i], fileName: image)
                            }
                            i = i + 1
                        }
                        
                            dataManager.createAchievement(achievement: achievementToSave) { error in
                                if let error = error {
                                    print("Error creating achievement: \(error.localizedDescription)")
                                } else {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                if let achievement = editingAchievement {
                    achievementTitle = achievement.achievementtitle
                    achievementDescription = achievement.achievementdescription
                    articleAuthor = achievement.articleauthor
                    publishedDate = achievement.publisheddate
                    isApproved = achievement.isApproved
                }
                
                for image in displayimages {
                    if !hasAppeared2 {
                        imagemanager.getImage(fileName: image) { uiimage in
                            if let uiimage = uiimage {
                                displayimagesdata.append(uiimage)
                            }
                        }
                        hasAppeared2 = true
                    }
                }
                
            }
        }
    }
}

struct SpotlightAdminView_Previews: PreviewProvider {
    static var previews: some View {
        SpotlightAdminView()
    }
}
