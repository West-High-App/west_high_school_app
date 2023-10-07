import SwiftUI

struct PastSportEventsAdminView: View {
    var currentsport: sport
    @State var eventlist: [sportEvent] = []
    @StateObject var dataManager = sportEventManager.shared
    var editingeventslist: [sportEvent] {
        dataManager.pastSportsEvents
    }

    @State var temptitle = ""
    @State var isPresentingEditEvent = false
    @State var isPresentingConfirmEvent = false
    @State var eventToDelete: sportEvent?
    @State var eventToSave: sportEvent?
    
    @ObservedObject var userInfo = UserInfo.shared
    
    @State private var eventyear = ""
    let calendar = Calendar.current
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let days = Array(1...31)
    @State var years: [String] = []
    @State private var selectedYearIndex = 0
    @State private var selectedDayIndex = Calendar.current.component(.day, from: Date()) - 1
    @State var editingevent = sportEvent(documentID: "", arrayId: "", title: "", subtitle: "", month: "", day: "", year: "", publisheddate: "", isSpecial: false, score: [], isUpdated: false)
    
    @State var title = ""
    @State var subtitle = ""
    @State var month = ""
    @State var year = ""
    @State var arrayId = ""
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
                        VStack {
                            Text(event.month)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                            Text(event.day)
                                .font(.system(size: 32, weight: .regular, design: .rounded))
                                .foregroundColor(.black)

                        }
                        .foregroundColor(.red)
                        .frame(width:50,height:50)
                        Divider()
                            .padding(.vertical, 10)
                        VStack (alignment: .leading){
                            Text(event.title)
                                .font(.headline)
                            if !event.isSpecial {
                                Text(event.subtitle)
                                HStack {
                                    if event.score.count > 1 {
                                        if event.score[0] == 0 && event.score[1] == 0 {
                                            Text("Pending score...")
                                        } else {
                                            if event.score[0] > event.score[1] {
                                                Text(String(event.score[0]))
                                                Text("-")
                                                Text(String(event.score[1]))
                                                Text("(Win)")
                                                    .foregroundColor(.green)
                                            } else                                 if event.score[0] < event.score[1] {
                                                Text(String(event.score[0]))
                                                Text("-")
                                                Text(String(event.score[1]))
                                                Text("(Loss)")
                                                    .foregroundColor(.red)
                                            } else {
                                                Text(String(event.score[0]))
                                                Text("-")
                                                Text(String(event.score[1]))
                                                Text("(Tie)")
                                            }
                                        }
                                    } else {
                                        Text("Pending score...")
                                    }
                                }
                            } else {
                                Text(event.subtitle)
                            }
                        }
                    }.contextMenu {
                        Button("Edit") {
                            editingevent = event
                            isPresentingEditEvent = true
                        }.foregroundColor(.blue)
                    }
                    .onTapGesture {
                        editingevent = event
                        self.homescore = event.score.first == nil ? "" : "\(event.score.first!)"
                        self.otherscore = event.score.last == nil ? "" : "\(event.score.last!)"
                        self.isSpecial = event.isSpecial
                        self.subtitle = event.subtitle
                        isPresentingEditEvent = true
                    }
                }
            }
        }.navigationTitle("Edit Past Events")
        .onAppear {
//            dataManager.getSportsEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)") { events, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//                if let events = events {
//                    eventlist = events
//                    editingeventslist = dataManager.pastEventDictionary["\(currentsport.sportname) \(currentsport.sportsteam)"] ?? eventlist
//                }
//            }
            
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
                    if currentsport.adminemails.contains(userInfo.email) || userInfo.isAdmin || userInfo.isSportsAdmin{
                        HStack {
                            VStack {
                                Toggle(isOn: $isSpecial) {
                                    Text("Special event")
                                }
                                Text("If the sport type does not support scores (e.g. cross country) this should be toggled on.")
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                            }
                        }
                    }
                    if !isSpecial {
                        Section(header: Text("Home Score")) {
                            //TextField("Home score", text: $homescore)
                                //.keyboardType(.numberPad)
                            
                            NumericTextField(text: $homescore, displaytext: "Home score")
                        }
                        Section(header: Text("Opponent Score")) {
                            //TextField("Opponent score", text: $otherscore)
                                //.keyboardType(.numberPad)
                            
                            NumericTextField(text: $otherscore, displaytext: "Opponent score")
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
                        arrayId = editingevent.arrayId
                        var tempscore: [Int] = []
                        let score1 = Int(homescore) ?? 0
                        let score2 = Int(otherscore) ?? 0
                        tempscore = [score1, score2]
                        
                        let oldevent = editingevent
                        
                        editingevent = sportEvent(documentID: documentID, arrayId: arrayId, title: title, subtitle: subtitle, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)", isSpecial: isSpecial, score: tempscore, isUpdated: isUpdated)
                        
                        print(editingevent)
                        
                        // dataManager.updateSportEventScore(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent) <-- could use this but WHAAAt
                        
                        // HERE IS THE ISSUE
                        
//                        dataManager.deleteSportEventNews(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: oldevent) { error in
//                            if error == nil {
//                                dataManager.createSportEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent)
//                            }
//                        }
                        
                        dataManager.updateSportEventScore(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent)
                        
                        /*dataManager.deleteSportEventNews(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: oldevent)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            dataManager.createSportEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent)
                        }*/

                        
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
                    
                    eventToDelete = sportEvent(documentID: documentID, arrayId: editingevent.arrayId, title: title, subtitle: subtitle, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)", isSpecial: isSpecial, score: tempscore, isUpdated: isUpdated)
                    
                    dataManager.updateSportEventScore(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent)
                
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        
    }
}

struct PastContentView_Previews: PreviewProvider {
    static var previews: some View {
        PastSportEventsAdminView(currentsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], editoremails: [], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", favoritedusers: [], eventslink: "", rosterimage: "", rosterimagedata: UIImage(), imagedata: UIImage(), documentID: "NAN", sportid: "SPORT ID",  id: 1)).environmentObject(sportEventManager())
    }
}
