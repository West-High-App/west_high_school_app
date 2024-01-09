import SwiftUI

struct AnnouncementsAdminView: View {
    @StateObject var dataManager = Newslist.shared
    
    @State private var isEditing = false
    @State private var selectedAnnouncement: Newstab?
    @State private var isPresentingAddAnnouncement = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var tempAnnouncementTitle = ""
    
    @State private var isConfirmingDeleteAnnouncement = false
    @State private var isConfirmingDeleteAnnouncementFinal = false
    @State private var announcementToDelete: Newstab?
    @State var screen = ScreenSize()
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Add a new announcement using the button below. Press and hold an announcement to delete.")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .padding(.horizontal)
                Spacer()
            }
            
            Button {
                isPresentingAddAnnouncement = true
            } label: {
                Text("Add Announcement")
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
            
            List(dataManager.topfive, id: \.id) { announcement in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(announcement.title)
                            .foregroundColor(.black)
                            .lineLimit(2)
                            .minimumScaleFactor(0.9)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .padding(.leading, 5)
                        Text(announcement.publisheddate)
                            .foregroundColor(.secondary)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .padding(.leading, 5)
                        Text(announcement.description)
                            .foregroundColor(.secondary)
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .padding(.leading, 5)
                            .lineLimit(1)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .contextMenu {
                    Button("Delete", role: .destructive) {
                        tempAnnouncementTitle = announcement.title
                        isConfirmingDeleteAnnouncement = true
                        announcementToDelete = announcement
                    }
                }
            }
        }
        .navigationTitle("Edit Announcements")
        .sheet(isPresented: $isPresentingAddAnnouncement) {
            AnnouncementDetailView(dataManager: dataManager)
        }
        .sheet(item: $selectedAnnouncement) { announcement in
            AnnouncementDetailView(dataManager: dataManager, editingAnnouncement: announcement)
        }
        .alert(isPresented: $isConfirmingDeleteAnnouncement) {
            Alert(
                title: Text("Delete Announcement"),
                message: Text("This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let announcementToDelete = announcementToDelete {
                        dataManager.deleteAnnouncement(announcement: announcementToDelete) { error in
                            if let error = error {
                                print("Error deleting announcement: \(error.localizedDescription)")
                            }
                        }
                        withAnimation {
                            dataManager.topfiveUnsorted.removeAll { $0 == announcementToDelete}
                        }
                    }
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
}



struct AnnouncementDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let calendar = Calendar.current
    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedDayIndex = Calendar.current.component(.day, from: Date()) - 1
    @State private var selectedYearIndex = 0
    let year = Calendar.current.component(.year, from: Date())
    @ObservedObject var dataManager: Newslist
    @State private var announcementTitle = ""
    @State private var announcementPublishedDate = ""
    @State private var announcementDescription = ""
    @State private var announcementImageName = ""
    var editingAnnouncement: Newstab?
    
    @State var screen = ScreenSize()
    
    // Define arrays for month and day options
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let days = Array(1...31)
    
    @State private var isConfirmingAddAnnouncement = false
    @State private var isConfirmingDeleteAnnouncement = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Announcement Details")) {
                    TextField("Title", text: $announcementTitle)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                    HStack {
                        Text("Date is automatically set to today.")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                        Spacer()
                    }
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                Section(header: Text("Announcement Content")) {
                    TextField("Content", text: $announcementDescription)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                    HStack {
                        Text("This can be pasted from MMSD emails or from the West website, and the formatting will automatically update. It can also be enterred manually (a double space signifies a paragraph break).")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                        Spacer()
                    }
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                
                if !announcementTitle.isEmpty && !announcementDescription.isEmpty {
                    Button {
                        isConfirmingAddAnnouncement = true
                    } label: {
                        Text("Publish New Announcement")
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
                    Text("Publish New Announcement")
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
                        Text("Announcement can only be published when all fields are filled out.")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(editingAnnouncement == nil ? "Add Announcement" : "Edit Announcement")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $isConfirmingAddAnnouncement) {
                Alert(
                    title: Text("Publish Announcement"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .default(Text("Publish")) {
                        let announcementToSave = Newstab(
                            documentID: "NAN",
                            title: announcementTitle,
                            publisheddate:"\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(year)",
                            description: announcementDescription
                        )
                        
                        dataManager.createAnnouncement(announcement: announcementToSave) { error in
                            if let error = error {
                                print("Error creating announcement: \(error.localizedDescription)")
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                if let announcement = editingAnnouncement {
                    announcementTitle = announcement.title
                    announcementPublishedDate = announcement.publisheddate
                    announcementDescription = announcement.description
                    
                    
                }
            }
        }
    }
}

struct AnnouncementsAdminView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementsAdminView()
    }
}
