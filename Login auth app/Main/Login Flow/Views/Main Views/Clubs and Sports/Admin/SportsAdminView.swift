//
//  SportsAdminView.swift
//  West High App
//
//  Created by August Andersen on 02/09/2023.
//

import SwiftUI

struct SportsAdminView: View {
    // MARK: initializers
    @StateObject var db = sportsManager()
    
    @State var isPresentingAddSport = false
    @State var isPresetingDeleteSport = false
    @State var isConfirmingAddSport = false
    @State var temptitle = ""
    @State var sportToDelete: sport?
    @State var sportToAdd: sport?
    
    // adding event shit
    @State var sportname = ""
    @State var sportcoaches: [String] = []
    @State var adminsstring = ""
    @State var adminemails: [String] = []
    @State var sportsimage = ""
    @State var sportsteam = ""
    @State var sportsroster: [String] = []
    @State var sportscaptains: [String] = []
    @State var tags: [Int] = [1, 1, 1]
    @State var info = ""
    
    // MARK: body
    var body: some View {
        VStack {
            HStack {
                Text("You are currently editing source data. Any changes will be made public across all devices.")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 5)
                Spacer()
            }
            
            Button {
                isPresentingAddSport = true
            } label: {
                Text("Add Sport")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
            }

            List(db.allsportlist, id: \.id) { sport in
                
                VStack(alignment: .leading) {
                    Text(sport.sportname)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                    Text(sport.sportsteam)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                    Text(sport.info)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .lineLimit(1)
                }
                .contextMenu {
                    Button("Delete", role: .destructive) {
                        temptitle = sport.sportid
                        sportToDelete = sport
                        isPresetingDeleteSport = true
                        db.getSports() { sports in }
                    }
                }
                
            }
        }.navigationTitle("Edit Sports")
        
        
            .sheet(isPresented: $isPresentingAddSport) {
                
                HStack {
                    Spacer()
                    Button("Cancel") {
                        isPresentingAddSport = false
                    }
                    .padding([.horizontal, .top])
                }
                Text("Add Club")
                    .foregroundColor(Color.black)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .lineLimit(2)
                    .padding(.leading)
                
                
                Form {
                    Section(header: Text("Sport Details")) {
                        TextField("Sport Name", text: $sportname)
                        TextField("Sports Team", text: $sportsteam)
                        TextField("Sport Admins (Emails sepereated by comma)", text: $adminsstring)
                        Text("Additional information can be added after creation of sport.")
                    }
                    
                    Button("Publish New Sport") {
                        
                            adminemails = adminsstring.split(whereSeparator: { ", ".contains($0) || ",".contains($0) }).map(String.init)
                            
                            sportToAdd = sport(sportname: sportname, sportcoaches: sportcoaches, adminemails: adminemails, sportsimage: sportsimage, sportsteam: sportsteam, sportsroster: sportsroster, sportscaptains: sportscaptains, tags: tags, info: info, imagedata: UIImage(), documentID: "NAN", sportid: "\(sportname) \(sportsteam)", id: 0)
                            if let sportToAdd = sportToAdd {
                                db.createSport(sport: sportToAdd) { error in
                                    if let error = error {
                                        print("Error creating sport: \(error.localizedDescription)")
                                    }
                                }
                            } else {
                                print("No sport to add (whaaat?)")
                            }
                        isPresentingAddSport = false
                        db.getSports() { sports in }
                        
                    }.font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.red)
                }
                
                
                Spacer()
            }
        
            .alert(isPresented: $isPresetingDeleteSport) {
                Alert(
                    title: Text("You Are Deleting Public Data"),
                    message: Text("Are you sure you want to delete the sport '\(temptitle)'? \nOnce deleted, the data can no longer be retrieved and will disappear from the app.\nThis action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let sportToDelete = sportToDelete {
                            db.deleteSport(sport: sportToDelete) { error in
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

struct SportsAdminView_Previews: PreviewProvider {
    static var previews: some View {
        SportsAdminView()
    }
}
