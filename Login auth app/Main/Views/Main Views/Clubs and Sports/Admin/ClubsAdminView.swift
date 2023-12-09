//
//  ClubsAdminView.swift
//  West High App
//
//  Created by August Andersen on 04/09/2023.
//

import SwiftUI

struct ClubsAdminView: View {
     
    //MARK: initializer
    @StateObject var db = clubManager.shared
    
    @State var clubslist: [club]
    
    @State var isPresentingAddClub = false
    @State var isPresentingConfirmClub = false
    @State var isPresentingDeleteClub = false
    @State var isConfirmingAddClub = false
    @State var temptitle = ""
    @State var clubToDelete: club?
    @State var clubToAdd: club?
    @State var screen = ScreenSize()
    @State var clubname = ""
    @State var clubcaptain: [String]?
    @State var clubadvisor: [String] = []
    @State var adminstring = ""
    @State var editoremails: [String] = [] // NEED TO DO THIS
    @State var adminemails: [String] = []
    @State var clubmeetingroom = ""
    @State var clubdescription = ""
    @State var clubimage = ""
    @State var clubmembercount = ""
    @State var clubmembers: [String] = []
    
    @State var selectedClub: club?
    
    //MARK: body
    var body: some View {
        
        VStack {
            
            Button {
                isPresentingAddClub = true
            } label: {
                Text("Add Club")
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
            
            List(db.allclublist, id: \.id) {
                club in
                
                VStack(alignment: .leading) {
                    Text(club.clubname)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                    Text("Room: \(club.clubmeetingroom)")
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                    Text(club.clubdescription)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .lineLimit(1)
                }.contextMenu {
                    Button("Delete", role: .destructive) {
                        temptitle = club.clubname
                        clubToDelete = club
                        isPresentingDeleteClub = true
                    }
                }
                
            }
            
        }.navigationTitle("Edit Clubs")
        
        
            .sheet(isPresented: $isPresentingAddClub) {
                ClubAdminDetailView(dataManager: db)
            }
            .sheet(item: $selectedClub) { club in
                ClubAdminDetailView(dataManager: db, editingClub: club)
            }

            .alert(isPresented: $isPresentingDeleteClub) {
                Alert(
                
                    title: Text("Delete Club"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let clubToDelete = clubToDelete {
                            db.deleteClub(data: clubToDelete) {error in
                                if let error = error {
                                    print("Error deleting club: \(error.localizedDescription)")
                                }
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
    }
}

struct ClubAdminDetailView: View {
   @Environment(\.presentationMode) var presentationMode
    let calendar = Calendar.current
   @ObservedObject var dataManager: clubManager
   @State private var clubname = ""
   @State private var adminstring = ""
   var editingClub: club?
    
    @State var isPresentingAddClub = false
    @State var isPresentingConfirmClub = false
    @State var isPresentingDeleteClub = false
    @State var temptitle = ""
    @State var clubToDelete: club?
    @State var clubToAdd: club?
    @State var screen = ScreenSize()
    @State var clubcaptain: [String]?
    @State var clubadvisor: [String] = []
    @State var editoremails: [String] = []
    @State var adminemails: [String] = []
    @State var clubmeetingroom = ""
    @State var clubdescription = ""
    @State var clubimage = ""
    @State var clubmembercount = ""
    @State var clubmembers: [String] = []
      
   @State private var isConfirmingAddClub = false
   @State private var isConfirmingDeleteClub = false
   
   var body: some View {
       NavigationView {
           Form {
               
               Section(header: Text("Club Details")) {
                   TextField("Club Name", text: $clubname)
                       .font(.system(size: 17, weight: .regular, design: .rounded))
                   TextField("Club Admin Emails (Comma Seperated)", text: $adminstring)
                       .font(.system(size: 17, weight: .regular, design: .rounded))
                   Text("Additional information can be added after creation of club.")
                       .font(.system(size: 17, weight: .regular, design: .rounded))
               }.font(.system(size: 12, weight: .medium, design: .rounded))
               
               if !clubname.isEmpty {
                   Button {
                       isConfirmingAddClub = true
                   } label: {
                       Text("Publish New Club")
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
                   Text("Publish New Club")
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
               }
               
           }
               
           .navigationBarTitle(editingClub == nil ? "Add Club" : "Edit Club")
           .navigationBarItems(leading: Button("Cancel") {
               presentationMode.wrappedValue.dismiss()
           })
           .alert(isPresented: $isConfirmingAddClub) {
               Alert(
                   title: Text("Publish Club"),
                   message: Text("This action cannot be undone."),
                   primaryButton: .default(Text("Publish")) {
                       adminemails = adminstring.split(whereSeparator: { ", ".contains($0) || ",".contains($0) }).map(String.init)
                       
                       clubToAdd = club(clubname: clubname, clubcaptain: clubcaptain, clubadvisor: clubadvisor, clubmeetingroom: clubmeetingroom, clubdescription: clubdescription, clubimage: clubimage, clubmembercount: clubmembercount, clubmembers: clubmembers, adminemails: adminemails, editoremails: editoremails, favoritedusers: [], imagedata: UIImage(), documentID: "NAN", id: 0)
                       
                       if let clubToAdd = clubToAdd {
                           dataManager.createClub(club: clubToAdd) {error in
                               if let error = error {
                                   print("Error creating club: \(error.localizedDescription)")
                               }
                           }
                       }
                       presentationMode.wrappedValue.dismiss()
                   },
                   secondaryButton: .cancel()
               )
           }
           .onAppear {
               if let club = editingClub {
                   clubname = club.clubname
               }
           }
       }
   }
}

struct ClubsAdminView_Previews: PreviewProvider {
    static var previews: some View {
        ClubsAdminView(clubslist: [])
    }
}
