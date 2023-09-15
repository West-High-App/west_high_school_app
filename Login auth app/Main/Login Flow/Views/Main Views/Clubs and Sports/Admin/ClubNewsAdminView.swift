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
            Text("This is the control panel. Click the button down below to add a new entry. All entries will be posted to the entire school, please be mindful as there are consequences for unprofessional posting. Hold down on the entry to delete it.")
                .padding()
            Button {
                isPresentingAddAchievement = true
            } label: {
                Text("Add Club Article")
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2, x: 1, y: 1))
            }
            
            List(dataManager.allclubsnewslist, id: \.id) { clubNews in
                clubNewsRowView(clubNews: clubNews)
                    .buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button("Delete", role: .destructive) {
                            tempAchievementTitle = clubNews.newstitle
                            isConfirmingDeleteAchievement = true
                            achievementToDelete = clubNews
                        }
                    }
                    .padding(.trailing)
                    .padding(.vertical,8)
                    .listRowBackground(
                        Rectangle()
                            .cornerRadius(15)
                            .foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 7)
                            .shadow(radius: 5)

                    )
                    .listRowSeparator(.hidden)
            }

            .navigationBarTitle(Text("Edit Club Articles"))
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
                    TextField("Date", text: $newsdate)
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
            }
            .navigationBarTitle(editingAchievement == nil ? "Add Sport News" : "Edit Sport News")
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
                        
                        let achievementToSave = clubNews(newstitle: newstitle, newsimage: newsimage, newsdescription: newsdescription, newsdate: newsdate, author: author, documentID: "NAN", imagedata: imagedata)
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
