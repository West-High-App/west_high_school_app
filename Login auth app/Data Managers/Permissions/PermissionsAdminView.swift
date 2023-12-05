import SwiftUI

struct PermissionsAdminView: View {
    
    @ObservedObject var permissionsManager = permissionsDataManager()
    @State var originalPermissionsList: [String: [String]] = [:]
    @State var permissionsList: [String: [String]] = [:]
    @State var permissionsListKeys: [String] = []
    @State private var newPermissionValue: String = ""
    @State var screen = ScreenSize()

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
            run {
                print("Async operation completed.")
            }
        }
    }
    
}

struct EmailListView: View {
    
    let originalPermissionsList: [String: [String]]
    @Binding var permissionsList: [String: [String]]
    @Binding var permissionsListKeys: [String]
    @State private var isPresentingAddAdmin = false
    @State var screen = ScreenSize()
    @State var newAdminEmail = ""
    @StateObject var permissionsManager = permissionsDataManager()
    @State var isPresentingConfirmChanges = false
    var body: some View {
        VStack {
            Text("You are currently editing source data. Any changes will be made public across all devices.")
                .padding(.horizontal)
            List {
                ForEach(permissionsListKeys, id: \.self) { key in
                    DisclosureGroup {
                        ForEach(permissionsList[key] ?? [], id: \.self) { adminEmail in
                            HStack {
                                Text(adminEmail)
                                    .padding(0)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            permissionsList[key]?.removeAll { $0 == adminEmail }
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
                                                permissionsList[key]?.append(newAdminEmail)
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
                        message: Text("This action cannot be undone."),
                        primaryButton: .default(Text("Publish")) {
                            // update the permissions data
                            permissionsManager.updatePermissions(newpermissions: permissionsList, oldpermissions: originalPermissionsList) {}
                        },
                        secondaryButton: .cancel()
                    )
                    
                }
            }
        }
    }
}
