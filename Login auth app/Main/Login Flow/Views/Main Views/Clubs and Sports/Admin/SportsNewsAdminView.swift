import SwiftUI

struct SportsNewsAdminView: View {
    @StateObject var dataManager = sportsNewslist()
    
    @State private var isPresentingAddAchievement = false
    @State private var selectedAchievement: sportNews?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var tempAchievementTitle = ""
    
    @State private var isConfirmingDeleteAchievement = false
    @State private var isConfirmingDeleteAchievementFinal = false
    @State private var achievementToDelete: sportNews?
    
    //images
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
                Text("Add Sport News")
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2, x: 1, y: 1))
            }
            
            List(dataManager.allsportsnewslist, id: \.id) { sportNews in
                sportNewsRowView(sportNews: sportNews)
        
                    .buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button("Delete", role: .destructive) {
                            tempAchievementTitle = sportNews.newstitle
                            isConfirmingDeleteAchievement = true
                            achievementToDelete = sportNews
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
            .navigationBarTitle(Text("Edit Sport News"))
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
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                    Button("Upload New Image") {
                        isDisplayingAddImage = true
                    }
                }.sheet(isPresented: $isDisplayingAddImage) {
                    ImagePicker(selectedImage: $displayimage, isPickerShowing: $isDisplayingAddImage)
                }
                
                Button("Publish New Sport News") {
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
                         // MARK: ain't working around here
                        
                        let achievementToSave = sportNews(newstitle: newstitle, newsimage: newsimage, newsdescription: newsdescription, newsdate: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(year)", author: author, imagedata: imagedata, documentID: "NAN")
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
