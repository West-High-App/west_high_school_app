//
//  PermissionsAdminView.swift
//  West High
//


import SwiftUI

struct PermissionsAdminView: View {
    
    @ObservedObject var permissionsManager = permissionsDataManager()
    @State var originalPermissionsList: [String: [String]] = [:]
    @State var permissionsList: [String: [String]] = [:]
    @State var permissionsListKeys: [String] = []
    
    func run(completion: @escaping () -> Void) {
        permissionsManager.checkPermissions(dataType: "", user: "") { _ in
            self.permissionsList = permissionsManager.permissions
            self.permissionsListKeys = Array(self.permissionsList.keys)
            self.originalPermissionsList = permissionsManager.permissions
            completion()
        }
    }
        
    var body: some View {
        VStack {
            EmailListView(originalPermissionsList: originalPermissionsList, permissionsList: $permissionsList, permissionsListKeys: $permissionsListKeys)
            
            .navigationTitle("Admin Permissions")
        }
        .onAppear {
            withAnimation { run {} }
        }
    }
}

struct EmailListView: View {
    @Environment(\.dismiss) var dismiss
    let originalPermissionsList: [String: [String]]
    @Binding var permissionsList: [String: [String]]
    @Binding var permissionsListKeys: [String]
    @State private var isPresentingAddAdmin = false
    @State var screen = ScreenSize()
    @State var newAdminEmail = ""
    @StateObject var permissionsManager = permissionsDataManager()
    @State var isPresentingConfirmChanges = false
    
    let customPermissionOrder: [String] = ["General Admin", "Announcements Admin", "Upcoming Events Admin", "Article Writer", "Article Admin", "Clubs Admin", "Sports Admin"]
    
    var sortedKeys: [String] {
            permissionsList.keys.sorted { key1, key2 in
                guard let index1 = customPermissionOrder.firstIndex(of: key1),
                      let index2 = customPermissionOrder.firstIndex(of: key2) else {
                    return false // fallback to default order if not found in customOrder
                }
                return index1 < index2
            }
        }
    
    var body: some View {
        VStack {
            HStack {
                Text("Edit the users who have certain permissions within the app. Make sure to publish changes after revisions.")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                Spacer()
            }.padding(.horizontal)
            List {
                ForEach(sortedKeys, id: \.self) { key in
                    DisclosureGroup {
                        ForEach(permissionsList[key] ?? [], id: \.self) { adminEmail in
                            HStack {
                                Text(adminEmail)
                                    .padding(0)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                permissionsList[key]?.removeAll { $0 == adminEmail }
                                            }
                                        } label: {
                                            Text("Delete")
                                                .foregroundColor(.red)
                                        }
                                    }
                            }
                        }
                        Button("Add Admin") {
                            isPresentingAddAdmin = true }.foregroundColor(.blue)
                            .sheet(isPresented: $isPresentingAddAdmin) {
                                
                                VStack {
                                    
                                    HStack {
                                        
                                        Button("Cancel") {
                                            isPresentingAddAdmin = false
                                        }.padding()
                                        Spacer()
                                        
                                    }
                                    
                                    Form {
                                        
                                        Section("New Admin Email:") {
                                            
                                            TextField("Email", text: $newAdminEmail)
                                            Button("Add Admin to \(key)") {
                                                isPresentingAddAdmin = false
                                                withAnimation {
                                                    permissionsList[key]?.append(newAdminEmail)
                                                }
                                                newAdminEmail = ""
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                        
                        
                    } label: {
                        
                        Text(key)
                            .fontWeight(.semibold)
                            .padding(.vertical)
                        
                    }
                    
                }
                Button("Publish Changes", role: .destructive) {
                    
                    isPresentingConfirmChanges = true
                    
                }.foregroundColor(.white)
                    .fontWeight(.semibold)
                    .padding(10)
                    .cornerRadius(15.0)
                    .frame(width: screen.screenWidth-60)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .background(Rectangle()
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    )
                .alert(isPresented: $isPresentingConfirmChanges) {
                    
                    Alert(
                        title: Text("Change Permissions?"),
                        message: Text("Changes will be updated soon."),
                        primaryButton: .default(Text("Publish")) {
                            // update the permissions data
                                permissionsManager.updatePermissions(newpermissions: permissionsList, oldpermissions: originalPermissionsList) {
                            }
                            dismiss()

                        },
                        secondaryButton: .cancel()
                    )
                    
                }
            }
        }
    }
}
