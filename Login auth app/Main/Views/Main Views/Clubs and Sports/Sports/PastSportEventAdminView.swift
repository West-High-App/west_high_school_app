import SwiftUI

struct PastSportEventsAdminView: View {
    var currentsport: sport
    @State var eventlist: [sportEvent] = []
    @StateObject var dataManager = sportEventManager.shared
    var editingeventslist: [sportEvent] {
        dataManager.pastEventDictionary["\(currentsport.sportname) \(currentsport.sportsteam)"] ?? []
    }

    @State var temptitle = ""
    @State var isPresentingEditEvent = false
    @State var isPresentingConfirmEvent = false
    @State var eventToDelete: sportEvent?
    @State var eventToSave: sportEvent?
    
    @State var selectedspecialeventtype = 0
    
    @ObservedObject var userInfo = UserInfo.shared
    @ObservedObject var hasPermission = PermissionsCheck.shared
    
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
    
    @State var olddescription: String = ""
    @State var editingdescription: String = ""
    var fulldescription: String {
        var part1 = ""
        
        print(olddescription)
        if olddescription.contains("\n") {
            part1 = olddescription.components(separatedBy: "\n")[1]
        } else {
            part1 = olddescription
        }
        
        let returnvalue = part1 + "\n" + editingdescription
        return returnvalue
    }
    
    @State var screen = ScreenSize()
    
    var body: some View {
        
        VStack {
            if !editingeventslist.isEmpty {
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
                            Spacer()
                                .frame(width: 10) // new
                            VStack (alignment: .leading){
                                Text(event.title)
                                    .font(.headline)
                                if !event.isSpecial {
                                    Text(event.subtitle)
                                    HStack {
                                        if event.score.count > 1 {
                                            if event.score[0] == 0 && event.score[1] == 0 && event.isUpdated == false {
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
                                        }
                                    }
                                } else { // MARK: new shit here
                                    if event.subtitle.contains("$WIN$") {
                                        Text(event.subtitle.components(separatedBy: "\n").first ?? "")
                                        Text("Win")
                                            .foregroundColor(.green)
                                    } else if event.subtitle.contains("$LOSS$") {
                                        Text(event.subtitle.components(separatedBy: "\n").first ?? "")
                                        Text("Loss")
                                            .foregroundColor(.red)
                                    }
                                    else if event.subtitle.contains("$TIE$") {
                                        Text(event.subtitle.components(separatedBy: "\n").first ?? "")
                                        Text("Tie")
                                            .foregroundColor(.black)
                                    }
                                    else {
                                        Text(event.subtitle)
                                    }
                                }
                                if !event.isUpdated {
                                    Text("Pending score...")
                                        .italic()
                                }
                            }
                        }.contextMenu {
                            Button("Edit") {
                                self.isSpecial = event.isSpecial
                                editingevent = event
                                self.homescore = event.score.first == nil ? "" : "\(event.score.first!)"
                                self.otherscore = event.score.last == nil ? "" : "\(event.score.last!)"
                                self.subtitle = event.subtitle
                                self.title = event.title
                                self.month = event.month
                                self.day = event.day
                                self.year = event.year
                                self.arrayId = event.arrayId
                                self.olddescription = event.subtitle
                                
                                
                                if event.subtitle.contains("\n") {
                                    selectedspecialeventtype = 3
                                }
                                if event.subtitle.contains("$WIN$") {
                                    selectedspecialeventtype = 0
                                }
                                if event.subtitle.contains("$LOSS$") {
                                    selectedspecialeventtype = 1
                                }
                                if event.subtitle.contains("$TIE$") {
                                    selectedspecialeventtype = 2
                                }
                                
                                
                                if event.subtitle.contains("\n") {
                                    self.editingdescription = event.subtitle.components(separatedBy: "\n")[1]
                                } else {
                                    self.editingdescription = event.subtitle
                                }
                                
                                isPresentingEditEvent = true
                            }.foregroundColor(.blue)
                        }
                        .onTapGesture {
                            self.isSpecial = event.isSpecial
                            
                            if event.subtitle.contains("\n") {
                                selectedspecialeventtype = 3
                            }
                            if event.subtitle.contains("$WIN$") {
                                selectedspecialeventtype = 0
                            }
                            if event.subtitle.contains("$LOSS$") {
                                selectedspecialeventtype = 1
                            }
                            if event.subtitle.contains("$TIE$") {
                                selectedspecialeventtype = 2
                            }
                            
                            editingevent = event
                            self.homescore = event.score.first == nil ? "" : "\(event.score.first!)"
                            self.otherscore = event.score.last == nil ? "" : "\(event.score.last!)"
                            self.subtitle = event.subtitle
                            self.title = event.title
                            self.month = event.month
                            self.day = event.day
                            self.year = event.year
                            self.arrayId = event.arrayId
                            self.olddescription = event.subtitle
                            if event.subtitle.contains("$WIN$") || event.subtitle.contains("$LOSS$") || event.subtitle.contains("$TIE$") {
                                self.editingdescription = ""
                            } else if event.subtitle.contains("\n") {
                                self.editingdescription = event.subtitle.components(separatedBy: "\n")[1]
                            } else {
                                self.editingdescription = event.subtitle
                            }
                            
                            isPresentingEditEvent = true
                        }
                    }
                }
            } else {
                VStack {
                    HStack {
                        Text("No past events.")
                            .lineLimit(1)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .padding(.leading, 18)
                        Spacer()    
                    }
                    Spacer()
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
        .onChange(of: self.isSpecial) { _ in
            print("Set isSpecial")
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
                    if currentsport.adminemails.contains(userInfo.email) || hasPermission.sports {
                        HStack {
                            VStack {
                                Toggle(isOn: $isSpecial) {
                                    Text("Custom event")
                                }
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
                        Section(header: Text("Event Type")) {
                            Picker("Outcome", selection: $selectedspecialeventtype) {
                                Text("Win")
                                    .tag(0)
                                Text("Loss")
                                    .tag(1)
                                Text("Tie")
                                    .tag(2)
                                Text("Manual Description")
                                    .tag(3)
                            }
                        }
                        
                        if selectedspecialeventtype == 3 {
                            Section(header: Text("Event Description")) {
                                TextField("Description", text: $editingdescription)
                            }
                        }
                    }
                    Button {
                        
                        let score1 = Int(homescore) ?? 0
                        let score2 = Int(otherscore) ?? 0
                        let tempscore = [score1, score2]
                        
                        var part1 = ""
                        
                        switch selectedspecialeventtype {
                            case 0:
                                editingdescription = "$WIN$";
                                break
                            case 1:
                                editingdescription = "$LOSS$";
                                break
                            case 2:
                                editingdescription = "$TIE$";
                                break
                            default:
                                break
                        }
                        
                        print(subtitle)
                        if subtitle.contains("\n") {
                            print("contains /n")
                            part1 = subtitle.components(separatedBy: "\n")[0] // [1]
                        } else {
                            print("doest not contain /n")
                            part1 = subtitle
                        }
                        
                        print("part 1")
                        print(part1)
                        print("part2")
                        print(editingdescription)
                        
                        var returnvalue = ""
                        
                        if isSpecial {
                            returnvalue = part1 + "\n" + editingdescription
                        } else {
                            returnvalue = subtitle
                        }
                        
                        
                        
                        editingevent = sportEvent(documentID: documentID, arrayId: arrayId, title: title, subtitle: returnvalue, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)", isSpecial: isSpecial, score: tempscore, isUpdated: true)
                        
                        print(editingevent)
                        
                        // dataManager.updateSportEventScore(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent) <-- could use this but WHAAAt
                        
                        // HERE IS THE ISSUE
                        
                        //                        dataManager.deleteSportEventNews(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: oldevent) { error in
                        //                            if error == nil {
                        //                                dataManager.createSportEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent)
                        //                            }
                        //                        }
                        
                        dataManager.updateSportEventScore(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent)
                        subtitle = ""
                        editingdescription = ""
                        /*dataManager.deleteSportEventNews(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: oldevent)
                         
                         DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                         dataManager.createSportEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent)
                         }*/
                        
                        
                        isPresentingEditEvent = false
                    } label: {
                        Text("Publish Changes")
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
        PastSportEventsAdminView(currentsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], editoremails: [], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", favoritedusers: [], eventslink: "", rosterimage: "", rosterimagedata: UIImage(), imagedata: UIImage(), documentID: "NAN", sportid: "SPORT ID",  id: UUID())).environmentObject(sportEventManager())
    }
}
