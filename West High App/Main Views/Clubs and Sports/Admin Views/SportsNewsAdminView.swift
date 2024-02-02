import SwiftUI

struct SportsNewsAdminView: View {
    @StateObject var dataManager = sportsNewslist.shared
    
    @ObservedObject var hasPermission = PermissionsCheck.shared
    @State private var isPresentingAddAchievement = false
    @State private var selectedAchievement: sportNews?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var tempAchievementTitle = ""
    
    @State var userInfo = UserInfo.shared
    @State var screen = ScreenSize()
    @State var hasAppeared = false
    
    @State var selected = 1
    
    @State var usableType: sportNews?
    @State var usableTypeImageData: [UIImage] = []
    
    @State private var isConfirmingDeleteAchievement = false
    @State private var isConfirmingDeleteAchievementFinal = false
    @State private var achievementToDelete: sportNews?
    @State var isConfirmingApproveAchievement = false
    
    @State var selectedArticle = sportNews(newstitle: "", newsimage: [], newsdescription: "", newsdate: "", newsdateSwift: Date(), author: "", isApproved: false, imagedata: [], documentID: "", writerEmail: "")
    @State var selectedIndex = 0
    @State var presentingArticleSheet = false
    
    //images
    @StateObject var imagemanager = imageManager()
    @State var originalImage = ""
    @State var displayimage: UIImage?
    @State var isDisplayingAddImage = false
    @Environment(\.dismiss) var dismiss
    
    var pendingCount: Int {
        return dataManager.allsportsnewslist.filter { !$0.isApproved }.count
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
        for article in dataManager.allsportsnewslist {
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
        for article in dataManager.allsportsnewslist {
            if !flag {
                if !article.isApproved {
                    flag = true
                }
            }
        }
        
        return !flag
    }
    
    
    
    var body: some View {
        VStack {
            
            
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
                    Text("Add Sports Article")
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
                            ForEach(dataManager.allsportsnewslist, id: \.id) { news in
                                if news.isApproved {
                                    sportnewscell(feat: news)
                                    
                                        .buttonStyle(PlainButtonStyle())
                                        .contextMenu {
                                            Button("Delete", role: .destructive) {
                                                tempAchievementTitle = news.newstitle
                                                isConfirmingDeleteAchievement = true
                                                achievementToDelete = news
                                            }
                                            
                                            
                                        }
                                        .padding(.trailing)
                                        .padding(.vertical,8)
                                    
                                }
                            }
                            if !dataManager.allsportsnewslist.map({ $0.documentID }).contains("NAN") && !dataManager.allDocsLoaded {
                                ProgressView()
                                    .onAppear {
                                        dataManager.getMoreSportsNews(getPending: false)
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
                            ForEach(dataManager.allsportsnewslist, id: \.id) { news in
                                if !news.isApproved {
                                    sportnewscell(feat: news)
                                        .buttonStyle(PlainButtonStyle())
                                        .contextMenu {
                                            Button("Edit") {
                                                self.selectedArticle = news
                                                if let index = dataManager.allsportsnewslist.firstIndex(of: news) {
                                                    selectedIndex = index
                                                }
                                                presentingArticleSheet = true
                                                self.selectedArticle = news
                                            }
                                        }
                                        .onTapGesture {
                                            self.selectedArticle = news
                                            if let index = dataManager.allsportsnewslist.firstIndex(of: news) {
                                                selectedIndex = index
                                            }
                                            presentingArticleSheet = true
                                            self.selectedArticle = news
                                        }
                                    
                                        .sheet(isPresented: $presentingArticleSheet) {
                                            
                                            
                                            VStack {
                                                
                                                HStack {
                                                    Button("Cancel") {
                                                        presentingArticleSheet = false
                                                    }.padding()
                                                    Spacer()
                                                }
                                                
                                                if let usableType = usableType {
                                                    
                                                    ScrollView {
                                                        
                                                        VStack{
                                                            HStack {
                                                                Text(usableType.newstitle)
                                                                    .foregroundColor(Color.black)
                                                                    .font(.system(size: 35, weight: .bold, design: .rounded))                            .lineLimit(2)
                                                                    .minimumScaleFactor(0.3)
                                                                    .padding(.horizontal)
                                                                Spacer()
                                                            }
                                                            
                                                            HStack {
                                                                Text(usableType.author)
                                                                    .foregroundColor(Color.gray)
                                                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                                                    .lineLimit(1)
                                                                    .padding(.horizontal)
                                                                Spacer()
                                                            }
                                                            HStack {
                                                                Text(usableType.newsdate)
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
                                                                                    .padding(.bottom, 2)
                                                                                    .aspectRatio(contentMode: .fill)
                                                                                    .frame(width: screen.screenWidth - 20, height: 250)
                                                                                    .clipped()
                                                                                    .cornerRadius(30)
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                    
                                                                }
                                                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                                                                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                                                                
                                                            }.cornerRadius(30)
                                                                .frame(width: screen.screenWidth - 20, height: 250)
                                                                .shadow(color: .gray, radius: 8, x:2, y:3)
                                                                .padding(.horizontal)
                                                            Spacer() // here
                                                            LinkTextView(text: usableType.newsdescription)
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
                                                        if hasPermission.articleadmin {
                                                            HStack {
                                                                Spacer()
                                                                Button {
                                                                    presentingArticleSheet = false
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                                        tempAchievementTitle = selectedArticle.newstitle
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
                                                                    tempAchievementTitle = selectedArticle.newstitle
                                                                    achievementToDelete = usableType
                                                                    isConfirmingApproveAchievement = true
                                                                    
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
                                                    }
                                                    
                                                }
                                                
                                            }
                                            .onAppear {
                                                usableType = dataManager.allsportsnewslist[selectedIndex]
                                                usableTypeImageData.removeAll()
                                                
                                                let dispatchGroup = DispatchGroup()
                                                
                                                for images in usableType?.newsimage ?? [] {
                                                    dispatchGroup.enter()
                                                    imagemanager.getImage(fileName: images) { uiimage in
                                                        if let uiimage = uiimage {
                                                            usableTypeImageData.append(uiimage)
                                                        }
                                                        dispatchGroup.leave()
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
                                                        var tempachievement = achievementToDelete
                                                        tempachievement.isApproved = true
                                                        dataManager.updateSportNews(sportNews: tempachievement) { error in
                                                            if let error = error {
                                                                print("Error approving sport news: \(error.localizedDescription)")
                                                            } else {
                                                                dismiss()
                                                            }
                                                        }
                                                        presentingArticleSheet = false
                                                    }
                                                },
                                                secondaryButton: .cancel()
                                            )
                                        }
                                    
                                        .padding(.trailing)
                                        .padding(.vertical,8)
                                }
                            }
                            if !dataManager.allsportsnewslist.filter({ $0.isApproved }).isEmpty && !dataManager.allPendingDocsLoaded {
                                ProgressView()
                                    .onAppear {
                                        dataManager.getMoreSportsNews(getPending: true)
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
                    List {
                        ForEach(dataManager.allsportsnewslist, id: \.id) { news in
                            if !news.isApproved {
                                sportnewscell(feat: news)
                                    .padding(.trailing)
                                    .padding(.vertical,8)
                                    .contextMenu {
                                        Button("Edit") {
                                            self.selectedArticle = news
                                            if let index = dataManager.allsportsnewslist.firstIndex(of: news) {
                                                selectedIndex = index
                                            }
                                            presentingArticleSheet = true
                                            self.selectedArticle = news
                                        }
                                    }
                                    .onTapGesture {
                                        self.selectedArticle = news
                                        if let index = dataManager.allsportsnewslist.firstIndex(of: news) {
                                            selectedIndex = index
                                        }
                                        presentingArticleSheet = true
                                        self.selectedArticle = news
                                    }
                                    .sheet(isPresented: $presentingArticleSheet) {
                                        
                                        
                                        VStack {
                                            
                                            HStack {
                                                Button("Cancel") {
                                                    presentingArticleSheet = false
                                                }.padding()
                                                Spacer()
                                            }
                                            
                                            if let usableType = usableType {
                                                
                                                ScrollView {
                                                    
                                                    VStack{
                                                        HStack {
                                                            Text(usableType.newstitle)
                                                                .foregroundColor(Color.black)
                                                                .font(.system(size: 35, weight: .bold, design: .rounded))                            .lineLimit(2)
                                                                .minimumScaleFactor(0.3)
                                                                .padding(.horizontal)
                                                            Spacer()
                                                        }
                                                        
                                                        HStack {
                                                            Text(usableType.author)
                                                                .foregroundColor(Color.gray)
                                                                .font(.system(size: 26, weight: .semibold, design: .rounded))
                                                                .lineLimit(1)
                                                                .padding(.horizontal)
                                                            Spacer()
                                                        }
                                                        HStack {
                                                            Text(usableType.newsdate)
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
                                                                                .padding(.bottom, 2)
                                                                                .aspectRatio(contentMode: .fill)
                                                                                .frame(width: screen.screenWidth - 20, height: 250)
                                                                                .clipped()
                                                                                .cornerRadius(30)
                                                                        }
                                                                    }
                                                                }
                                                                
                                                                
                                                            }
                                                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                                                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                                                            
                                                        }.cornerRadius(30)
                                                            .frame(width: screen.screenWidth - 20, height: 250)
                                                            .shadow(color: .gray, radius: 8, x:2, y:3)
                                                            .padding(.horizontal)
                                                        Spacer() // here
                                                        LinkTextView(text: usableType.newsdescription)
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
                                                    if !hasPermission.articleadmin && usableType.writerEmail == userInfo.email { // TODO: add email check here
                                                        HStack {
                                                            Spacer()
                                                            Button {
                                                                presentingArticleSheet = false
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                                    tempAchievementTitle = selectedArticle.newstitle
                                                                    isConfirmingDeleteAchievement = true
                                                                    achievementToDelete = usableType
                                                                }
                                                            } label: {
                                                                Text("Remove From Pending")
                                                                    .foregroundColor(.white)
                                                                    .fontWeight(.semibold)
                                                                    .padding(10)
                                                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                                                    .cornerRadius(15.0)
                                                                    .background(Rectangle()
                                                                        .foregroundColor(.red)
                                                                        .cornerRadius(10)
                                                                    )
                                                            }
                                                            Spacer()
                                                        }.padding(.bottom)
                                                    }
                                                }
                                                
                                            }
                                            
                                        }
                                        .onAppear {
                                            usableType = dataManager.allsportsnewslist[selectedIndex]
                                            usableTypeImageData.removeAll()
                                            
                                            let dispatchGroup = DispatchGroup()
                                            
                                            for images in usableType?.newsimage ?? [] {
                                                dispatchGroup.enter()
                                                imagemanager.getImage(fileName: images) { uiimage in
                                                    if let uiimage = uiimage {
                                                        usableTypeImageData.append(uiimage)
                                                    }
                                                    dispatchGroup.leave()
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                        if !dataManager.allsportsnewslist.filter({ $0.isApproved }).isEmpty && !dataManager.allPendingDocsLoaded {
                            ProgressView()
                                .onAppear {
                                    dataManager.getMoreSportsNews(getPending: true)
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
        }                .navigationBarTitle(Text("Edit Sport News"))
        
        
            .sheet(isPresented: $isPresentingAddAchievement) {
                sportNewsRowlView(dataManager: dataManager)
            }
            .sheet(item: $selectedAchievement) { achievement in
                sportNewsRowlView(dataManager: dataManager, editingAchievement: achievement)
            }
            .alert(isPresented: $isConfirmingDeleteAchievement) {
                Alert(
                    title: Text("Delete Article?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let achievementToDelete = achievementToDelete {
                            withAnimation {
                                dataManager.deleteSportNews(sportNews: achievementToDelete) { error in
                                    if let error = error {
                                        print("Error deleting achievement: \(error.localizedDescription)")
                                    }
                                }
                            }
                            dataManager.allsportsnewslistUnsorted.removeAll {$0.newsdescription == achievementToDelete.newsdescription && $0.newsdateSwift == achievementToDelete.newsdateSwift}
                            
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
    }
}

struct sportNewsRowView: View {
    var sportNews: sportNews
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text(sportNews.newstitle)
                    .font(.headline)
                Text(sportNews.newsdescription)
                    .font(.subheadline)
                Text(sportNews.newsdate)
                    .font(.subheadline)
                Text(sportNews.author)
                    .font(.subheadline)
            }
            Spacer()
        }
        
    }
}

struct sportNewsRowlView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var hasPermission = PermissionsCheck.shared
    @ObservedObject var dataManager: sportsNewslist
    @State var newstitle = ""
    @State var newsimage: [String] = []
    @State var newsdescription = ""
    @State var newsdate = ""
    @State var author = ""
    @State var isApproved = false
    let calendar = Calendar.current
    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedDayIndex = Calendar.current.component(.day, from: Date()) - 1
    @State private var selectedYearIndex = 0
    let year = Calendar.current.component(.year, from: Date())
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let days = Array(1...31)
    // images
    @StateObject var imagemanager = imageManager()
    @State var originalImage = ""
    @State var displayimage: UIImage?
    @State var isDisplayingAddImage = false
    
    var editingAchievement: sportNews?
    
    @State var userInfo = UserInfo.shared
    
    @State var hasAppeared = false
    
    @State var screen = ScreenSize()
    
    @State private var isConfirmingAddAchievement = false
    @State private var isConfirmingDeleteAchievement = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Article Details")) {
                    TextField("Title", text: $newstitle)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                    TextField("Author", text: $author)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                
                Section(header: Text("Article Content")) {
                    TextField("Content", text: $newsdescription)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                    HStack {
                        Text("This can be pasted from the Regent Reporter. It can also be enterred manually (a double space signifies a paragraph break).")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                        Spacer()
                    }
                }
                    
                Section(header: Text("Image")) {
                    if let image = displayimage {
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
                                                displayimage = nil
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
                    Button("Upload New Image") {
                        isDisplayingAddImage = true
                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                    .sheet(isPresented: $isDisplayingAddImage) {
                        ImagePicker(selectedImage: $displayimage, isPickerShowing: $isDisplayingAddImage)
                    }
                
                if newstitle != "" && newsdescription != "" && author != "" && displayimage != nil {
                    Button {
                        isConfirmingAddAchievement = true
                    } label: {
                        Text("Publish New Sport News")
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
                } else {
                    Text("Publish New Sport News")
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
                }
                
            }
            
            
            .navigationBarTitle(editingAchievement == nil ? "Add Sport News" : "Edit Sport News")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $isConfirmingAddAchievement) {
                Alert(
                    title: Text("Publish Article?"),
                    message: Text("Article will be made public."),
                    primaryButton: .default(Text("Publish")) {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM dd, yyyy"
                        guard let date = dateFormatter.date(from: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(year)") else {
                            return
                        }
                        
                        var imagedata: [UIImage] = []
                        
                        imagedata.removeAll()
                        imagedata.append(displayimage ?? UIImage())
                        
                        if let displayimage = displayimage {
                            newsimage.removeAll()
                            newsimage.append(imagemanager.uploadPhoto(file: displayimage))
                            
                            imagemanager.deleteImage(imageFileName: originalImage) { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        
                        
                        let achievementToSave = sportNews(newstitle: newstitle, newsimage: newsimage, newsdescription: newsdescription, newsdate: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(year)", newsdateSwift: date, author: author, isApproved: hasPermission.articleadmin, imagedata: imagedata, documentID: "NAN", writerEmail: userInfo.email)
                        
                        if let fileName = newsimage.first {
                            if let image = imagedata.first {
                                imagemanager.cacheImageInUserDefaults(image: image, fileName: fileName)
                            }
                        }
                        
                        dataManager.createSportNews(sportNews: achievementToSave) { error in
                            if let error = error {
                                print("Error creating sport news: \(error.localizedDescription)")
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
                    newstitle = achievement.newstitle
                    newsdescription = achievement.newsdescription
                    author = achievement.author
                    newsdate = achievement.newsdate
                    originalImage = achievement.newsimage.first ?? ""
                }
            }
        }
    }
}

struct SportsNewsAdminView_Previews: PreviewProvider {
    static var previews: some View {
        SportsNewsAdminView()
    }
}
