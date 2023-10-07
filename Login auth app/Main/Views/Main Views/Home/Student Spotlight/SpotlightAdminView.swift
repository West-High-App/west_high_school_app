import SwiftUI
struct dubachievementcell: View{
    var feat: studentachievement
    @StateObject var imagemanager = imageManager()
    @State var imagedata: [UIImage] = []
    @State var screen = ScreenSize()
    
    var body:some View{
        VStack{
            Image(uiImage: feat.imagedata.first ?? UIImage())
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
//                    Text("Click here to read more")
//                        .foregroundColor(.blue)
//                        .lineLimit(2)
//                        .font(.system(size: 18, weight: .semibold, design: .rounded))
//                        .padding(.leading, 5)

            }


        }
    }
}

struct SpotlightAdminView: View {
    @ObservedObject var dataManager = studentachievementlist.shared
    @ObservedObject var hasPermission = PermissionsCheck.shared
    @StateObject var userInfo = UserInfo.shared

    @State private var isPresentingAddAchievement = false
    @State private var selectedAchievement: studentachievement?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var tempAchievementTitle = ""

    @State private var isConfirmingDeleteAchievement = false
    @State private var isConfirmingDeleteAchievementFinal = false
    @State private var isConfirmingApproveAchievement = false
    
    @State private var achievementToDelete: studentachievement?
    
    @State var selectedIndex = 0
    @State var usableType: studentachievement?
    
    @State var screen = ScreenSize()

    @State private var presentingArticleSheet = false
    @State var selectedArticle = studentachievement(documentID: "", achievementtitle: "", achievementdescription: "", articleauthor: "", publisheddate: "", images: [], isApproved: false, imagedata: [])
    
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

    @StateObject var imagemanager = imageManager()
    @State var displayimages: [UIImage] = []
    @State var currentimage: UIImage?
    @State private var isCropping: Bool = false
    @State var isDisplayingAddImage = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Edit Spotlight Articles")
                    .foregroundColor(Color.black)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .lineLimit(2)
                    .padding(.leading)
                Spacer()
            }
            HStack {
                Text("You are currently editing source data. Any changes will be made public across all devices.")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 5)
                Spacer()
            }

            Button {
                isPresentingAddAchievement = true
            } label: {
                Text("Add Spotlight Article")
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

            if hasPermission.articleadmin {
                Picker("Selected", selection: $selected) {
                    Text("Edit")
                        .tag(1)
                    Text("Pending\(pendingString)")
                        .tag(2)
                }.pickerStyle(.segmented)
                    .padding(.horizontal)
                
                if selected == 1 {
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
                                    dataManager.getMoreAchievements(getPending: false)
                                }
                        }
                    }
                }
                if selected == 2 {
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
                                /*.contextMenu {
                                 Button("Delete", role: .destructive) {
                                 tempAchievementTitle = achievement.achievementtitle
                                 isConfirmingDeleteAchievement = true
                                 achievementToDelete = achievement
                                 }
                                 Button("Approve") {
                                 tempAchievementTitle = achievement.achievementtitle
                                 isConfirmingApproveAchievement = true
                                 achievementToDelete = achievement
                                 }
                                 }*/
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
                                                        Text(usableType.achievementtitle)
                                                            .fontWeight(.semibold)
                                                            .padding(.leading)
                                                        Text(usableType.articleauthor)
                                                            .fontWeight(.medium)
                                                            .padding(.leading)
                                                        Text(usableType.publisheddate)
                                                            .fontWeight(.medium)
                                                            .padding(.leading)
                                                        ForEach(usableType.imagedata, id: \.self) { image in
                                                            Image(uiImage: image)
                                                                .resizable()
                                                                .cornerRadius(10)
                                                                .padding()
                                                                .frame(width: 300, height: 250)
                                                        }
                                                        Text(usableType.achievementdescription)
                                                            .padding()
                                                        Spacer()
                                                    }
                                                    
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
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }.onAppear {
                                        print(selectedArticle)
                                        usableType = dataManager.allstudentachievementlist[selectedIndex]
                                    }
                                    
                                }
                                .alert(isPresented: $isConfirmingApproveAchievement) {
                                    Alert(
                                        title: Text("You Are Editing Public Data"),
                                        message: Text("Are you sure you want to approve the achievement '\(tempAchievementTitle)'? \nOnce approved, the article will be public. This action cannot be undone."),
                                        primaryButton: .destructive(Text("Publish")) {
                                            if let achievementToDelete = achievementToDelete {
                                                dataManager.deleteAchievment(achievement: achievementToDelete) { error in
                                                    if let error = error {
                                                        print("Error deleting achievement: \(error.localizedDescription)")
                                                    }
                                                }
                                                var tempachievement = achievementToDelete
                                                tempachievement.isApproved = true
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
                        if !dataManager.allstudentachievementlist.isEmpty && !dataManager.allPendingDocsLoaded {
                            ProgressView()
                                .padding()
                                .onAppear {
                                    dataManager.getMoreAchievements(getPending: true)
                                }
                        }
                    }
                }
            } else {
                
                Text("Current pending articles")
                    .padding(10)
                List {
                    ForEach(dataManager.allstudentachievementlist, id: \.id) { achievement in
                        if !achievement.isApproved {
                            //
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
                    if !dataManager.allstudentachievementlist.isEmpty && !dataManager.allPendingDocsLoaded {
                        ProgressView()
                            .padding()
                            .onAppear {
                                dataManager.getMoreAchievements(getPending: true)
                            }
                    }
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
                title: Text("You Are Deleting Public Data"),
                message: Text("Are you sure you want to delete the achievement '\(tempAchievementTitle)'? \nOnce deleted, the data can no longer be retrieved and will disappear from the app.\nThis action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let achievementToDelete = achievementToDelete {
                        dataManager.deleteAchievment(achievement: achievementToDelete) { error in
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

struct AchievementRowView: View {
    var achievement: studentachievement

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
    var editingAchievement: studentachievement?
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
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Article Details")) {
                    TextField("Article Title", text: $achievementTitle)
                    TextField("Article Description", text: $achievementDescription)
                    TextField("Article Author", text: $articleAuthor)
                }
                
                Section("Image") {
                    List {
                        ForEach(displayimagesdata, id: \.self) { image in
                            
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 150)
                                .cornerRadius(10)
                        }
                    }
                    Button("Upload New Image") {
                        isDisplayingAddImage = true
                    }
                    
                    .sheet(isPresented: $isDisplayingAddImage) {
                        ImagePicker(selectedImage: $currentimage, isPickerShowing: $isDisplayingAddImage)
                    }
                }.onChange(of: currentimage) { newImage in
                    if let currentimage = newImage {
                        displayimagesdata.append(currentimage)
                    }
                }


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
            .navigationBarTitle(editingAchievement == nil ? "Add Article" : "Edit Article")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $isConfirmingAddAchievement) {
                Alert(
                    title: Text("You Are Publishing Changes"),
                    message: Text("These changes will become public on all devices. Please make sure this information is correct:\nTitle: \(achievementTitle)\nDescription: \(achievementDescription)\nAuthor: \(articleAuthor)"),
                    primaryButton: .destructive(Text("Publish Changes")) {
                        
                        
                        var images: [String] = []
                        for image in displayimagesdata {
                            images.append(imagemanager.uploadPhoto(file: image))
                        }
                        
                        var check = false
                        if hasPermission.articleadmin {
                            check = true
                        }
                        
                        let achievementToSave = studentachievement(
                            documentID: "NAN",
                            achievementtitle: achievementTitle,
                            achievementdescription: achievementDescription,
                            articleauthor: articleAuthor,
                            publisheddate: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(year)",
                            images: images, isApproved: check, imagedata: []
                        )
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
                    
                    imagemanager.getImage(fileName: image) { uiimage in
                        if let uiimage = uiimage {
                            displayimagesdata.append(uiimage)
                        }
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
