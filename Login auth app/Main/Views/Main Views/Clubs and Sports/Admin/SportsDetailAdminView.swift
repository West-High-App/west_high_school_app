//
//  SportsDetailAdminView.swift
//  West High App
//
//  Created by August Andersen on 02/09/2023.
//

import SwiftUI

struct SportsDetailAdminView: View {
    var editingsport: sport
    @State var sporttoedit: sport?
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sportsmanager: sportsManager
    
    @State var isConfirmingChanges = false
    
    @State var sportname = "" //
    @State var sportcoaches: [String] = [] //
    @State var adminsstring = ""
    @State var adminemails: [String] = [] //
    @State var editoremails: [String] = []
    @State var sportsimage = ""
    @State var sportsteam = "" //
    @State var sportsroster: [String] = [] //
    @State var sportscaptains: [String] = [] //
    @State var tags: [Int] = [] //
    @State var info = ""
    @State var documentID: String = ""
    @State var favoritedusers: [String] = []
    @State var eventslink: String = ""
    
    @State private var isAddingAdmin = false
    @State private var newAdminEmail = ""
    
    
    @State private var isAddingCoach = false
    @State private var newCoachName = ""

    @State private var isAddingCaptain = false
    @State private var newCaptainName = ""

    @State private var isAddingPlayer = false
    @State private var newPlayerName = ""
    
    @State private var isAddingEditor = false
    @State private var newEditorEmail = ""
    
    @State var selectedGender = 1
    @State var selectedSeason = 1
    @State var selectedTeam = 1
    
    // images
    @StateObject var imagemanager = imageManager()
    @State var displayimage: UIImage?
    @State var isDisplayingAddImage = false
    
    var body: some View {
        VStack {
            Form {
                Section("Sport Details (Not editable)") {
                    Text("Sport Name: \(editingsport.sportname)")
                    Text("Sport Team: \(editingsport.sportsteam)")
                }
                
                Section("Sport Info") {
                    TextField("Info", text: $info)
                }
                
                Section("Sport Members") {
                    
                    DisclosureGroup("Admins") {
                        ForEach($adminemails, id: \.self) { $adminEmail in
                            HStack {
                                Text(adminEmail)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            adminemails.removeAll { $0 == adminEmail }
                                        } label: {
                                            Text("Delete")
                                        }
                                    }
                            }
                        }
                        Button("Add Admin") {
                            isAddingAdmin = true
                        }.sheet(isPresented: $isAddingAdmin) {
                            VStack {
                                HStack {
                                    Button("Cancel") {
                                        isAddingAdmin = false
                                    }.padding()
                                    Spacer()
                                }
                                Form {
                                    Section("New Admin Email:") {
                                        TextField("Email", text: $newAdminEmail)
                                        Button("Add Admin") {
                                            isAddingAdmin = false
                                            adminemails.append(newAdminEmail)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    DisclosureGroup("Editors") {
                        ForEach($editoremails, id: \.self) { $editoremail in
                            HStack {
                                Text(editoremail)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            editoremails.removeAll { $0 == editoremail }
                                        } label: {
                                            Text("Delete")
                                        }
                                    }
                            }
                        }
                        Button("Add Editor") {
                            isAddingEditor = true
                        }.sheet(isPresented: $isAddingEditor) {
                            VStack {
                                HStack {
                                    Button("Cancel") {
                                        isAddingEditor = false
                                    }.padding()
                                    Spacer()
                                }
                                Form {
                                    Section("New Editor Email:") {
                                        TextField("Email", text: $newEditorEmail)
                                        Button("Add Editor") {
                                            isAddingEditor = false
                                            editoremails.append(newEditorEmail)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    DisclosureGroup("Roster") {
                        ForEach($sportsroster, id: \.self) { $playerName in
                            HStack {
                                Text(playerName)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            sportsroster.removeAll { $0 == playerName }
                                        } label: {
                                            Text("Delete")
                                        }
                                    }
                            }
                        }
                        Button("Add Player") {
                            isAddingPlayer = true
                        }.sheet(isPresented: $isAddingPlayer) {
                            VStack {
                                HStack {
                                    Button("Cancel") {
                                        isAddingPlayer = false
                                    }.padding()
                                    Spacer()
                                }
                                Form {
                                    Section("New Player Name:") {
                                        TextField("Name", text: $newPlayerName)
                                        Button("Add Player") {
                                            isAddingPlayer = false
                                            sportsroster.append(newPlayerName)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    DisclosureGroup("Coaches") {
                        ForEach($sportcoaches, id: \.self) { $coachName in
                            HStack {
                                Text(coachName)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            sportcoaches.removeAll { $0 == coachName }
                                        } label: {
                                            Text("Delete")
                                        }
                                    }
                            }
                        }
                        Button("Add Coach") {
                            isAddingCoach = true
                        }.sheet(isPresented: $isAddingCoach) {
                            VStack {
                                HStack {
                                    Button("Cancel") {
                                        isAddingCoach = false
                                    }.padding()
                                    Spacer()
                                }
                                Form {
                                    Section("New Coach Name:") {
                                        TextField("Name", text: $newCoachName)
                                        Button("Add Coach") {
                                            isAddingCoach = false
                                            sportcoaches.append(newCoachName)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    DisclosureGroup("Captains") {
                        ForEach($sportscaptains, id: \.self) { $captainName in
                            HStack {
                                Text(captainName)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            sportscaptains.removeAll { $0 == captainName }
                                        } label: {
                                            Text("Delete")
                                        }
                                    }
                            }
                        }
                        Button("Add Captain") {
                            isAddingCaptain = true
                        }.sheet(isPresented: $isAddingCaptain) {
                            VStack {
                                HStack {
                                    Button("Cancel") {
                                        isAddingCaptain = false
                                    }.padding()
                                    Spacer()
                                }
                                Form {
                                    Section("New Captain Name:") {
                                        TextField("Name", text: $newCaptainName)
                                        Button("Add Captain") {
                                            isAddingCaptain = false
                                            sportscaptains.append(newCaptainName)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                Section("Filters") {
                    Picker(selection: $selectedGender) {
                        Text("Not Specified")
                            .tag(1)
                        Text("Boys")
                            .tag(2)
                        Text("Girls")
                            .tag(3)
                        Text("Mixed")
                            .tag(4)
                    } label: {
                        Text("Gender")
                    }
                    Picker(selection: $selectedSeason) {
                        Text("Not Specified")
                            .tag(1)
                        Text("Fall")
                            .tag(2)
                        Text("Winter")
                            .tag(3)
                        Text("Spring")
                            .tag(4)
                    } label: {
                        Text("Season")
                    }
                    Picker(selection: $selectedTeam) {
                        Text("Not Specified")
                            .tag(1)
                        Text("Varsity")
                            .tag(2)
                        Text("JV1")
                            .tag(3)
                        Text("JV2")
                            .tag(4)
                        Text("Freshman")
                            .tag(5)
                    } label: {
                        Text("Team")
                    }
                }
                
                Section("Image") {
                    if let displayimage {
                        Image(uiImage: displayimage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 200)
                            .cornerRadius(10)
                    } else {
                        Image(uiImage: editingsport.imagedata ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 200)
                            .cornerRadius(10)
                    }
                    Button("Upload New Image") {
                        isDisplayingAddImage = true
                    }
                }
                
                .sheet(isPresented: $isDisplayingAddImage) {
                    ImagePicker(selectedImage: $displayimage, isPickerShowing: $isDisplayingAddImage)
                }
                
                Button {
                    isConfirmingChanges.toggle()
                } label: {
                    Text("Publish Changes")
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 2, x:1, y:1))
                }
                
            }
    
        }
        
        .alert(isPresented: $isConfirmingChanges) {
            Alert(
                title: Text("You Are Publishing Changes"),
                message: Text("Make sure you double check your edits.\nThis action annot be undone."),
                primaryButton: .destructive(Text("Publish")) {
                    
//                    // images
//
                    if let displayimage {
                        sportsimage = imagemanager.uploadPhoto(file: displayimage)
                        
                        imagemanager.deleteImage(imageFileName: editingsport.sportsimage) { error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
//                    
                    // creating data
//                    
                    let tags: [Int] = [
                        selectedGender,
                        selectedSeason,
                        selectedTeam
                    ]
                    
                    sporttoedit = sport(sportname: sportname, sportcoaches: sportcoaches, adminemails: adminemails, editoremails: editoremails, sportsimage: sportsimage, sportsteam: sportsteam, sportsroster: sportsroster, sportscaptains: sportscaptains, tags: tags, info: info, favoritedusers: favoritedusers, eventslink: eventslink, imagedata: displayimage, documentID: documentID, sportid: "\(sportname) \(sportsteam)", id: 1)
                    
                    
                    if let sporttoedit = sporttoedit {
                        sportsmanager.updateSport(data: sporttoedit)
                    }
                    
                    dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        
        
        .navigationTitle("Edit Sport")
            .onAppear {
                // initialing properties
                sportname = editingsport.sportname
                sportcoaches = editingsport.sportcoaches
                adminemails = editingsport.adminemails
                editoremails = editingsport.editoremails
                sportsimage = editingsport.sportsimage
                sportsteam = editingsport.sportsteam
                sportsroster = editingsport.sportsroster
                sportscaptains = editingsport.sportscaptains
                tags = editingsport.tags
                info = editingsport.info
                selectedGender = tags[0]
                selectedSeason = tags[1]
                selectedTeam = tags[2]
                documentID = editingsport.documentID
                favoritedusers = editingsport.favoritedusers
                eventslink = editingsport.eventslink
            }
    }
}

struct SportsDetailAdminView_Previews: PreviewProvider {
    static var previews: some View {
        SportsDetailAdminView(editingsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], editoremails: [], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", favoritedusers: [], eventslink: "", imagedata: nil, documentID: "NAN", sportid: "SPORT ID", id: 1))
    }
}
