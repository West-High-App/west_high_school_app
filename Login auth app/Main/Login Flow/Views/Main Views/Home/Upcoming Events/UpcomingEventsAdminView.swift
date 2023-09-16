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
                HStack {
                    Text("Edit Upcoming Events")
                        .foregroundColor(Color.black)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .lineLimit(2)
                        .padding(.leading)
                    Spacer()
                }
                HStack {
                    Text("You are currently editing source data. Any changes will be made public across all devices.")
                        .padding(.horizontal, 20)
                        .padding(.bottom, 5)
                    Spacer()
                }
                
                Button {
                    isPresentingAddEvent = true
                } label: {
                    Text("Add Upcoming Event")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                }
                
                List(dataManager.allupcomingeventslist) { event in
                    VStack (alignment: .leading) {
                        
                        Text(event.eventname)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        Text("\(event.month) \(event.day), \(event.year)")
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                        Text(event.time)
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                        
                    }
                        .buttonStyle(PlainButtonStyle())
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                tempEventTitle = event.eventname
                                isConfirmingDeleteEvent = true
                                eventToDelete = event
                            }
                        }
                }
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
                Text("Event Date : " + "\(event.month) \(event.day), \(event.year)")
                    .font(.subheadline)
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
    
    let calendar = Calendar.current
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager: upcomingEventsDataManager
    @State private var eventName = ""
    @State private var eventTime = ""
    @State private var eventyear = ""
    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedYearIndex = 0
    @State private var selectedDayIndex = Calendar.current.component(.day, from: Date()) - 1
    var editingEvent: event?
    // Define arrays for month and day options
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let days = Array(1...31)
    @State var years: [String] = []

    let year = Calendar.current.component(.year, from: Date())
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
                    Picker("Year", selection: $selectedYearIndex) {
                        ForEach(0..<years.count, id: \.self) { index in
                            Text("\(years[index])").tag(index)
                        }
                    }

                }
                
                Button("Publish New Event") {
                    isConfirmingAddEvent = true
                }
            }
            .onAppear{
                for i in 0...2 {
                    years.append(String(Int(year) + Int(i)))
                }
                let currentYear = calendar.component(.year, from: Date())
                eventyear = String(currentYear)
            }
            .navigationBarTitle(editingEvent == nil ? "Add Event" : "Edit Event")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $isConfirmingAddEvent) {
                Alert(
                    title: Text("You Are Publishing Changes"),
                    message: Text("These changes will become public on all devices. Please make sure this information is correct:\nTitle: \(eventName)\nSubtitle: \(eventTime)\nDate: \(months[selectedMonthIndex]) \(selectedDayIndex + 1),\(years[selectedYearIndex]) "),
                    primaryButton: .destructive(Text("Publish Changes")) {
                        let eventToSave = event(
                            documentID: "NAN",
                            eventname: eventName,
                            time: eventTime,
                            month: months[selectedMonthIndex],
                            day: "\(days[selectedDayIndex])",
                            year: years[selectedYearIndex],
                            publisheddate: "\(months[selectedMonthIndex])   \(days[selectedDayIndex]),\(eventyear)"
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
