//
//  ClubsAdminView.swift
//  West High App
//
//  Created by August Andersen on 04/09/2023.
//

import SwiftUI

struct ClubsAdminView: View {
     
    //MARK: initializer
    @StateObject var db = clubManager()
    
    @State var isPresentingAddClub = false
    @State var isPresentingDeleteClub = false
    @State var isConfirmingAddClub = false
    @State var temptitle = ""
    @State var clubToDelete: club?
    @State var clubToAdd: club?
    
    @State var clubname = ""
    @State var clubcaptain: [String]?
    @State var clubadvisor: [String] = []
    @State var adminstring = ""
    @State var adminemails: [String] = []
    @State var clubmeetingroom = ""
    @State var clubdescription = ""
    @State var clubimage = ""
    @State var clubmembercount = ""
    @State var clubmembers: [String] = []
    
    //MARK: body
    var body: some View {
        
        VStack {
            
            Text("NOTE: You are currently editing source data. Any changes you make will be published across all devices.")
            
            Button {
                isPresentingAddClub = true
            } label: {
                Text("Add Club")
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2, x: 1, y: 1))
            }
            
            List(db.allclublist, id: \.id) {
                club in
                
                VStack(alignment: .leading) {
                    Text(club.clubname)
                        .font(.headline)
                    Text(club.clubmeetingroom)
                        .font(.subheadline)
                    Text(club.documentID)
                }.contextMenu {
                    Button("Delete", role: .destructive) {
                        temptitle = club.clubname
                        clubToDelete = club
                        isPresentingDeleteClub = true
                        db.getClubs { clubs in }
                    }
                }
                
            }
            
        }.navigationTitle("Edit Clubs")
        
            .sheet(isPresented: $isPresentingAddClub) {
                
                VStack {
                    HStack {
                        Button("Cancel") {
                            isPresentingAddClub = false
                        }.padding()
                        Spacer()
                    }
                }
                
                
                Form {
                    Section(header: Text("Sport Details")) {
                        TextField("Club Name", text: $clubname)
                        TextField("Club Admins", text: $adminstring)
                        Text("Additional information can be added after creation of sport.")
                    }
                    
                    Button ("Publish new club") {
                        adminemails = adminstring.split(whereSeparator: { ", ".contains($0) || ",".contains($0) }).map(String.init)
                        
                        clubToAdd = club(clubname: clubname, clubcaptain: clubcaptain, clubadvisor: clubadvisor, clubmeetingroom: clubmeetingroom, clubdescription: clubdescription, clubimage: clubimage, clubmembercount: clubmembercount, clubmembers: clubmembers, adminemails: adminemails, imagedata: UIImage(), documentID: "NAN", id: 0)
                        
                        if let clubToAdd = clubToAdd {
                            db.createClub(club: clubToAdd) {error in
                                if let error = error {
                                    print("Error creating club: \(error.localizedDescription)")
                                }
                            }
                        }
                        isPresentingAddClub = false
                        db.getClubs() {clubs in}
                    }
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
                                    print("Error deleting sport: \(error.localizedDescription)")
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
        ClubsAdminView()
    }
}
