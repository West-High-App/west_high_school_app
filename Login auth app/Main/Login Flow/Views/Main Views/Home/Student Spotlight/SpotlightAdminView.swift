import SwiftUI

struct SpotlightAdminView: View {
    @StateObject var dataManager = studentachievementlist()
    
    @State private var isPresentingAddAchievement = false
    @State private var selectedAchievement: studentachievement?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var tempAchievementTitle = ""
    
    @State private var isConfirmingDeleteAchievement = false
    @State private var isConfirmingDeleteAchievementFinal = false
    @State private var achievementToDelete: studentachievement?
    
    var body: some View {
        VStack {
            Text("This is the control panel. Click the button down below to add a new entry. All entries will be posted to the entire school, please be mindful as there are consequences for unprofessional posting. Hold down on the entry to delete it.")
                .padding()
            Button {
                isPresentingAddAchievement = true
            } label: {
                Text("Add Achievement")
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2, x: 1, y: 1))
            }
            
            List(dataManager.allstudentachievementlist, id: \.id) { achievement in
                AchievementRowView(achievement: achievement)
                    .buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button("Delete", role: .destructive) {
                            tempAchievementTitle = achievement.achievementtitle
                            isConfirmingDeleteAchievement = true
                            achievementToDelete = achievement
                        }
                    }
            }
            .navigationBarTitle(Text("Edit Achievements"))
        }
        .sheet(isPresented: $isPresentingAddAchievement) {
            AchievementDetailView(dataManager: dataManager)
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
        //EREN JAEGER
        HStack{
            VStack(alignment: .leading) {
                Text(achievement.achievementtitle)
                    .font(.headline)
                Text(achievement.publisheddate)
                    .font(.subheadline)
                Text(achievement.achievementdescription)
                    .font(.subheadline)
                Text(achievement.articleauthor)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
        .background(Rectangle()
            .cornerRadius(9.0)
            .shadow(radius: 5, x: 0, y: 0)
            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
    }
}

struct AchievementDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager: studentachievementlist
    @State private var achievementTitle = ""
    @State private var achievementDescription = ""
    @State private var articleAuthor = ""
    @State private var publishedDate = ""
    
    var editingAchievement: studentachievement?
    
    // Define arrays for month and day options
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let days = Array(1...31)
    
    @State private var isConfirmingAddAchievement = false
    @State private var isConfirmingDeleteAchievement = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Achievement Details")) {
                    TextField("Achievement Title", text: $achievementTitle)
                    TextField("Achievement Description", text: $achievementDescription)
                    TextField("Article Author", text: $articleAuthor)
                    TextField("Published Date", text: $publishedDate)
                }
                
                Button("Publish New Achievement") {
                    isConfirmingAddAchievement = true
                }
            }
            .navigationBarTitle(editingAchievement == nil ? "Add Achievement" : "Edit Achievement")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $isConfirmingAddAchievement) {
                Alert(
                    title: Text("You Are Publishing Changes"),
                    message: Text("These changes will become public on all devices. Please make sure this information is correct:\nTitle: \(achievementTitle)\nDescription: \(achievementDescription)\nAuthor: \(articleAuthor)\nPublished Date: \(publishedDate)"),
                    primaryButton: .destructive(Text("Publish Changes")) {
                        let achievementToSave = studentachievement(
                            documentID: "NAN",
                            achievementtitle: achievementTitle,
                            achievementdescription: achievementDescription,
                            articleauthor: articleAuthor,
                            publisheddate: publishedDate,
                            images: []
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
