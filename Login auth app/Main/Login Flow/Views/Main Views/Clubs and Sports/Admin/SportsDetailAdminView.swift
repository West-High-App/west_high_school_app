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
    @StateObject var sportManager = sportsManager()
    
    @State var isConfirmingChanges = false
    
    @State var sportname = "" //
    @State var sportcoaches: [String] = [] //
    @State var adminsstring = ""
    @State var adminemails: [String] = [] //
    @State var sportsimage = ""
    @State var sportsteam = "" //
    @State var sportsroster: [String] = [] //
    @State var sportscaptains: [String] = [] //
    @State var tags: [Int] = [] //
    @State var info = ""
    @State var documentID: String = ""
    
    @State private var isAddingAdmin = false
    @State private var newAdminEmail = ""
    
    
    @State private var isAddingCoach = false
    @State private var newCoachName = ""

    @State private var isAddingCaptain = false
    @State private var newCaptainName = ""

    @State private var isAddingPlayer = false
    @State private var newPlayerName = ""
    
    @State var selectedGender = 1
    @State var selectedSeason = 1
    @State var selectedTeam = 1
    
    // images
    @StateObject var imagemanager = imageManager()
    @State var originalImage = ""
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
                    TextField("Info", text: $info, axis: .vertical)
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
                        Text("Year-round")
                            .tag(5)
                    } label: {
                        Text("Season")
                    }
                    Picker(selection: $selectedTeam) {
                        Text("Not Specified")
                            .tag(1)
                        Text("Varsity")
                            .tag(2)
                        Text("JV")
                            .tag(3)
                    } label: {
                        Text("Team")
                    }
                }
                
                Section("Image") {
                    Image(uiImage: displayimage ?? editingsport.imagedata)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
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
                    
                    //images
                    
                    if let displayimage = displayimage {
                        sportsimage = imagemanager.uploadPhoto(file: displayimage)
                    }
                    
                    imagemanager.deleteImage(imageFileName: "") { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    
                    // creating data
                    
                    var temptags: [Int] = []
                    temptags.append(selectedGender)
                    temptags.append(selectedSeason)
                    temptags.append(selectedTeam)
                    tags = temptags
                    
                    sporttoedit = sport(sportname: sportname, sportcoaches: sportcoaches, adminemails: adminemails, sportsimage: sportsimage, sportsteam: sportsteam, sportsroster: sportsroster, sportscaptains: sportscaptains, tags: tags, info: info, imagedata: UIImage(), documentID: documentID, sportid: "\(sportname) \(sportsteam)", id: 1)
                    
                    
                    if let sporttoedit = sporttoedit {
                        sportManager.updateSport(data: sporttoedit)
                    }
                },
                secondaryButton: .cancel()
            )
        }
        
        
        .navigationTitle("Edit Sport")
            .onAppear {
                print("### EDITING SPPORT")
                print(editingsport)
                // initialing properties
                sportname = editingsport.sportname
                sportcoaches = editingsport.sportcoaches
                adminemails = editingsport.adminemails
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
                
                
                originalImage = editingsport.sportsimage
                imagemanager.getImageFromStorage(fileName: sportsimage) { image in
                    displayimage = image
                    print("IMNAGE")
                    print(image)
                }
            }
    }
}

struct SportsDetailAdminView_Previews: PreviewProvider {
    static var previews: some View {
        SportsDetailAdminView(editingsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", imagedata: UIImage(), documentID: "NAN", sportid: "SPORT ID", id: 1))
    }
}
