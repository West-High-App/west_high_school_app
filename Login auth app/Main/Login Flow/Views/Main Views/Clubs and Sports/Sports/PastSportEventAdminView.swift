import SwiftUI

struct PastSportEventsAdminView: View {
    var currentsport: sport
    @State var eventlist: [sportEvent] = []
    @StateObject var dataManager = sportEventManager()
    @EnvironmentObject var sporteventmanager: sportEventManager
    @State var editingeventslist: [sportEvent] = []

    @State var temptitle = ""
    @State var isPresentingEditEvent = false
    @State var isPresentingConfirmEvent = false
    @State var eventToDelete: sportEvent?
    @State var eventToSave: sportEvent?

    
    
    @State private var eventyear = ""
    let calendar = Calendar.current
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let days = Array(1...31)
    @State var years: [String] = []
    @State private var selectedYearIndex = 0
    @State private var selectedDayIndex = Calendar.current.component(.day, from: Date()) - 1
    @State var editingevent = sportEvent(documentID: "", title: "", subtitle: "", month: "", day: "", year: "", publisheddate: "", isSpecial: false, score: [], isUpdated: false)
    
    @State var title = ""
    @State var subtitle = ""
    @State var month = ""
    @State var year = ""
    @State var day = ""
    @State var isSpecial = false
    @State var score: [Int] = []
    @State var isUpdated = false
    @State var homescore = ""
    @State var otherscore = ""
    @State var documentID = ""
    
    var body: some View {
        
        VStack {
            List {
                ForEach(editingeventslist, id: \.id) { event in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(event.title)
                                .fontWeight(.semibold)
                            Text(event.subtitle)
                            Text("\(event.month) \(event.day), \(event.year)")
                        }
                    }.contextMenu {
                        Button("Edit") {
                            editingevent = event
                            isPresentingEditEvent = true
                        }.foregroundColor(.blue)
                    }
                    .onTapGesture {
                        editingevent = event
                        isPresentingEditEvent = true
                    }
                }
            }
        }.navigationTitle("Edit Past Events")
        .onAppear {
            dataManager.getSportsEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)") { events, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let events = events {
                    eventlist = events
                    editingeventslist = dataManager.pastEventDictionary["\(currentsport.sportname) \(currentsport.sportsteam)"] ?? eventlist
                }
            }
            
            documentID = currentsport.documentID
            
        }

        .sheet(isPresented: $isPresentingEditEvent) {
            VStack {
                HStack {
                    Button("Cancel") {
                        isPresentingEditEvent = false
                    }.padding()
                    Spacer()
                }
                Form {
                    HStack {
                        VStack {
                            Toggle(isOn: $isSpecial) {
                                Text("Special event")
                            }
                            Text("If the sport type does not support scores (e.g. cross country) this should be toggled on.")
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                        }
                    }
                    if !isSpecial {
                        Section(header: Text("Home Score")) {
                            TextField("Home score", text: $homescore)
                                //.keyboardType(.numberPad)
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
                    Button("Publish Changes") {
                        
                        title = editingevent.title
                        subtitle = editingevent.subtitle
                        isSpecial = isSpecial // MARK: add some code here
                        month = editingevent.month
                        day = editingevent.day
                        year = editingevent.year
                        var tempscore: [Int] = []
                        let score1 = Int(homescore) ?? 0
                        let score2 = Int(otherscore) ?? 0
                        tempscore = [score1, score2]
                        
                        let oldevent = editingevent
                        
                        editingevent = sportEvent(documentID: documentID, title: title, subtitle: subtitle, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)", isSpecial: isSpecial, score: tempscore, isUpdated: isUpdated)
                        
                        print(editingevent)
                        
                        
                        dataManager.deleteSportEventNews(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: oldevent)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            dataManager.createSportEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent)
                        }

                        
                        isPresentingEditEvent = false
                    }
                }
            }
            .navigationBarTitle("Edit Sport Events")
        }
    
        .alert(isPresented: $isPresentingConfirmEvent) { // not used
            Alert(
                title: Text("You Are Publishing Changes"),
                message: Text("Please double your inputs.\nThis action cannot be undone."),
                primaryButton: .destructive(Text("Publish")) {
                    
                    title = editingevent.title
                    subtitle = editingevent.subtitle
                    isSpecial = isSpecial // MARK: add some code here
                    month = editingevent.month
                    day = editingevent.day
                    year = editingevent.year
                    var tempscore: [Int] = []
                    let score1 = Int(homescore) ?? 0
                    let score2 = Int(otherscore) ?? 0
                    tempscore = [score1, score2]
                    
                    eventToDelete = sportEvent(documentID: documentID, title: title, subtitle: subtitle, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)", isSpecial: isSpecial, score: tempscore, isUpdated: isUpdated)
                    
                    if let eventToDelete = eventToDelete {
                        dataManager.deleteSportEventNews(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: eventToDelete)
                        dataManager.createSportEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent)
                    }
                
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        
    }
}

struct PastContentView_Previews: PreviewProvider {
    static var previews: some View {
        PastSportEventsAdminView(currentsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", favoritedusers: [], eventslink: "", imagedata: UIImage(), documentID: "NAN", sportid: "SPORT ID",  id: 1)).environmentObject(sportEventManager())
    }
}
