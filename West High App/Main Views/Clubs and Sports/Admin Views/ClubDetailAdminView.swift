//
//  ClubDetailAdminView.swift
//  West High App
//
//  Created by August Andersen on 05/09/2023.
//

import SwiftUI

struct ClubDetailAdminView: View {
    @Environment(\.dismiss) var dismiss
    var editingclub: club
    @State var clubtoedit: club?
    @StateObject var clubmanager = clubManager.shared
    
    @ObservedObject var userInfo = UserInfo.shared
    
    @State var isConfirmingChanges = false
    @State var screen = ScreenSize()

    @State var clubname = "" //
    @State var clubcaptain: [String] = [] //
    @State var clubadvisor: [String] = [] //
    @State var clubmeetingroom = "" //
    @State var clubdescription = "" //
    @State var clubimage = ""
    @State var clubmembercount = ""
    @State var clubmembers: [String] = [] //
    @State var editoremails: [String] = []
    @State var adminemails: [String] = [] //
    @State var documentID = ""
    
    @State private var isAddingAdmin = false
    @State private var newAdminEmail = ""
    
    @State private var isAddingCaptain = false
    @State private var newCaptainName = ""
    
    @State private var isAddingAdvisor = false
    @State private var newAdvisorName = ""
    
    @State private var isAddingMember = false
    @State private var newMemberName = ""
    
    @State private var isAddingEditor = false
    @State private var newEditorEmail = ""
    
    // images
    @StateObject var imagemanager = imageManager()
    @State var displayimage: UIImage?
    @State var isDisplayingAddImage = false
    
    var body: some View {
        
        VStack {
            
            Form {
                
                Section("Description") {
                    TextField("Description", text: $clubdescription)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                
                Section("Club Meeting Room") {
                    TextField("Meeting room", text: $clubmeetingroom)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                                
                Section("Permissions") {
                    
                        DisclosureGroup("Admins") {
                            ForEach($adminemails, id: \.self) { $adminEmail in
                                HStack {
                                    Text(adminEmail)
                                        .font(.system(size: 17, weight: .regular, design: .rounded))
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
                            }.font(.system(size: 17, weight: .regular, design: .rounded))
                            .sheet(isPresented: $isAddingAdmin) {
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
                                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                            Button("Add Admin") {
                                                isAddingAdmin = false
                                                adminemails.append(newAdminEmail)
                                                newAdminEmail = ""
                                            }
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                        }.font(.system(size: 12, weight: .medium, design: .rounded))
                                    }
                                }
                            }
                        }.font(.system(size: 17, weight: .regular, design: .rounded))
                    DisclosureGroup("Editors") {
                        ForEach($editoremails, id: \.self) { $editoremail in
                            
                            HStack {
                                Text(editoremail)
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
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
                        }.font(.system(size: 17, weight: .regular, design: .rounded))
                        .sheet(isPresented: $isAddingEditor) {
                            VStack {
                                HStack {
                                    Button("Cancel") {
                                        isAddingEditor = false
                                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                                    .padding()
                                    Spacer()
                                }
                                Form {
                                    
                                    Section("New Editor Email:") {
                                        TextField("Email", text: $newEditorEmail)
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                        Button("Add Editor") {
                                            isAddingEditor = false
                                            editoremails.append(newEditorEmail)
                                            newEditorEmail = ""
                                        }.font(.system(size: 17, weight: .regular, design: .rounded))
                                    }.font(.system(size: 12, weight: .medium, design: .rounded))
                                }
                            }
                        }
                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                    Text("Admins can edit all aspects of the club.\nEditors can add upcoming events with a template.")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                

                Section("Members") {
                    
                    DisclosureGroup("Captains") {
                        ForEach($clubcaptain, id: \.self) { $captain in
                            HStack {
                                Text(captain)
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            clubcaptain.removeAll { $0 == captain }
                                        } label: {
                                            Text("Delete")
                                        }
                                    }
                            }
                        }
                        Button("Add Captain") {
                            isAddingCaptain = true
                        }.font(.system(size: 17, weight: .regular, design: .rounded))
                        .sheet(isPresented: $isAddingCaptain) {
                            VStack {
                                HStack {
                                    Button("Cancel") {
                                        isAddingCaptain = false
                                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                                    .padding()
                                    Spacer()
                                }
                                Form {
                                    Section("New Captain Name:") {
                                        TextField("Email", text: $newCaptainName)
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                        Button("Add Captain") {
                                            isAddingCaptain = false
                                            clubcaptain.append(newCaptainName)
                                            newCaptainName = ""
                                        }.font(.system(size: 17, weight: .regular, design: .rounded))
                                    }.font(.system(size: 12, weight: .medium, design: .rounded))
                                }
                            }
                        }
                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                    
                    DisclosureGroup("Advisors") {
                        ForEach($clubadvisor, id: \.self) {$advisor in
                            HStack {
                                Text(advisor)
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            clubadvisor.removeAll { $0 == advisor }
                                        } label: {
                                            Text("Delete")
                                        }
                                    }
                            }
                        }
                        
                        Button("Add Advisor") {
                            isAddingAdvisor = true
                        }.font(.system(size: 17, weight: .regular, design: .rounded))
                        .sheet(isPresented: $isAddingAdvisor) {
                            VStack {
                                HStack {
                                    Button("Cancel") {
                                        isAddingAdvisor = false
                                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                                    .padding()
                                    Spacer()
                                }
                                Form {
                                    Section("New Advisor Name:") {
                                        TextField("Name", text: $newAdvisorName)
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                        Button("Add Advisor") {
                                            isAddingAdvisor = false
                                            clubadvisor.append(newAdvisorName)
                                            newAdvisorName = ""
                                        }.font(.system(size: 17, weight: .regular, design: .rounded))
                                    }.font(.system(size: 12, weight: .medium, design: .rounded))
                                }
                            }
                        }
                        
                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                    
                    DisclosureGroup("Members") {
                        ForEach($clubmembers, id: \.self) { $player in
                            
                            HStack {
                                Text(player)
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            clubmembers.removeAll { $0 == player }
                                        } label: {
                                            Text("Delete")
                                        }
                                    }
                            }
                        }
                        Button("Add Member") {
                            isAddingMember = true
                        }.font(.system(size: 17, weight: .regular, design: .rounded))
                        .sheet(isPresented: $isAddingMember) {
                            VStack {
                                HStack {
                                    Button("Cancel") {
                                        isAddingMember = false
                                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                                    .padding()
                                    Spacer()
                                }
                                Form {
                                    
                                    Section("New Member Name:") {
                                        TextField("Name", text: $newMemberName)
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                        Button("Add Player") {
                                            isAddingMember = false
                                            clubmembers.append(newMemberName)
                                            newMemberName = ""
                                        }.font(.system(size: 17, weight: .regular, design: .rounded))
                                    }.font(.system(size: 12, weight: .medium, design: .rounded))
                                }
                            }
                        }
                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                
                
                Section("Image") {
                    if let displayimage {
                        if displayimage != UIImage() {
                            Image(uiImage: displayimage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 250, height: 200)
                                .cornerRadius(10)
                        }
                    } else {
                        if editingclub.imagedata != UIImage() {
                            Image(uiImage: editingclub.imagedata)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 250, height: 200)
                                .cornerRadius(10)
                        }
                    }
                    Button("Upload New Image") {
                        isDisplayingAddImage = true
                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                .sheet(isPresented: $isDisplayingAddImage) {
                    ImagePicker(selectedImage: $displayimage, isPickerShowing: $isDisplayingAddImage)
                        .onDisappear() {
                        }
                }
                
                Button {
                    isConfirmingChanges = true
                } label: {
                    Text("Publish Changes")
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
                
                .alert(isPresented: $isConfirmingChanges) {
                    Alert(
                        title: Text("Publish Changes?"),
                        message: Text("This action annot be undone."),
                        primaryButton: .default(Text("Publish")) {
                            
                            if let displayimage = displayimage {
                                clubimage = imagemanager.uploadPhoto(file: displayimage)
                                
                                imagemanager.deleteImage(imageFileName: editingclub.clubimage) { error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                            
                            clubtoedit = club(clubname: clubname, clubcaptain: clubcaptain, clubadvisor: clubadvisor, clubmeetingroom: clubmeetingroom, clubdescription: clubdescription, clubimage: clubimage, clubmembercount: clubmembercount, clubmembers: clubmembers, adminemails: adminemails, editoremails: editoremails, favoritedusers: editingclub.favoritedusers, imagedata: displayimage ?? UIImage(), documentID: editingclub.documentID, id: 0)
                            
                            if let clubtoedit = clubtoedit {
                                print("caching...")
                                imagemanager.cacheImageInUserDefaults(image: clubtoedit.imagedata, fileName: clubtoedit.clubimage)
                            }
                            
                            if let clubtoedit = clubtoedit {
                                print("updating...")
                                clubmanager.updateClub(data: clubtoedit)
                            }
                            
                            dismiss()
                            
                        },
                        secondaryButton: .cancel()
                    )
                }
                
            }
            
        }.navigationTitle("Edit \(editingclub.clubname)")
        
            .onAppear {
                // initializers
                clubname = editingclub.clubname
                clubcaptain = editingclub.clubcaptain ?? []
                clubadvisor = editingclub.clubadvisor
                clubmeetingroom = editingclub.clubmeetingroom
                clubdescription = editingclub.clubdescription
                clubimage = editingclub.clubimage
                clubmembercount = editingclub.clubmembercount
                clubmembers = editingclub.clubmembers
                adminemails = editingclub.adminemails
                editoremails = editingclub.editoremails
            }
        
        
    }
}

struct ClubDetailAdminView_Previews: PreviewProvider {
    static var previews: some View {
        ClubDetailAdminView(editingclub: club(clubname: "club name", clubcaptain: ["clubcaptain"], clubadvisor: ["advisory"], clubmeetingroom: "meeting room", clubdescription: "description", clubimage: "image", clubmembercount: "member count", clubmembers: ["club guy 1", "club gyal 2"], adminemails: ["augustelholm@gmail.com"], editoremails: [], favoritedusers: [], imagedata: UIImage(), documentID: "NAN", id: 0))
    }
}
