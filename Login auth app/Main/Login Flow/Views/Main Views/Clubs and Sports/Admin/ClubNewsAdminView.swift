import SwiftUI

struct ClubNewsAdminView: View { // hello
    @StateObject var dataManager = clubsNewslist()

    @State private var isPresentingAddAchievement = false
    @State private var selectedAchievement: clubNews?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var tempAchievementTitle = ""
    
    @State private var isConfirmingDeleteAchievement = false
    @State private var isConfirmingDeleteAchievementFinal = false
    @State private var achievementToDelete: clubNews?
    
    
    // images
    @StateObject var imagemanager = imageManager()
    @State var originalImage = ""
    @State var displayimage: UIImage?
    @State var isDisplayingAddImage = false
    
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
                Text("Add Club Article")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
            }
            
            List(dataManager.allclubsnewslist, id: \.id) { news in
                VStack(alignment: .leading) {
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
            }

            .navigationBarTitle(Text("Edit Club News"))
        }
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
    @ObservedObject var dataManager: clubsNewslist
    @State var newstitle = ""
    @State var newsimage: [String] = []
    @State var newsdescription = ""
    @State var newsdate = ""
    @State var author = ""
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
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                    Button("Upload New Image") {
                        isDisplayingAddImage = true
                    }
                }.sheet(isPresented: $isDisplayingAddImage) {
                    ImagePicker(selectedImage: $displayimage, isPickerShowing: $isDisplayingAddImage)
                }
                
                Button("Publish New Club Article") {
                    isConfirmingAddAchievement = true
                }
                .font(.system(size: 17, weight: .semibold, design: .rounded))
            }
            .navigationBarTitle(editingAchievement == nil ? "Add Club News" : "Edit Club News")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $isConfirmingAddAchievement) {
                Alert(
                    title: Text("You Are Publishing Changes"),
                    message: Text("These changes will become public on all devices. Please make sure this information is correct:\nTitle: \(newstitle)\nDescription: \(newsdescription)\nAuthor: \(author)\nPublished Date: \(newsdate)"),
                    primaryButton: .destructive(Text("Publish Changes")) {
                        
                        var imagedata: [UIImage] = []
                        
                        imagedata.removeAll()
                        imagedata.append(displayimage ?? UIImage())
                        
                        if let displayimage = displayimage {
                            newsimage.removeAll()
                            newsimage.append(imagemanager.uploadPhoto(file: displayimage))
                        }
                        
                        let achievementToSave = clubNews(newstitle: newstitle, newsimage: newsimage, newsdescription: newsdescription, newsdate: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(year)", author: author, documentID: "NAN", imagedata: imagedata)
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
