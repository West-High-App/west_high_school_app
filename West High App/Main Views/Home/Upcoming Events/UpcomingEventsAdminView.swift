//
// UpcomingEventsAdminView
// West High
//


import SwiftUI

struct UpcomingEventsAdminView: View {
    @StateObject var dataManager = upcomingEventsDataManager.shared
    @State private var isEditing = false
    @State private var selectedEvent: event?
    @State private var isPresentingAddEvent = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var tempEventTitle = ""
    
    @State private var isConfirmingDeleteEvent = false
    @State private var eventToDelete: event?
    @State var screen = ScreenSize()
    
    var body: some View {
        ScrollView{
            LazyVStack {
                HStack {
                    Text("Edit Upcoming Events")
                        .foregroundColor(Color.black)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .lineLimit(2)
                        .padding(.leading)
                    Spacer()
                }
                HStack {
                    Text("Add a new event using the button below. Press and hold an event to delete.")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .padding(.horizontal)
                    Spacer()
                }
                
                Button {
                    isPresentingAddEvent = true
                } label: {
                    Text("Add Upcoming Event")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding(10)
                        .cornerRadius(15.0)
                        .frame(width: screen.screenWidth-30)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .background(Rectangle()
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                        )
                }.padding(.bottom, 5)
                
                if dataManager.allupcomingeventslist.isEmpty {
                    Text("No upcoming events.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .padding(5)
                    Spacer()
                }
                
                ForEach(dataManager.allupcomingeventslist) { event in
                    VStack (alignment: .leading) {
                        
                        HStack {
                            VStack {
                                Text(event.date.monthName)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.red)
                                Text("\(event.date.dateComponent(.day))")
                                    .font(.system(size: 26, weight: .regular, design: .rounded))
                                
                            }
                            .frame(width:50,height:50)
                            Divider()
                            VStack(alignment: .leading) {
                                Text(event.eventname)
                                    .lineLimit(2)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded)) // semibold
                                Text(event.isAllDay ? "All Day" : event.date.twelveHourTime)
                                    .font(.system(size: 18, weight: .regular, design: .rounded))  // regular
                                    .lineLimit(1)
                            }
                            .padding(.leading, 5)
                            Spacer()
                            
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Rectangle()
                            .padding(.horizontal, 10)
                            .cornerRadius(9.0)
                            .shadow(color: Color.black.opacity(0.25), radius: 3, x: 1, y: 1)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
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
                if !dataManager.allupcomingeventslist.isEmpty && !dataManager.allDocsLoaded {
                    ProgressView()
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Rectangle()
                            .padding(.horizontal, 10)
                            .cornerRadius(9.0)
                            .shadow(color: Color.black.opacity(0.25), radius: 3, x: 1, y: 1)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                        .onAppear {
                            dataManager.getMoreUpcomingEvents()
                        }
                }
            }
            .padding(.bottom, 15)
            .sheet(isPresented: $isPresentingAddEvent) {
                EventDetailView(dataManager: dataManager)
            }
            .sheet(item: $selectedEvent) { event in
                EventDetailView(dataManager: dataManager, editingEvent: event)
            }
            .alert(isPresented: $isConfirmingDeleteEvent) {
                Alert(
                    title: Text("Delete Event?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let eventToDelete = eventToDelete {
                            dataManager.deleteEvent(event: eventToDelete) { error in
                                if let error = error {
                                    print("Error deleting event: \(error.localizedDescription)")
                                }
                            }
                            withAnimation {
                                dataManager.allupcomingeventslistUnsorted.removeAll {$0 == eventToDelete}
                            }
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
    }
}


struct EventDetailView: View {
    
    let calendar = Calendar.current
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager: upcomingEventsDataManager
    @State private var eventName = ""
    @State private var eventTime = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var isAllDay = false
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
    
    @State var screen = ScreenSize()
    
    var monthdays: [String: Int] = ["Jan": 31, "Feb": 28, "Mar": 31, "Apr": 30, "May": 31, "Jun": 30, "Jul": 31, "Aug": 31, "Sep": 30, "Oct": 31, "Nov": 30, "Dec": 31]
    
    var isRealDate: Bool {
        if monthdays[months[selectedMonthIndex]] ?? 32 >= days[selectedDayIndex] {
            return true
        }
        if months[selectedMonthIndex] == "Feb" && days[selectedDayIndex] == 29 && ((Int(years[selectedYearIndex]) ?? 1) % 4 == 0) {
            return true
        }
        return false
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("Event Details")) {
                    TextField("Event Name", text: $eventName)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                
                Section(header: Text("Event Time")) {
                    Toggle("All Day", isOn: $isAllDay)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                    if !isAllDay {
                        DatePicker("Pick a time", selection: $eventTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                
                Section(header: Text("Event Date")) {
                    Picker("Month", selection: $selectedMonthIndex) {
                        ForEach(0..<months.count, id: \.self) { index in
                            Text(months[index]).tag(index)
                        }
                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                    
                    Picker("Day", selection: $selectedDayIndex) {
                        ForEach(0..<days.count, id: \.self) { index in
                            Text("\(days[index])").tag(index)
                        }
                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                    Picker("Year", selection: $selectedYearIndex) {
                        ForEach(0..<years.count, id: \.self) { index in
                            Text("\(years[index])").tag(index)
                        }
                    }.font(.system(size: 17, weight: .regular, design: .rounded))
                }.font(.system(size: 12, weight: .medium, design: .rounded))
                
                if !eventName.isEmpty && isRealDate {
                    Button {
                        isConfirmingAddEvent = true
                    } label: {
                        Text("Publish New Event")
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
                } else {
                    VStack(alignment: .leading) {
                        Text("Publish New Event")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding(10)
                            .cornerRadius(15.0)
                            .frame(width: screen.screenWidth-60)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .background(Rectangle()
                                .foregroundColor(.gray)
                                .cornerRadius(10)
                            )
                            Text("Event can only be published when all fields are filled out and a valid date has been selected.")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                    }
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
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $isConfirmingAddEvent) {
                Alert(
                    title: Text("Publish Event?"),
                    message: Text("Event will be made public."),
                    primaryButton: .default(Text("Publish")) {
                        createEvent()
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                if let event = editingEvent {
                    eventName = event.eventname
                    eventTime = event.date
                    
                    if let monthIndex = months.firstIndex(of: event.month) {
                        selectedMonthIndex = monthIndex
                    }
                    print("777 -- month \(selectedMonthIndex)")
                    
                    if let day = Int(event.day), let dayIndex = days.firstIndex(of: day) {
                        selectedDayIndex = dayIndex
                    }
                    
                }
            }
        }
    }
    
    func createEvent() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "h:mm a"
        
        var timeString: String {
            if isAllDay {
                return "12:00 AM"
            } else {
                return dateFormatter2.string(from: eventTime)
            }
        }
        
        print("timeString if not all day")
        print(dateFormatter2.string(from: eventTime))
        
        var date: Date? {
            if isAllDay {
                dateFormatter.date(from: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(eventyear) 12:00 PM")
            } else {
                dateFormatter.date(from: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]), \(eventyear) \(timeString)")
            }
        }
        
        guard let date else {
            isAllDay ? print("All day event") : print("not all day event")
            print("Error configuring date")
            print(date ?? "error")
            return
        }
        
        print("777 -- year saving \(selectedYearIndex)")
        print("777 -- year: \(years[selectedYearIndex])")
        
        
        let eventToSave = event(
            documentID: "NAN",
            eventname: eventName,
            time: timeString,
            month: "\(months[selectedMonthIndex])",
            day: "\(days[selectedDayIndex])",
            year: "\(years[selectedYearIndex])",
            isAllDay: isAllDay,
            publisheddate: "\(months[selectedMonthIndex]) \(days[selectedDayIndex]),\(eventyear)",
            date: date
        )
        print("777 creating event: \(eventToSave)")
        dataManager.createEvent(event: eventToSave) { error in
            if let error = error {
                print("Error creating event: \(error.localizedDescription)")
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}




struct UpcomingEventsAdminView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingEventsAdminView()
    }
}
