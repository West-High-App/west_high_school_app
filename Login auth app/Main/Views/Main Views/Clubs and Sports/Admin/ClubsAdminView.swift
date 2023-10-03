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
    
    //MARK: body
    var body: some View {
        
        VStack {
            HStack {
                Text("You are currently editing source data. Any changes will be made public across all devices.")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 5)
                Spacer()
            }
            
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
                
                HStack {
                    Spacer()
                    Button("Cancel") {
                        isPresentingAddClub = false
                    }
                    .padding([.horizontal, .top])
                }
                Text("Add Club")
                    .foregroundColor(Color.black)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .lineLimit(2)
                    .padding(.leading)
                
                Form {
                    Section(header: Text("Club Details")) {
                        TextField("Club Name", text: $clubname)
                        TextField("Club Admins", text: $adminstring)
                        Text("Additional information can be added after creation of club.")
                    }
                    
                    Button ("Publish New Club") {
                       adminemails = adminstring.split(whereSeparator: { ", ".contains($0) || ",".contains($0) }).map(String.init)
                        
                        clubToAdd = club(clubname: clubname, clubcaptain: clubcaptain, clubadvisor: clubadvisor, clubmeetingroom: clubmeetingroom, clubdescription: clubdescription, clubimage: clubimage, clubmembercount: clubmembercount, clubmembers: clubmembers, adminemails: adminemails, editoremails: editoremails, favoritedusers: [], imagedata: UIImage(), documentID: "NAN", id: 0)
                        
                        if let clubToAdd = clubToAdd {
                            db.createClub(club: clubToAdd) {error in
                                if let error = error {
                                    print("Error creating club: \(error.localizedDescription)")
                                }
                            }
                        }
                        isPresentingAddClub = false
                    }.font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.red)
                }
                Spacer()
            }

            .alert(isPresented: $isPresentingDeleteClub) {
                Alert(
                
                    title: Text("You Are Deleting Public Data"),
                    message: Text("Are you sure you want to delete the club '\(temptitle)'? \nOnce deleted, the data can no longer be retrieved and will disappear from the app.\nThis action cannot be undone."),
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

struct ClubsAdminView_Previews: PreviewProvider {
    static var previews: some View {
        ClubsAdminView(clubslist: [])
    }
}
