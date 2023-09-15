import SwiftUI

struct AnnouncementsAdminView: View {
   @StateObject var dataManager = Newslist()
   
   @State private var isEditing = false
   @State private var selectedAnnouncement: Newstab?
   @State private var isPresentingAddAnnouncement = false
   @State private var showAlert = false
   @State private var alertMessage = ""
   @State var tempAnnouncementTitle = ""
   
   @State private var isConfirmingDeleteAnnouncement = false
   @State private var isConfirmingDeleteAnnouncementFinal = false
   @State private var announcementToDelete: Newstab?
   
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
               isPresentingAddAnnouncement = true
           } label: {
               Text("Add Announcement")
                   .font(.system(size: 17, weight: .semibold, design: .rounded))
           }
           
           List(dataManager.topfive, id: \.id){announcement in
               VStack(alignment: .leading) {
                   Text(announcement.title)
                       .font(.system(size: 17, weight: .semibold, design: .rounded))
                   Text(announcement.publisheddate)
                       .font(.system(size: 17, weight: .regular, design: .rounded))
                   Text(announcement.description)
                       .font(.system(size: 17, weight: .regular, design: .rounded))
                       .lineLimit(2)
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
           .navigationBarTitle(Text("Edit Announcements"))
       }
       .sheet(isPresented: $isPresentingAddAnnouncement) {
           AnnouncementDetailView(dataManager: dataManager)
       }
       .sheet(item: $selectedAnnouncement) { announcement in
           AnnouncementDetailView(dataManager: dataManager, editingAnnouncement: announcement)
       }
       .alert(isPresented: $isConfirmingDeleteAnnouncement) {
           Alert(
               title: Text("You Are Deleting Public Data"),
               message: Text("Are you sure you want to delete the announcement '\(tempAnnouncementTitle)'? \nOnce deleted, the data can no longer be retrieved and will disappear from the app.\nThis action cannot be undone."),
               primaryButton: .destructive(Text("Delete")) {
                   if let announcementToDelete = announcementToDelete {
                       dataManager.deleteAnnouncement(announcement: announcementToDelete) { error in
                           if let error = error {
                               print("Error deleting announcement: \(error.localizedDescription)")
                           }
                       }
                   }
               },
               secondaryButton: .cancel(Text("Cancel"))
           )
       }
   }
}

struct AnnouncementRowView: View {
   var announcement: Newstab
   
   var body: some View {
       HStack{
           VStack(alignment: .leading) {
               Text(announcement.title)
                   .font(.headline)
               Text(announcement.publisheddate)
                   .font(.subheadline)
               Text(announcement.description)
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
   
   // Define arrays for month and day options
   let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
   let days = Array(1...31)
   
   @State private var isConfirmingAddAnnouncement = false
   @State private var isConfirmingDeleteAnnouncement = false
   
   var body: some View {
       NavigationView {
           Form {
               Section(header: Text("Announcement Details")) {
                   TextField("Announcement Title", text: $announcementTitle)
                   TextField("Announcement Description", text: $announcementDescription)
               }
               
               Button("Publish New Announcement") {
                   isConfirmingAddAnnouncement = true
               }
           }
           .navigationBarTitle(editingAnnouncement == nil ? "Add Announcement" : "Edit Announcement")
           .navigationBarItems(trailing: Button("Cancel") {
               presentationMode.wrappedValue.dismiss()
           })
           .alert(isPresented: $isConfirmingAddAnnouncement) {
               Alert(
                   title: Text("You Are Publishing Changes"),
                   message: Text("These changes will become public on all devices. Please make sure this information is correct:\nTitle: \(announcementTitle)\nDescription: \(announcementDescription)"),
                   primaryButton: .destructive(Text("Publish Changes")) {
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
