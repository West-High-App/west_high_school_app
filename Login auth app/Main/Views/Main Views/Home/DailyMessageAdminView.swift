//
//  DailyMessageAdminView.swift
//  West High App
//
//  Created by Aiden Lee on 8/16/23.
//
//
//import SwiftUI
//
//struct DailyMessageAdminView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct DailyMessageAdminView_Previews: PreviewProvider {
//    static var previews: some View {
//        DailyMessageAdminView()
//    }
//}

import SwiftUI

struct DailyMessageAdminView: View {
    @StateObject var dataManager = dailymessagelist()
    @State private var isEditing = false
    @State private var selectedEvent: dailymessage?
    @State private var isPresentingAddEvent = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var tempEventTitle = ""
    
    @State private var isConfirmingDeleteEvent = false
    @State private var isConfirmingDeleteEventFinal = false
    @State private var eventToDelete: dailymessage?
    
    var body: some View {
            VStack {
                Text("NOTE: You are currently editing source data. Any changes you make will be published across all devices.")
                Button {
                    isPresentingAddEvent = true
                } label: {
                    Text("Add Upcoming Event")
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 2, x:1, y:1))
                }
                
                List(dataManager.alldailymessagelist) { event in
                    MessageRowView(event: event)
                        .buttonStyle(PlainButtonStyle())
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                tempEventTitle = event.messagecontent
                                isConfirmingDeleteEvent = true
                                eventToDelete = event
                            }
                        }
                }
                .navigationBarTitle(Text("Edit Upcoming Events"))
            }
        .sheet(isPresented: $isPresentingAddEvent) {
            MessageDetailView(dataManager: dataManager)
        }
        .sheet(item: $selectedEvent) { event in
            MessageDetailView(dataManager: dataManager, editingEvent: event)
        }
        .alert(isPresented: $isConfirmingDeleteEvent) {
            Alert(
                title: Text("You Are Deleting Public Data"),
                message: Text("Are you sure you want to delete the event '\(tempEventTitle)'? \nOnce deleted, the data can no longer be retrieved and will disappear from the app.\nThis action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let eventToDelete = eventToDelete {
                        dataManager.deleteEvent(event: eventToDelete) { error in
                            if let error = error {
                                print("Error deleting event: \(error.localizedDescription)")
                            }
                        }
                    }
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
}


struct MessageRowView: View {
    var event: dailymessage
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.messagecontent)
                .font(.headline)
            Text(event.writer)
                .font(.subheadline)
        }
    }
}

struct MessageDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager: dailymessagelist
    @State private var eventcontent = ""
    @State private var eventwriter = ""
    var editingEvent: dailymessage?
    
    // Define arrays for month and day options
    @State private var isConfirmingAddEvent = false
    @State private var isConfirmingDeleteEvent = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Daily Message", text: $eventcontent)
                    TextField("Written By...", text: $eventwriter)
                }
                
                Button("Publish New Event") {
                    isConfirmingAddEvent = true
                }
            }
            .navigationBarTitle(editingEvent == nil ? "Add Event" : "Edit Event")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $isConfirmingAddEvent) {
                Alert(
                    title: Text("You Are Publishing Changes"),
                    message: Text("These changes will become public on all devices. Please make sure this information is correct:\nTitle: \(eventcontent)\nSubtitle: \(eventwriter)"),
                    primaryButton: .destructive(Text("Publish Changes")) {
                        let eventToSave = dailymessage(
                            documentID: "NAN",
                            messagecontent: eventcontent,
                            writer : eventwriter
                        )
                        dataManager.createEvent(event: eventToSave) { error in
                            if let error = error {
                                print("Error creating event: \(error.localizedDescription)")
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                if let event = editingEvent {
                    eventcontent = event.messagecontent
                    eventwriter = event.writer
                }
            }
        }
    }
}




struct DailyMessageAdminView_Preview: PreviewProvider {
    static var previews: some View {
        DailyMessageAdminView()
    }
}
