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
    @State var screen = ScreenSize()
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
    @State var rosterimage: String = ""
    @State var rosterimagedata: UIImage?
    
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
        
    @State var displayimage2: UIImage?
    @State var isDisplayingAddImage2 = false
    
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
                
                Section("Permissions") {
                    
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
                
                Section("Sports Image") {
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
                
                Section("Roster Image") {
                    if let displayimage2 {
                        Image(uiImage: displayimage2)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 250)
                            .cornerRadius(10)
                            .padding(.vertical, 5)
                    } else {
                        Image(uiImage: editingsport.rosterimagedata ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 250)
                            .cornerRadius(10)
                            .padding(.vertical, 5)
                    }
                    Button("Upload New Image") {
                        isDisplayingAddImage2 = true
                    }
                }
                
                .sheet(isPresented: $isDisplayingAddImage2) {
                    ImagePicker(selectedImage: $displayimage2, isPickerShowing: $isDisplayingAddImage2)
                }
                
                Button {
                    isConfirmingChanges.toggle()
                } label: {
                    Text("Publish Changes")//hello
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
                    
                    if let displayimage2 {
                        
                        rosterimage = imagemanager.uploadPhoto(file: displayimage2)
                        
                        imagemanager.deleteImage(imageFileName: editingsport.rosterimage) { error in
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
                    
                    sporttoedit = sport(sportname: sportname, sportcoaches: sportcoaches, adminemails: adminemails, editoremails: editoremails, sportsimage: sportsimage, sportsteam: sportsteam, sportsroster: sportsroster, sportscaptains: sportscaptains, tags: tags, info: info, favoritedusers: favoritedusers, eventslink: eventslink, rosterimage: rosterimage, rosterimagedata: displayimage2, imagedata: displayimage, documentID: documentID, sportid: "\(sportname) \(sportsteam)", id: editingsport.id)
                    
                    
                    if let sporttoedit = sporttoedit {
                        sportsmanager.updateSport(data: sporttoedit)
                        let tempsportindex = sportsmanager.allsportlist.firstIndex {$0.eventslink == sporttoedit.eventslink}
                        print("TEMp SPORT INDEX")
                        print(tempsportindex as Any)
                        if let tempsportindex {
                            sportsmanager.allsportlist[tempsportindex].imagedata = displayimage
                            sportsmanager.allsportlist[tempsportindex].rosterimagedata = displayimage2
                        }
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
                rosterimage = editingsport.rosterimage
                rosterimagedata = editingsport.rosterimagedata
            }
    }
}

struct SportsDetailAdminView_Previews: PreviewProvider {
    static var previews: some View {
        SportsDetailAdminView(editingsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], editoremails: [], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", favoritedusers: [], eventslink: "", rosterimage: "", rosterimagedata: UIImage(), imagedata: nil, documentID: "NAN", sportid: "SPORT ID", id: 1))
    }
}
