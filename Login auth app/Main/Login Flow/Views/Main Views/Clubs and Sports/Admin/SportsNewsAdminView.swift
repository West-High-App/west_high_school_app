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
    
    var body: some View {
        VStack {
            Text("NOTE: You are currently editing source data. Any changes you make will be published across all devices.")
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
                    TextField("Date", text: $newsdate)
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
                    message: Text("These changes will become public on all devices. Please make sure this information is correct:\nTitle: \(newstitle)\nDescription: \(newsdescription)\nAuthor: \(author)\nPublished Date: \(newsdate)"),
                    primaryButton: .destructive(Text("Publish Changes")) {
                        let achievementToSave = sportNews(newstitle: newstitle, newsimage: ["west"], newsdescription: newsdescription, newsdate: newsdate, author: author, documentID: "NAN")
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
                }
            }
        }
    }
}

struct SportsNewsAdminView_Previews: PreviewProvider {
    static var previews: some View {
        SpotlightAdminView()
    }
}
