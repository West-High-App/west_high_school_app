import SwiftUI

struct UpcomingEventsAdminView: View {
    @StateObject var dataManager = upcomingEventsDataManager()
    
    @State private var isEditing = false
    @State private var selectedEvent: event?
    @State private var isPresentingAddEvent = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var tempEventTitle = ""
    
    @State private var isConfirmingDeleteEvent = false
    @State private var isConfirmingDeleteEventFinal = false
    @State private var eventToDelete: event?
    init() {
        dataManager.getUpcomingEvents()
    }
    var body: some View {
            VStack {
                Text("This is the control panel. Click the button down below to add a new entry. All entries will be posted to the entire school, please be mindful as there are consequences for unprofessional posting. Hold down on the entry to delete it.")
                    .padding()
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
                
                List(dataManager.allupcomingeventslist) { event in
                    EventRowView(event: event)
                        .buttonStyle(PlainButtonStyle())
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                tempEventTitle = event.eventname
                                isConfirmingDeleteEvent = true
                                eventToDelete = event
                            }
                        }
                }
                .navigationBarTitle(Text("Edit Upcoming Events"))
            }
        .sheet(isPresented: $isPresentingAddEvent) {
            EventDetailView(dataManager: dataManager)
        }
        .sheet(item: $selectedEvent) { event in
            EventDetailView(dataManager: dataManager, editingEvent: event)
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


struct EventRowView: View {
    var event: event
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text("Event Name : " + event.eventname)
                    .font(.headline)
                Text("Event Date : " + "\(event.month) \(event.day)")
                    .font(.subheadline)
                Text("Event Time : " + event.time)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
        .background(Rectangle()
            .cornerRadius(9.0)
            .shadow(radius: 5, x: 0, y: 0)
            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
    }
}

struct EventDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager: upcomingEventsDataManager
    @State private var eventName = ""
    @State private var eventTime = ""
    @State private var selectedMonthIndex = 0
    @State private var selectedDayIndex = 0
    var editingEvent: event?
    
    // Define arrays for month and day options
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let days = Array(1...31)
    
    @State private var isConfirmingAddEvent = false
    @State private var isConfirmingDeleteEvent = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Event Name", text: $eventName)
                    TextField("Event Time", text: $eventTime)
                    Picker("Month", selection: $selectedMonthIndex) {
                        ForEach(0..<months.count, id: \.self) { index in
                            Text(months[index]).tag(index)
                        }
                    }
                    
                    Picker("Day", selection: $selectedDayIndex) {
                        ForEach(0..<days.count, id: \.self) { index in
                            Text("\(days[index])").tag(index)
                        }
                    }
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
                    message: Text("These changes will become public on all devices. Please make sure this information is correct:\nTitle: \(eventName)\nSubtitle: \(eventTime)\nDate: \(months[selectedMonthIndex]) \(selectedDayIndex + 1)"),
                    primaryButton: .destructive(Text("Publish Changes")) {
                        let eventToSave = event(
                            documentID: "NAN",
                            eventname: eventName,
                            time: eventTime,
                            month: months[selectedMonthIndex],
                            day: "\(days[selectedDayIndex])"
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
                    eventName = event.eventname
                    eventTime = event.time
                    
                    if let monthIndex = months.firstIndex(of: event.month) {
                        selectedMonthIndex = monthIndex
                    }
                    
                    if let day = Int(event.day), let dayIndex = days.firstIndex(of: day) {
                        selectedDayIndex = dayIndex
                    }
                }
            }
        }
    }
}




struct UpcomingEventsAdminView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingEventsAdminView()
    }
}
