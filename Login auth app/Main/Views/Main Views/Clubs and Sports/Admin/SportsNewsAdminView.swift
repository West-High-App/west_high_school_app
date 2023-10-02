import SwiftUI

struct SportsNewsAdminView: View {
    @StateObject var dataManager = sportsNewslist.shared
    
    @State private var isPresentingAddAchievement = false
    @State private var selectedAchievement: sportNews?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var tempAchievementTitle = ""
    
    @State var isAdmin = false
    @State var isWriter = false
    @State var userInfo = UserInfo.shared
    @StateObject var permissionsManager = permissionsDataManager()
    
    @State var hasAppeared = false
    
    @State var selected = 1
    
    @State var usableType: sportNews?
    
    @State private var isConfirmingDeleteAchievement = false
    @State private var isConfirmingDeleteAchievementFinal = false
    @State private var achievementToDelete: sportNews?
    @State var isConfirmingApproveAchievement = false
    
    @State var selectedArticle = sportNews(newstitle: "", newsimage: [], newsdescription: "", newsdate: "", author: "", isApproved: false, imagedata: [], documentID: "")
    @State var selectedIndex = 0
    @State var presentingArticleSheet = false
    
    //images
    @StateObject var imagemanager = imageManager()
    @State var originalImage = ""
    @State var displayimage: UIImage?
    @State var isDisplayingAddImage = false
    
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
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("You are currently editing source data. Any changes will be made public across all devices.")
                        .padding(.horizontal, 20)
                        .padding(.bottom, 5)
                    Spacer()
                }
            }
            Button {
                isPresentingAddAchievement = true
            } label: {
                Text("Add Sports Article")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
            }
            
            if isAdmin {
                
                Picker("Selected", selection: $selected) {
                    Text("Edit")
                        .tag(1)
                    Text("Pending\(pendingString)")
                        .tag(2)
                }.pickerStyle(.segmented)
                    .padding(.horizontal)
                
                if selected == 1 {
                    List(dataManager.allsportsnewslist, id: \.id) { news in
                        if news.isApproved {
                            VStack (alignment: .leading){
                                Text(news.newstitle)
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                Text(news.newsdate)
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                Text(news.newsdescription)
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                    .lineLimit(2)
                            }
                            
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
                }
                
                if selected == 2 {
                    
                    List(dataManager.allsportsnewslist, id: \.id) { news in
                        if !news.isApproved {
                            VStack (alignment: .leading){
                                Text(news.newstitle)
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                Text(news.newsdate)
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                Text(news.newsdescription)
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                    .lineLimit(2)
                            }
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
                            
                            .sheet(isPresented: $presentingArticleSheet) {
                                
                                
                                VStack {
                                    
                                    if let usableType = usableType {
                                        
                                        VStack {
                                            HStack {
                                                Button("Cancel") {
                                                    presentingArticleSheet = false
                                                }.padding()
                                                Spacer()
                                            }
                                            
                                            ScrollView {
                                                
                                                VStack (alignment: .leading){
                                                    
                                                    Text(usableType.newstitle)
                                                        .padding(.leading)
                                                        .fontWeight(.semibold)
                                                    Text(usableType.author)
                                                        .padding(.leading)
                                                        .fontWeight(.medium)
                                                    Text(usableType.newsdate)
                                                        .padding(.leading)
                                                        .fontWeight(.medium)
                                                    
                                                    ForEach(usableType.imagedata, id: \.self) { image in
                                                        Image(uiImage: image)
                                                            .resizable()
                                                            .cornerRadius(10)
                                                            .padding()
                                                            .frame(width: 300,  height: 250)
                                                    }
                                                    
                                                    Text(usableType.newsdescription)
                                                        .padding()
                                                    Spacer()
                                                    
                                                }
                                                
                                                HStack {
                                                    Spacer()
                                                    Button("Delete", role: .destructive) {
                                                        presentingArticleSheet = false
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                            tempAchievementTitle = selectedArticle.newstitle
                                                            isConfirmingDeleteAchievement = true
                                                            achievementToDelete = usableType
                                                        }
                                                    }
                                                    Spacer()
                                                    Button("Approve") {
                                                        tempAchievementTitle = selectedArticle.newstitle
                                                        achievementToDelete = usableType

                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                                                            isConfirmingApproveAchievement = true

                                                        }

                                                        /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                            isConfirmingApproveAchievement = true
                                                        }*/
                                                    }
                                                    Spacer()
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                .onAppear {
                                    usableType = dataManager.allsportsnewslist[selectedIndex]
                                }
                                .alert(isPresented: $isConfirmingApproveAchievement) {
                                    Alert(
                                    
                                        title: Text("You Are Editing Public Data"),
                                        message: Text("Are you sure you want to approve the achievement '\(tempAchievementTitle)'? \nOnce approved, the article will be public. This action cannot be undone."),
                                        primaryButton: .destructive(Text("Publish")) {
                                            if let achievementToDelete = achievementToDelete {
                                                dataManager.deleteSportNews(sportNews: achievementToDelete) { error in
                                                    if let error = error {
                                                        print("Error deleting sport news: \(error.localizedDescription)")
                                                    }
                                                }
                                                var tempachievement = achievementToDelete
                                                tempachievement.isApproved = true
                                                dataManager.createSportNews(sportNews: tempachievement) { error in
                                                    if let error = error {
                                                        print("Error approving sport news: \(error.localizedDescription)")
                                                    }
                                                }
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                
                                
                            }
                            
                            .padding(.trailing)
                            .padding(.vertical,8)
                        }
                    }
                    
                }
                
            } else {
                Text("Current pending articles:")
                List(dataManager.allsportsnewslist, id: \.id) { news in
                    if !news.isApproved {
                        VStack (alignment: .leading){
                            Text(news.newstitle)
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                            Text(news.newsdate)
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                            Text(news.newsdescription)
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .lineLimit(2)
                        }
                        .padding(.trailing)
                        .padding(.vertical,8)
                        
                    }
                }
            }
        }                .navigationBarTitle(Text("Edit Sport News"))
        
        .onAppear {
            if !hasAppeared {
                permissionsManager.checkPermissions(dataType: "Article Admin", user: userInfo.email) { result in
                    self.isAdmin = result
                }
                permissionsManager.checkPermissions(dataType: "Article Writer", user: userInfo.email) { result in
                    self.isWriter = result
                }
                hasAppeared = true
            }
        }
        
        .sheet(isPresented: $isPresentingAddAchievement) {
            sportNewsRowlView(dataManager: dataManager)
        }
        .sheet(item: $selectedAchievement) { achievement in
            sportNewsRowlView(dataManager: dataManager, editingAchievement: achievement)
        }
        .alert(isPresented: $isConfirmingDeleteAchievement) {
            Alert(
                title: Text("You Are Deleting Public Data"),
                message: Text("Are you sure you want to delete the achievement '\(tempAchievementTitle)'? \nOnce deleted, the data can no longer be retrieved and will disappear from the app.\nThis action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let achievementToDelete = achievementToDelete {
                        dataManager.deleteSportNews(sportNews: achievementToDelete) { error in
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
    
    @State var isAdmin = false
    @State var isWriter = false
    @State var userInfo = UserInfo.shared
    @StateObject var permissionsManager = permissionsDataManager()
    
    @State var hasAppeared = false
    
    @State private var isConfirmingAddAchievement = false
    @State private var isConfirmingDeleteAchievement = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sports News Details")) {
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
                
                Button("Publish New Sport News") {
                    isConfirmingAddAchievement = true
                }.font(.system(size: 17, weight: .semibold, design: .rounded))

            }
            
            .onAppear {
                if !hasAppeared {
                    permissionsManager.checkPermissions(dataType: "Article Admin", user: userInfo.email) { result in
                        self.isAdmin = result
                    }
                    permissionsManager.checkPermissions(dataType: "Article Writer", user: userInfo.email) { result in
                        self.isWriter = result
                    }
                    hasAppeared = true
                }
            }
            
            .navigationBarTitle(editingAchievement == nil ? "Add Sport News" : "Edit Sport News")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $isConfirmingAddAchievement) {
                Alert(
                    title: Text("You Are Publishing Changes"),
                    message: Text("These changes will become public on all devices. Please make sure this information is correct:\nTitle: \(newstitle)\nDescription: \(newsdescription)\nAuthor: \(author)"),
                    primaryButton: .destructive(Text("Publish Changes")) {
                        
                        var imagedata: [UIImage] = []
                        
                        imagedata.removeAll()
                        imagedata.append(displayimage ?? UIImage())
                        
                        if let displayimage = displayimage {
                            newsimage.removeAll()
                            newsimage.append(imagemanager.uploadPhoto(file: displayimage))
                        }
                        
                        imagemanager.deleteImage(imageFileName: originalImage) { error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                         
                        var check = false
                        if isAdmin {
                            check = true
                        }
                        
                        let achievementToSave = sportNews(newstitle: newstitle, newsimage: newsimage, newsdescription: newsdescription, newsdate: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(year)", author: author, isApproved: check, imagedata: imagedata, documentID: "NAN")
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
