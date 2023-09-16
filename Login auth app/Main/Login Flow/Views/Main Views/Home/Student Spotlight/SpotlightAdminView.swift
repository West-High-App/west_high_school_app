import SwiftUI

struct SpotlightAdminView: View {
    @StateObject var dataManager = studentachievementlist()

    @State private var isPresentingAddAchievement = false
    @State private var selectedAchievement: studentachievement?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var tempAchievementTitle = ""
    @State var achievementlist: [studentachievement] = []

    @State private var isConfirmingDeleteAchievement = false
    @State private var isConfirmingDeleteAchievementFinal = false
    @State private var achievementToDelete: studentachievement?

    @StateObject var imagemanager = imageManager()
    @State var displayimages: [UIImage] = []
    @State var currentimage: UIImage?
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
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
            }

            List(achievementlist, id: \.id) { achievement in
                VStack(alignment: .leading) {
                    Text(achievement.achievementtitle)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                    Text(achievement.publisheddate)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                    Text(achievement.achievementdescription)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .lineLimit(2)
                }
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
        .onAppear {
            dataManager.getAchievements { list, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                else if let list = list {
                    achievementlist = list
                }
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
                            } else {
                                dataManager.allstudentachievementlist.removeAll {$0 == achievementToDelete}
                                achievementlist.removeAll {$0 == achievementToDelete}
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
    @State private var achievementDescription = ""
    @State private var articleAuthor = ""
    @State private var publishedDate = ""
    
    
    let calendar = Calendar.current
    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedDayIndex = Calendar.current.component(.day, from: Date()) - 1
    @State private var selectedYearIndex = 0
    let year = Calendar.current.component(.year, from: Date())
    
    @StateObject var imagemanager = imageManager()
    var editingAchievement: studentachievement?
    @State var displayimages: [String] = []// make string
    @State var displayimagesdata: [UIImage] = [] // init to get this from displayimages
    @State var currentimage: UIImage?
    @State var isDisplayingAddImage = false
    
    // Define arrays for month and day options
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let days = Array(1...31)
    
    @State private var isConfirmingAddAchievement = false
    @State private var isConfirmingDeleteAchievement = false
    
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
                                .frame(width: 200, height: 200)
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


                Button("Publish New Article") {
                    isConfirmingAddAchievement = true
                }
            }
            .navigationBarTitle(editingAchievement == nil ? "Add Article" : "Edit Article")
            .navigationBarItems(trailing: Button("Cancel") {
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
                        
                        let achievementToSave = studentachievement(
                            documentID: "NAN",
                            achievementtitle: achievementTitle,
                            achievementdescription: achievementDescription,
                            articleauthor: articleAuthor,
                            publisheddate: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(year)",
                            images: images, imagedata: []
                        )
                        dataManager.allstudentachievementlist.append(achievementToSave)
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
                }
               
                for image in displayimages {
                    
                    imagemanager.getImageFromStorage(fileName: image) { uiimage in
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
