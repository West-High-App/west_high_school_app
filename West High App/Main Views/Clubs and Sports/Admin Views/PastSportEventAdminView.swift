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
    @State var editingevent = sportEvent(documentID: "", arrayId: "", title: "", subtitleLineOne: "", subtitleLineTwo: "", month: "", day: "", year: "", publisheddate: "", isSpecial: false, score: [], isUpdated: false)
    
    @State var title = ""
    @State var subtitleLineOne = ""
    @State var subtitleLineTwo = ""
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
                                Text(event.subtitleLineOne)
                                if !event.isSpecial {
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
                                                } else if event.score[0] < event.score[1] {
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
                                    if event.subtitleLineTwo.contains("$WIN$") {
                                        Text("Win")
                                            .foregroundColor(.green)
                                    } else if event.subtitleLineTwo.contains("$LOSS$") {
                                        Text("Loss")
                                            .foregroundColor(.red)
                                    }
                                    else if event.subtitleLineTwo.contains("$TIE$") {
                                        Text("Tie")
                                            .foregroundColor(.black)
                                    }
                                    else {
                                        Text(event.subtitleLineTwo.replacingOccurrences(of: "$CUSTOM$=", with: ""))
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
                                self.subtitleLineOne = event.subtitleLineOne
                                self.subtitleLineTwo = event.subtitleLineTwo
                                self.title = event.title
                                self.month = event.month
                                self.day = event.day
                                self.year = event.year
                                self.arrayId = event.arrayId
                                self.olddescription = event.subtitleLineOne
                                
                                
                                if event.subtitleLineTwo.contains("$CUSTOM$=") {
                                    selectedspecialeventtype = 3
                                }
                                if event.subtitleLineTwo.contains("$WIN$") {
                                    selectedspecialeventtype = 0
                                }
                                if event.subtitleLineTwo.contains("$LOSS$") {
                                    selectedspecialeventtype = 1
                                }
                                if event.subtitleLineTwo.contains("$TIE$") {
                                    selectedspecialeventtype = 2
                                }
                                
                                self.editingdescription = event.subtitleLineTwo
                                    .replacingOccurrences(of: "$CUSTOM$=", with: "")
                                    .replacingOccurrences(of: "$WIN$", with: "")
                                    .replacingOccurrences(of: "$LOSS$", with: "")
                                    .replacingOccurrences(of: "$TIE$", with: "")
                                
                                isPresentingEditEvent = true
                            }.foregroundColor(.blue)
                        }
                        .onTapGesture {
                            self.isSpecial = event.isSpecial
                            
                            if event.subtitleLineTwo.contains("$CUSTOM$=") {
                                selectedspecialeventtype = 3
                            }
                            if event.subtitleLineTwo.contains("$WIN$") {
                                selectedspecialeventtype = 0
                            }
                            if event.subtitleLineTwo.contains("$LOSS$") {
                                selectedspecialeventtype = 1
                            }
                            if event.subtitleLineTwo.contains("$TIE$") {
                                selectedspecialeventtype = 2
                            }
                            
                            if !event.isSpecial {
                                selectedspecialeventtype = 0
                            }
                            
                            editingevent = event
                            self.homescore = event.score.first == nil ? "" : "\(event.score.first!)"
                            self.otherscore = event.score.last == nil ? "" : "\(event.score.last!)"
                            self.subtitleLineOne = event.subtitleLineOne
                            self.subtitleLineTwo = event.subtitleLineTwo
                            self.title = event.title
                            self.month = event.month
                            self.day = event.day
                            self.year = event.year
                            self.arrayId = event.arrayId
                            self.olddescription = event.subtitleLineOne
                            if event.subtitleLineTwo.contains("$WIN$") || event.subtitleLineTwo.contains("$LOSS$") || event.subtitleLineTwo.contains("$TIE$") {
                                self.editingdescription = ""
                            } else if event.subtitleLineTwo.contains("$CUSTOM$=") {
                                self.editingdescription = event.subtitleLineTwo.replacingOccurrences(of: "$CUSTOM$=", with: "")
                            } else {
                                self.editingdescription = event.subtitleLineTwo
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
                        HStack {
                            VStack {
                                Toggle(isOn: $isSpecial) {
                                    Text("Custom event")
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
                                if currentsport.adminemails.contains(userInfo.email) || hasPermission.sports {
                                    TextField("Description", text: $editingdescription)
                                } else {
                                    Text("Ask your team administrator to enter a custom description.")
                                        .italic()
                                }
                            }
                        }
                    }
                    
                    if (currentsport.adminemails.contains(userInfo.email) || hasPermission.sports) || selectedspecialeventtype != 3 {
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
                            
                            if !editingdescription.contains("$CUSTOM$=") {
                                editingdescription = "$CUSTOM$=\(editingdescription)"
                            }
                            
                            editingevent = sportEvent(documentID: documentID, arrayId: arrayId, title: title, subtitleLineOne: subtitleLineOne, subtitleLineTwo: editingdescription, month: month, day: day, year: year, publisheddate: "\(month) \(day), \(year)", isSpecial: isSpecial, score: tempscore, isUpdated: true)
                            
                            print(editingevent)
                            
                            // dataManager.updateSportEventScore(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent) <-- could use this but WHAAAt
                            
                            // HERE IS THE ISSUE
                            
                            //                        dataManager.deleteSportEventNews(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: oldevent) { error in
                            //                            if error == nil {
                            //                                dataManager.createSportEvent(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent)
                            //                            }
                            //                        }
                            
                            dataManager.updateSportEventScore(forSport: "\(currentsport.sportname) \(currentsport.sportsteam)", sportEvent: editingevent)
                            subtitleLineOne = ""
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
                    } else {
                        Text("Publish Changes")
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
                    }
                }
            }
            .navigationBarTitle("Edit Sport Events")
        }
        
    }
}

struct PastContentView_Previews: PreviewProvider {
    static var previews: some View {
        PastSportEventsAdminView(currentsport: sport(sportname: "SPORT NAME", sportcoaches: ["COACH 1", "COACH 2"], adminemails: ["augustelholm@gmail.com"], editoremails: [], sportsimage: "basketball", sportsteam: "SPORTS TEAM", sportsroster: ["PLAYER 1", "PLAYER 2"], sportscaptains: [], tags: [1, 1, 1], info: "SPORT INFO", favoritedusers: [], eventslink: "", rosterimage: "", rosterimagedata: UIImage(), imagedata: UIImage(), documentID: "NAN", sportid: "SPORT ID",  id: UUID())).environmentObject(sportEventManager())
    }
}
