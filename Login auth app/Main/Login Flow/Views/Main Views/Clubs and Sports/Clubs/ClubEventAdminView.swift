// MARK: Aiden this is what is was tryna do
//
//
//


import SwiftUI

struct ClubsEventsAdminView: View {
    var currentclub: club
    @State var eventlist: [clubEvent] = []
    @StateObject var dataManager = clubEventManager()
    @State var temptitle = ""
    @State var isConfirmingDeleteEvent = false
    @State var isPresetingAddEvent = false
    @State var isPresentingConfirmEvent = false
    @State var eventToDelete: clubEvent?
    @State var eventToSave: clubEvent?
    
    
    @State private var eventyear = ""
    let calendar = Calendar.current
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let days = Array(1...31)
    @State var years: [String] = []
    let year = Calendar.current.component(.year, from: Date())
    @State private var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedYearIndex = 0
    @State private var selectedDayIndex = Calendar.current.component(.day, from: Date()) - 1

    
    
    
    @State var title = ""
    @State var subtitle = ""
    @State var date = ""
    
    var body: some View {
        
        VStack {
            Button {
                isPresetingAddEvent = true
            } label: {
                Text("Add Club Event")
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2, x: 1, y: 1))
            }
            List {
                ForEach(dataManager.eventDictionary["\(currentclub.clubname)"] ?? eventlist, id: \.id) { event in
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .fontWeight(.semibold)
                        Text(event.subtitle)
                        Text("\(event.month) \(event.day), \(event.year)")
                    }.contextMenu {
                        Button("Delete", role: .destructive) {
                            temptitle = event.title
                            // isConfirmingDeleteEvent = true
                            eventToDelete = event
                            if let eventToDelete = eventToDelete {
                                dataManager.deleteClubEvent(forClub: "\(currentclub.clubname)", clubEvent: eventToDelete)
                            }
                            dataManager.getClubsEvent(forClub: "\(currentclub.clubname)") { events, error in
                                if let error = error {
                                    print("Error updating events: \(error.localizedDescription)")
                                }
                                if let events = events {
                                    eventlist = events
                                }
                            }
                        }
                    }
                }
            }
        }.navigationTitle("Edit Club Events")
        .onAppear {
            dataManager.getClubsEvent(forClub: "\(currentclub.clubname)") { events, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let events = events {
                    eventlist = events
                }
            }
        }
        .alert(isPresented: $isConfirmingDeleteEvent) {
            Alert(
                title: Text("You Are Deleting Public Data"),
                message: Text("Are you sure you want to delete the event '\(temptitle)'? \nOnce deleted, the data can no longer be retrieved and will disappear from the app.\nThis action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let eventToDelete = eventToDelete {
                        dataManager.deleteClubEvent(forClub: "\(currentclub.clubname)", clubEvent: eventToDelete)
                    }
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        .sheet(isPresented: $isPresetingAddEvent) {
            VStack {
                HStack {
                    Button("Cancel") {
                        isPresetingAddEvent = false
                    }.padding()
                    Spacer()
                }
                Form {
                    Section(header: Text("Clubs Event details")) {
                        TextField("Title", text: $title)
                        TextField("Subtitle", text: $subtitle)
                        
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
                    Button("Publish new club event") {
                        eventToSave = clubEvent(
                            documentID: "NAN",
                            title: title,
                            subtitle: subtitle,
                            month: months[selectedMonthIndex],
                            day: "\(days[selectedDayIndex])",
                            year: years[selectedYearIndex],
                            publisheddate: "\(months[selectedMonthIndex])   \(days[selectedDayIndex]),\(eventyear)")
                        if let eventToSave = eventToSave {
                            print("Event to save")
                            print(eventToSave)
                            dataManager.createClubEvent(forClub: "\(currentclub.clubname)", clubEvent: eventToSave)
                            isPresetingAddEvent = false
                            
                        }
                        dataManager.getClubsEvent(forClub: "\(currentclub.clubname)") { events, error in
                            if let error = error {
                                print("Error updating events: \(error.localizedDescription)")
                            }
                            if let events = events {
                                eventlist = events
                            }
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

                
            }
            .navigationBarTitle("Edit Club Events")
            
        }
    
        
        
    }
}

struct ClubContentView_Previews: PreviewProvider {
    static var previews: some View {
        SportEventsAdminView(currentsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", imagedata: nil, documentID: "NAN", sportid: "SPORT ID",  id: 1))
    }
}
