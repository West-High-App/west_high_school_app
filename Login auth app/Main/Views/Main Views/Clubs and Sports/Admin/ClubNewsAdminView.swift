import SwiftUI

struct dubclubnewscell: View{ // hello aiden
    var feat: clubNews
    @State var screen = ScreenSize()
    @ObservedObject var hasPermission = PermissionsCheck.shared
    
    var body:some View{
        VStack{
            if feat.imagedata.count > 0 {
                Image(uiImage: feat.imagedata[0])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .frame(maxWidth: screen.screenWidth - 60)
                    .clipped()
                    .cornerRadius(9)
            } else {
                Image(uiImage: UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .frame(maxWidth: screen.screenWidth - 60)
                    .clipped()
                    .cornerRadius(9)
            }
            VStack(alignment: .leading, spacing:2){
                HStack {
                    Text(feat.newsdate)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .padding(.leading, 5)
                    Spacer()
    
                }
                Text(feat.newstitle)
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .padding(.leading, 5)
                Text(feat.newsdescription)
                    .foregroundColor(.secondary)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .padding(.leading, 5)
                    .lineLimit(1)
//                    Text("Click here to read more")
//                        .foregroundColor(.blue)
//                        .lineLimit(2)
//                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        .padding(.leading, 5)

            }
        }
    }
}

struct ClubNewsAdminView: View { // hello
    @StateObject var dataManager = clubsNewslist.shared

    @ObservedObject var hasPermission = PermissionsCheck.shared
    @State private var isPresentingAddAchievement = false
    @State private var selectedAchievement: clubNews?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var tempAchievementTitle = ""
    @State var screen = ScreenSize()

    @State private var isConfirmingDeleteAchievement = false
    @State private var isConfirmingDeleteAchievementFinal = false
    @State private var isConfirmingApproveAchievement = false
    @State private var achievementToDelete: clubNews?
    
    @ObservedObject var userInfo = UserInfo.shared
    
    @State var usableType: clubNews?
    
    @State var hasAppeared = false
    
    // images
    @StateObject var imagemanager = imageManager()
    @State var originalImage = ""
    @State var displayimage: UIImage?
    @State var isDisplayingAddImage = false
    
    @State var presentingArticleSheet = false
    @State var selectedArticle = clubNews(newstitle: "", newsimage: [], newsdescription: "", newsdate: "", newsdateSwift: Date(), author: "", isApproved: false, documentID: "", imagedata: [])
    @State var selectedIndex = 0
    
    @State var selected = 1
    
    var pendingCount: Int {
            return dataManager.allclubsnewslist.filter { !$0.isApproved }.count
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
        for article in dataManager.allclubsnewslist {
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
        for article in dataManager.allclubsnewslist {
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
//            VStack(alignment: .leading) {
//                HStack {
//                    Text("You are currently editing source data. Any changes will be made public across all devices.")
//                        .padding(.horizontal, 20)
//                        .padding(.bottom, 5)
//                    Spacer()
//                }
//            }
            Button {
                isPresentingAddAchievement = true
            } label: {
                Text("Add Club Article")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .padding(10)
                    .cornerRadius(15.0)
                    .frame(width: screen.screenWidth-30)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .background(Rectangle()
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    )

            }
            
            
            if hasPermission.articleadmin || hasPermission.clubarticleadmin {
                
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
                            ForEach(dataManager.allclubsnewslist, id: \.id) { news in
                                if news.isApproved {
                                    clubnewscell(feat: news)
                                        .buttonStyle(PlainButtonStyle())
                                        .contextMenu {
                                            Button("Delete", role: .destructive) {
                                                tempAchievementTitle = news.newstitle
                                                isConfirmingDeleteAchievement = true
                                                achievementToDelete = news
                                            }
                                        }
                                }
                            }
                            if !dataManager.allclubsnewslist.map({ $0.documentID }).contains("NAN") && !dataManager.allDocsLoaded {
                                ProgressView()
                                    .onAppear {
                                        dataManager.getMoreClubNews(getPending: false)
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
                            ForEach(dataManager.allclubsnewslist, id: \.id) { news in
                                if !news.isApproved {
                                    clubnewscell(feat: news)
                                    
                                        .contextMenu {
                                            Button("Edit") {
                                                self.selectedArticle = news
                                                if let index = dataManager.allclubsnewslist.firstIndex(of: news) {
                                                    selectedIndex = index
                                                }
                                                presentingArticleSheet = true
                                                self.selectedArticle = news
                                            }
                                        }.buttonStyle(PlainButtonStyle())
                                    
                                        .sheet(isPresented: $presentingArticleSheet) {
                                            
                                            VStack  {
                                                
                                                if let usableType = usableType {
                                                    
                                                    ScrollView {
                                                        HStack {
                                                            Button("Cancel") {
                                                                presentingArticleSheet = false
                                                            }.padding()
                                                            Spacer()
                                                        }
                                                        
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
                                                                    ForEach(usableType.imagedata.indices, id: \.self) { index in
                                                                        ZStack {
                                                                            Rectangle()
                                                                                .foregroundColor(.white)
                                                                            
                                                                            VStack(spacing: 0) {
                                                                                Image(uiImage: usableType.imagedata[index])
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
                                                                presentingArticleSheet = false
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                                    
                                                                    tempAchievementTitle = selectedArticle.newstitle
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
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }.onAppear {
                                                usableType = dataManager.allclubsnewslist[selectedIndex]
                                            }
                                            
                                            
                                        }
                                        .alert(isPresented: $isConfirmingApproveAchievement) {
                                            
                                            Alert(
                                                
                                                title: Text("You Are Editing Public Data"),
                                                message: Text("Are you sure you want to approve the achievement '\(tempAchievementTitle)'? \nOnce approved, the article will be public. This action cannot be undone."),
                                                primaryButton:
                                                        .destructive(Text("Publish")) {
                                                            if let achievementToDelete = achievementToDelete {
                                                                var tempachievement = achievementToDelete
                                                                tempachievement.isApproved = true
                                                                dataManager.updateClubNews(clubNews: tempachievement) { error in
                                                                    if let error = error {
                                                                        print("Error approving club news: \(error.localizedDescription)")
                                                                    }
                                                                }
                                                            }
                                                            
                                                        },
                                                secondaryButton: .cancel()
                                                
                                            )
                                            
                                        }
                                }
                            }
                            if !dataManager.allclubsnewslist.filter({ $0.isApproved }).isEmpty && !dataManager.allPendingDocsLoaded {
                                ProgressView()
                                    .onAppear {
                                        dataManager.getMoreClubNews(getPending: true)
                                    }
                            }
                        }
                    } else {
                        Text("No pending articles.")
                            .lineLimit(1)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .padding(.leading, 5)
                    }
                }
                
            } else {
                
                VStack {
                    if pendingCount != 0 {
                        Text("Current pending articles:")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .padding(5)
                        List {
                            ForEach(dataManager.allclubsnewslist, id: \.id) { news in
                                if !news.isApproved {
                                    dubclubnewscell(feat: news)
                                }
                            }
                            if !dataManager.allclubsnewslist.filter({ $0.isApproved }).isEmpty && !dataManager.allPendingDocsLoaded {
                                ProgressView()
                                    .onAppear {
                                        dataManager.getMoreClubNews(getPending: true)
                                    }
                            }
                        }
                    } else {
                        Text("No pending articles.")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .padding(5)
                    }
                }
                
            }
        }
        .navigationBarTitle(Text("Edit Club News"))
        
        .sheet(isPresented: $isPresentingAddAchievement) {
            clubNewsRowlView(dataManager: dataManager)
        }
        .sheet(item: $selectedAchievement) { achievement in
            clubNewsRowlView(dataManager: dataManager, editingAchievement: achievement)
        }
        .alert(isPresented: $isConfirmingDeleteAchievement) {
            Alert(
                title: Text("You Are Deleting Public Data"),
                message: Text("Are you sure you want to delete the achievement '\(tempAchievementTitle)'? \nOnce deleted, the data can no longer be retrieved and will disappear from the app.\nThis action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let achievementToDelete = achievementToDelete {
                        dataManager.deleteClubNews(clubNews: achievementToDelete) { error in
                            if let error = error {
                                print("Error deleting achievement: \(error.localizedDescription)")
                            }
                        }
                    }
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
}

struct clubNewsRowView: View {
    var clubNews: clubNews
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 3) {
                Text("News title :" + clubNews.newstitle)
                    .font(.headline)
                Text("News author :" + clubNews.author)
                    .font(.subheadline)
                Text("News date :" + clubNews.newsdate)
                    .font(.subheadline)
                Text("News description :" + clubNews.newsdescription)
                    .lineLimit(3)
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

struct clubNewsRowlView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var hasPermission = PermissionsCheck.shared
    @ObservedObject var dataManager: clubsNewslist
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
    @StateObject var imagemanager = imageManager()
    @State var displayimage: UIImage?
    @State var isDisplayingAddImage = false
    
    @ObservedObject var userInfo = UserInfo.shared
    
    @State var screen = ScreenSize()
    
    @State var hasAppeared = false
    
    var editingAchievement: clubNews?
    
    @State private var isConfirmingAddAchievement = false
    @State private var isConfirmingDeleteAchievement = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Club Article Details")) {
                    TextField("Title", text: $newstitle)
                    TextField("Description", text: $newsdescription)
                    TextField("Author", text: $author)
                }
                
                Section(header: Text("Image")) {
                    
                    Image(uiImage: displayimage ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 150)
                        .cornerRadius(10)
                    Button("Upload New Image") {
                        isDisplayingAddImage = true
                    }
                }.sheet(isPresented: $isDisplayingAddImage) {
                    ImagePicker(selectedImage: $displayimage, isPickerShowing: $isDisplayingAddImage)
                }
                
                Button {
                    isConfirmingAddAchievement = true
                } label: {
                        Text("Publish New Club Article")
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
            
            .navigationBarTitle(editingAchievement == nil ? "Add Club News" : "Edit Club News")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $isConfirmingAddAchievement) {
                Alert(
                    title: Text("You Are Publishing Changes"),
                    message: Text("These changes will become public on all devices. Please make sure this information is correct:\nTitle: \(newstitle)\nDescription: \(newsdescription)\nAuthor: \(author)\nPublished Date: \(newsdate)"),
                    primaryButton: .destructive(Text("Publish Changes")) {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM d, yyyy"
                        guard let date = dateFormatter.date(from: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(year)") else {
                            return
                        }
                        
                        
                        var imagedata: [UIImage] = []
                        
                        imagedata.removeAll()
                        imagedata.append(displayimage ?? UIImage())
                        
                        if let displayimage = displayimage {
                            newsimage.removeAll()
                            newsimage.append(imagemanager.uploadPhoto(file: displayimage))
                        }
                        
                        let autoapprove = hasPermission.articleadmin || hasPermission.clubarticleadmin ? true : false
                        
                        let achievementToSave = clubNews(newstitle: newstitle, newsimage: newsimage, newsdescription: newsdescription, newsdate: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(year)", newsdateSwift: date, author: author, isApproved: autoapprove, documentID: "NAN", imagedata: imagedata)
                        
                        dataManager.createClubNews(clubNews: achievementToSave) { error in
                            if let error = error {
                                print("Error creating club news: \(error.localizedDescription)")
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
                    isApproved = achievement.isApproved
                    newsdate = achievement.newsdate
                }
            }
        }
    }
}

struct ClubsNewsAdminView_Previews: PreviewProvider {
    static var previews: some View {
        ClubNewsAdminView()
    }
}
