import SwiftUI
import Combine

struct SportEventsAdminView: View {
    var currentsport: sport
    @State var eventlist: [sportEvent] = []
    @StateObject var dataManager = sportEventManager()
    @EnvironmentObject var sporteventmanager: sportEventManager
    @State var editingeventslist: [sportEvent] = []

    @State var temptitle = ""
    @State var isConfirmingDeleteEvent = false
    @State var isPresetingAddEvent = false
    @State var isPresentingConfirmEvent = false
    @State var eventToDelete: sportEvent?
    @State var eventToSave: sportEvent?

    
    
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
    @State var isSpecial = false
    @State var score: [Int] = []
    @State var homescore = ""
    @State var otherscore = ""
    @State var isUpdated = false
    
    var body: some View {
        
        VStack {
            Button {
                isPresetingAddEvent = true
            } label: {
                Text("Add Past Sport Event")
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2, x: 1, y: 1))
            }
            List {
                ForEach(editingeventslist, id: \.id) { event in
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
                                editingeventslist.removeAll {$0 == eventToDelete}
                                print("EVENT TO DELETE") // MARK: delete isn't working, the add new event is but it's not deleting check to see what doesn't match with firebase
                                print(eventToDelete)
                                dataManager.deleteSportEventNews(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: eventToDelete) { error in
                                    if let error = error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                }
                            }
                            dataManager.getSportsEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)") { events, error in
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
        }.navigationTitle("Edit Past Sport Events")
        .onAppear {
            dataManager.getSportsEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)") { events, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let events = events {
                    eventlist = events
                    editingeventslist = dataManager.eventDictionary["\(currentsport.sportname) \(currentsport.sportsteam)"] ?? eventlist
                    self.editingeventslist = self.editingeventslist.reversed()
                }
            }
        }
        .alert(isPresented: $isConfirmingDeleteEvent) {
            Alert(
                title: Text("You Are Deleting Public Data"),
                message: Text("Are you sure you want to delete the event '\(temptitle)'? \nOnce deleted, the data can no longer be retrieved and will disappear from the app.\nThis action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let eventToDelete = eventToDelete {
                        dataManager.deleteSportEventNews(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: eventToDelete) { error in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                            }
                        }
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
                    Section(header: Text("Sports Event Details")) {
                        TextField("Title", text: $title)
                        
                        VStack {
                            Toggle(isOn: $isSpecial) {
                                Text("Special event")
                            }
                            Text("If the sport type does not support scores (e.g. cross country) this should be toggled on.")
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                        }
                        
                        if !isSpecial {
                            Section(header: Text("Home Score")) {
                                TextField("Home score", text: $homescore)
                                    .keyboardType(.numberPad)
                            }
                            Section(header: Text("Opponent Score")) {
                                TextField("Opponent score", text: $otherscore)
                                    //.keyboardType(.numberPad)
                            }
                        } else {
                            Section(header: Text("Event information")) {
                                    TextField("Description", text: $subtitle)
                            }
                        }
                        
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
                    Button("Publish New Sport Event") {
                        eventToSave = sportEvent(
                            documentID: "NAN", 
                            arrayId: UUID().uuidString,
                            title: title,
                            subtitle: subtitle,
                            month: months[selectedMonthIndex],
                            day: "\(days[selectedDayIndex])",
                            year: years[selectedYearIndex],
                            publisheddate: "\(months[selectedMonthIndex])   \(days[selectedDayIndex]),\(eventyear)",
                            isSpecial: isSpecial,
                            score: score,
                            isUpdated: isUpdated)
                        if let eventToSave = eventToSave {
                            /*editingeventslist.append(eventToSave)
                            dataManager.createSportEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: eventToSave)
                            isPresetingAddEvent = false*/
                            print("REMOVED ADDING CLUBS FUNCTION -- PLEASE DO THROUGH FIREBASE")
                            
                        }
                        dataManager.getSportsEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)") { events, error in
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
            .navigationBarTitle("Edit Sport Events")
            
        }
    
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SportEventsAdminView(currentsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], editoremails: [], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", favoritedusers: [], eventslink: "", rosterimage: "", rosterimagedata: UIImage(), imagedata: UIImage(), documentID: "NAN", sportid: "SPORT ID",  id: UUID())).environmentObject(sportEventManager())
    }
}



struct NumericTextField: View {
    @Binding var text: String
    var displaytext: String
    
    var body: some View {
        TextField("Enter a number", text: $text)
            .keyboardType(.numberPad)
            .onReceive(Just(text)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    self.text = filtered
                }
            }
    }
}
