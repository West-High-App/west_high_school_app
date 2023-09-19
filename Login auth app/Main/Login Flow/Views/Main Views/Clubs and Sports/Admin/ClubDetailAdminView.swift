//
//  ClubDetailAdminView.swift
//  West High App
//
//  Created by August Andersen on 05/09/2023.
//

import SwiftUI

struct ClubDetailAdminView: View {
    
    var editingclub: club
    @State var clubtoedit: club?
    @StateObject var clubmanager = clubManager()
    
    @State var isConfirmingChanges = false
    
    @State var clubname = "" //
    @State var clubcaptain: [String] = [] //
    @State var clubadvisor: [String] = [] //
    @State var clubmeetingroom = "" //
    @State var clubdescription = "" //
    @State var clubimage = ""
    @State var clubmembercount = ""
    @State var clubmembers: [String] = [] //
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
    
    // images
    @StateObject var imagemanager = imageManager()
    @State var originalImage = ""
    @State var displayimage: UIImage?
    @State var isDisplayingAddImage = false
    
    var body: some View {
        
        VStack {
            
            Form {
                
                Section("Description") {
                    TextField("Description", text: $clubdescription)
                }
                
                Section("Club Meeting Room") {
                    TextField("Meeting room", text: $clubmeetingroom)
                }
                                
                Section("Club Members") {
                    
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
                                            newAdminEmail = ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    DisclosureGroup("Captains") {
                        ForEach($clubcaptain, id: \.self) { $captain in
                            HStack {
                                Text(captain)
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
                                        TextField("Email", text: $newCaptainName)
                                        Button("Add Captain") {
                                            isAddingCaptain = false
                                            clubcaptain.append(newCaptainName)
                                            newCaptainName = ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    DisclosureGroup("Advisors") {
                        ForEach($clubadvisor, id: \.self) {$advisor in
                            HStack {
                                Text(advisor)
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
                        }.sheet(isPresented: $isAddingAdvisor) {
                            VStack {
                                HStack {
                                    Button("Cancel") {
                                        isAddingAdvisor = false
                                    }.padding()
                                    Spacer()
                                }
                                Form {
                                    Section("New Advisor Name:") {
                                        TextField("Name", text: $newAdvisorName)
                                        Button("Add Advisor") {
                                            isAddingAdvisor = false
                                            clubadvisor.append(newAdvisorName)
                                            newAdvisorName = ""
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    DisclosureGroup("Members") {
                        ForEach($clubmembers, id: \.self) { $player in
                            
                            HStack {
                                Text(player)
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
                        }.sheet(isPresented: $isAddingMember) {
                            VStack {
                                HStack {
                                    Button("Cancel") {
                                        isAddingMember = false
                                    }.padding()
                                    Spacer()
                                }
                                Form {
                                    
                                    Section("New Member Name:") {
                                        TextField("Name", text: $newMemberName)
                                        Button("Add Player") {
                                            isAddingMember = false
                                            clubmembers.append(newMemberName)
                                            newMemberName = ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
                Section("Image") {
                    Image(uiImage: displayimage ?? editingclub.imagedata)
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
                        .onDisappear() {
                        }
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
                
                .alert(isPresented: $isConfirmingChanges) {
                    Alert(
                        title: Text("You Are Publishing Changes"),
                        message: Text("Make sure you double check your edits.\nThis action annot be undone."),
                        primaryButton: .destructive(Text("Publish")) {
                            
                            if let displayimage = displayimage {
                                clubimage = imagemanager.uploadPhoto(file: displayimage)
                            }
                            
                            imagemanager.deleteImage(imageFileName: originalImage) { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                            
                            clubtoedit = club(clubname: clubname, clubcaptain: clubcaptain, clubadvisor: clubadvisor, clubmeetingroom: clubmeetingroom, clubdescription: clubdescription, clubimage: clubimage, clubmembercount: clubmembercount, clubmembers: clubmembers, adminemails: adminemails, favoritedusers: [], imagedata: UIImage(), documentID: editingclub.documentID, id: 0)
                            
                            if let clubtoedit = clubtoedit {
                                clubmanager.updateClub(data: clubtoedit)
                            }
                            
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
                
                //images
                
                originalImage = editingclub.clubimage
                imagemanager.getImageFromStorage(fileName: clubimage) { image in
                    displayimage = image
                }
            }
        
        
    }
}

struct ClubDetailAdminView_Previews: PreviewProvider {
    static var previews: some View {
        ClubDetailAdminView(editingclub: club(clubname: "club name", clubcaptain: ["clubcaptain"], clubadvisor: ["advisory"], clubmeetingroom: "meeting room", clubdescription: "description", clubimage: "image", clubmembercount: "member count", clubmembers: ["club guy 1", "club gyal 2"], adminemails: ["augustelholm@gmail.com"], favoritedusers: [], imagedata: UIImage(), documentID: "NAN", id: 0))
    }
}
