import SwiftUI

private func callNumber(phoneNumber:String) {
  if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
    let application:UIApplication = UIApplication.shared
    if (application.canOpenURL(phoneCallURL)) {
        application.open(phoneCallURL, options: [:], completionHandler: nil)
    }
  }
}

struct ContactView: View {
    var body: some View {
        ScrollView(showsIndicators: false){
            ZStack{
                ZStack{
                    Rectangle()
                        .frame(height: 60)
                        .foregroundColor(Color(red: 41/255, green: 51/255, blue:145/255))
                    HStack{
                        Text("WEST HIGH SCHOOL")
                            .offset(x: 17, y:1)
                            .foregroundColor(Color(red: 240/255, green: 241/255, blue: 247/255))
                            .font(
                                .custom(
                                    "Devanagari Sangam MN",
                                    fixedSize: 13.4)
                                .weight(.semibold)
                            )
                        Spacer()
                    }
                    
                }
                ZStack{
                    Rectangle()
                        .frame(height:40)
                        .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255))
                        .offset(y:50)
                    HStack{
                        Image("mmsd")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:20)
                            .offset(y:50)

                        
                        Text("MADISON METROPOLITAN SCHOOL DISTRICT")
                            .font(
                                .custom(
                                    "Devanagari Sangam MN",
                                    fixedSize: 11)
                            )
                            .foregroundColor(Color(red: 240/255, green: 241/255, blue: 247/255))
                            .offset(y:50)
                        Spacer()
                    }
                    .padding(.leading)
                }
            }
            VStack{
                VStack{
                    HStack{
                        Text("West Contacts")
                            .padding(.leading)
                            .foregroundColor(.black)
                            .font(
                                .custom(
                                    "arial",
                                    fixedSize: 45)
                                .weight(.bold)
                            )
                            .padding(.bottom, 10)
                        Spacer()
                    }                    
                }
                .padding(.vertical,50)
            }
            .padding(.top, 30)
            .padding(.bottom, -30)

            VStack{
                DisclosureGroup("Main Phone"){
                    VStack(alignment:.leading){
                        HStack{
                            Image(systemName: "phone")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("Main Phone:")
                                    .padding(.leading,10)
                                Button {
                                    callNumber(phoneNumber: "6082044100")
                                } label: {
                                    Text("(608) 204-4100")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "phone")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("Fax:")
                                    .padding(.leading,10)
                                Button {
                                    callNumber(phoneNumber: "6082040529")
                                } label: {
                                    Text("(608) 204-0529")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                            }
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "phone")
                                .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("Registrar:                                                       ")
                                    .padding(.leading,10)
                                Button {
                                    callNumber(phoneNumber: "6082043064")
                                } label: {
                                    Text("(608) 204-3064")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .font(
                        .custom(
                            "arial",
                            fixedSize: 18)
                        .weight(.regular)
                    )
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.vertical, 10.0)
                    .background(Color(red: 240/255, green: 240/255, blue: 240/255) ,in: RoundedRectangle(cornerRadius: 25.0))
                }                                .font(
                    .custom(
                        "arial",
                        fixedSize: 24)
                    .weight(.semibold)
                    
                )
                .padding()
                .tint(.black)
                .foregroundColor(.black)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                .cornerRadius(20)
                .padding(.horizontal,5)
                
                
                DisclosureGroup("Attendance"){
                    VStack(alignment:.leading){
                        HStack{
                            Image(systemName: "phone")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("Ash Attendance:                                                ")
                                    .padding(.leading,10)
                                Button {
                                    callNumber(phoneNumber: "6082044116")
                                } label: {
                                    Text("(608) 204-4116")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                            
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "phone")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("Highland Attendance:")
                                    .padding(.leading,10)
                                Button {
                                    callNumber(phoneNumber: "6082043075")
                                } label: {
                                    Text("(608) 204-3075")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "phone")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("Regent Attendance:")
                                    .padding(.leading,10)
                                Button {
                                    callNumber(phoneNumber: "6082044108")
                                } label: {
                                    Text("(608) 204-4108")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "phone")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("Regent Attendance:")
                                    .padding(.leading,10)
                                Button {
                                    callNumber(phoneNumber: "6082043091")
                                } label: {
                                    Text("(608) 204-3091")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .font(
                        .custom(
                            "arial",
                            fixedSize: 18)
                        .weight(.regular)
                    )
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.vertical, 10.0)
                    .background(Color(red: 240/255, green: 240/255, blue: 240/255) ,in: RoundedRectangle(cornerRadius: 25.0))
                }                                .font(
                    .custom(
                        "arial",
                        fixedSize: 24)
                    .weight(.semibold)
                )
                .padding()
                .tint(.black)
                .foregroundColor(.black)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                .cornerRadius(20)
                .padding(.horizontal,5)
                
                
                
                
                DisclosureGroup("Athletics"){
                    VStack(alignment:.leading){
                        HStack{
                            Image(systemName: "person.crop.circle")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Corvonn Gaines** \nWest High School Athletic Director")
                                    .padding(.leading,10)
                                
                                Text("cjgaines@madison.k12.wi.us")
                                    .padding(.leading,10)
                                
                                Button {
                                    callNumber(phoneNumber: "6082043060")
                                } label: {
                                    Text("(608) 204-3060")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical)
                        HStack{
                            Image(systemName: "person.crop.circle")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Natalie Loranger**                                                 \nAthletic Secretary")
                                    .padding(.leading,10)
                                
                                Text("nkloranger@madison.k12.wi.us")
                                    .padding(.leading,10)
                                
                                Button {
                                    callNumber(phoneNumber: "608-204-4103")
                                } label: {
                                    Text("(608) 204-4103")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical)
                        
                        
                        
                    }
                    .font(
                        .custom(
                            "arial",
                            fixedSize: 18)
                        .weight(.regular)
                    )
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.vertical, 10.0)
                    .background(Color(red: 240/255, green: 240/255, blue: 240/255) ,in: RoundedRectangle(cornerRadius: 25.0))
                }                                .font(
                    .custom(
                        "arial",
                        fixedSize: 24)
                    .weight(.semibold)
                )
                .padding()
                .tint(.black)
                .foregroundColor(.black)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                .cornerRadius(20)
                .padding(.horizontal,5)
                
                DisclosureGroup("Counselor Contact"){
                    VStack(alignment:.leading){
                        HStack{
                            Image(systemName: "person.crop.circle")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Jaime Alvis** \nCounselor")
                                    .padding(.leading,10)
                                
                                Text("jsalvis@madison.k12.wi.us")
                                    .padding(.leading,10)
                                Link(destination: URL(string: "http://jsalvis.youcanbook.me")!) {
                                    Text("Book an Appointment")
                                        .padding(.leading,10)
                                        .foregroundColor(.blue)
                                }
                                
                                Button {
                                    callNumber(phoneNumber: "6082043087")
                                } label: {
                                    Text("(608) 204-3087")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "person.crop.circle")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Caleb Holzman** \nCounselor")
                                    .padding(.leading,10)
                                
                                Text("clholzman@madison.k12.wi.us")
                                    .padding(.leading,10)
                                
                                Button {
                                    callNumber(phoneNumber: "6082043194")
                                } label: {
                                    Text("(608) 204-3194")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                            }
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "person.crop.circle")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Yasmeen Badillo** \nCounselor")
                                    .padding(.leading,10)
                                
                                Text("ybadillo@madison.k12.wi.us")
                                    .padding(.leading,10)
                                Link(destination: URL(string: "https://calendar.app.google/A71cwog8iVvfiCB88")!) {
                                    Text("Book an Appointment")
                                        .padding(.leading,10)
                                        .foregroundColor(.blue)
                                }
                                
                                
                                Button {
                                    callNumber(phoneNumber: "6082044132")
                                } label: {
                                    Text("(608) 204-4132")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                            
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "person.crop.circle")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Karen Coombs** \nCounselor")
                                    .padding(.leading,10)
                                
                                Text("kecoombs@madison.k12.wi.us")
                                    .padding(.leading,10)
                                Link(destination: URL(string: "https://kecoombs.youcanbook.me/")!) {
                                    Text("Book an Appointment")
                                        .padding(.leading,10)
                                        .foregroundColor(.blue)
                                }
                                
                                
                                Button {
                                    callNumber(phoneNumber: "6082044134")
                                } label: {
                                    Text("(608) 204-4134")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "person.crop.circle")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Lianne Hoffman** \nCounselor")
                                    .padding(.leading,10)
                                
                                Text("lddavis@madison.k12.wi.us")
                                    .padding(.leading,10)
                                Link(destination: URL(string: "https://ldhoffman.youcanbook.me")!) {
                                    Text("Book an Appointment")
                                        .padding(.leading,10)
                                        .foregroundColor(.blue)
                                }
                                
                                
                                Button {
                                    callNumber(phoneNumber: "6082044130")
                                } label: {
                                    Text("(608) 204-4130")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "person.crop.circle")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Amanda Dyer**  \nCounselor")
                                    .padding(.leading,10)
                                
                                Text("acdyer@madison.k12.wi.us")
                                    .padding(.leading,10)
                                Link(destination: URL(string: "https://acdyer.youcanbook.me")!) {
                                    Text("Book an Appointment")
                                        .padding(.leading,10)
                                        .foregroundColor(.blue)
                                }
                                
                                
                                Button {
                                    callNumber(phoneNumber: "6082044133")
                                } label: {
                                    Text("(608) 204-4133")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "person.crop.circle")
                                .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Jane Glynn**  \nCounselor")
                                    .padding(.leading,10)
                                
                                Text("jlglynn@madison.k12.wi.us")
                                    .padding(.leading,10)
                                Link(destination: URL(string: "https://jlglynn.youcanbook.me/")!) {
                                    Text("Book an Appointment")
                                        .padding(.leading,10)
                                        .foregroundColor(.blue)
                                }
                                
                                
                                Button {
                                    callNumber(phoneNumber: "6082044135")
                                } label: {
                                    Text("(608) 204-4135")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "person.crop.circle")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Joanna Williams** \nCounselor")
                                    .padding(.leading,10)
                                
                                Text("jbwilliams2@madison.k12.wi.us")
                                    .padding(.leading,10)
                                Link(destination: URL(string: "https://jbwilliams2.youcanbook.me/")!) {
                                    Text("Book an Appointment")
                                        .padding(.leading,10)
                                        .foregroundColor(.blue)
                                }
                                
                                
                                Button {
                                    callNumber(phoneNumber:
                                                "6082044129")
                                } label: {
                                    Text("(608) 204-4129")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "person.crop.circle")                        .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Felissia Jackson** \nCounseling Secretary")
                                    .padding(.leading,10)
                                
                                Text("fjackson@madison.k12.wi.us")
                                    .padding(.leading,10)
                                
                                Button {
                                    callNumber(phoneNumber: "6082043073")
                                } label: {
                                    Text("(608) 204-3073")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                        HStack{
                            Image(systemName: "person.crop.circle")
                                .scaleEffect(1.5)
                            VStack(alignment: .leading){
                                Text("**Jen Roth**                                                             \nRegistrar")
                                    .padding(.leading,10)
                                
                                Text("jlroth@madison.k12.wi.us")
                                    .padding(.leading,10)
                                
                                Button {
                                    callNumber(phoneNumber: "6082043064")
                                } label: {
                                    Text("(608) 204-4135")
                                }
                                .foregroundColor(.blue)
                                .padding(.leading,10)
                                
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .font(
                        .custom(
                            "arial",
                            fixedSize: 18)
                        .weight(.regular)
                    )
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.vertical, 10.0)
                    .background(Color(red: 240/255, green: 240/255, blue: 240/255) ,in: RoundedRectangle(cornerRadius: 25.0))
                }                                .font(
                    .custom(
                        "arial",
                        fixedSize: 24)
                    .weight(.semibold)
                )
                .padding()
                .tint(.black)
                .foregroundColor(.black)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                .cornerRadius(20)
                .padding(.horizontal,5)
            }
            .padding(.horizontal, 5)
            
        }
        
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
    }
}

