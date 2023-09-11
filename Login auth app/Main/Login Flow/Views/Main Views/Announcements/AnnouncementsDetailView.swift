import SwiftUI

struct AnnouncementsDetailView: View {
    var currentnews: Newstab
    var body: some View {
            ScrollView{
                VStack{
                    Text(currentnews.title)
                    //.padding(.leading,10)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                        .font(.system(size: 36, weight: .semibold, design: .rounded))
                        .lineLimit(2)
                    HStack{
                        Text(currentnews.publisheddate)
                        //.padding(.leading,13)
                            .foregroundColor(Color.gray)
                            .font(.system(size: 26, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                    }

                    Text(currentnews.description)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.black)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .padding(.horizontal, 25)
                        .padding(.vertical)
                        .background(Rectangle()
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .shadow(radius: 5, x: 3, y: 3)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                        .padding(.vertical)
                    Spacer()
                }
                .padding(.top)
            }
    }
}

struct AnnouncementsDetailView_Previews: PreviewProvider {
    var newsDataManager = Newslist()
    static var previews: some View {
        AnnouncementsDetailView(currentnews: Newstab(documentID: "testID", title: "This is my title yessir it pretty long", publisheddate: "Jan 5, 2023", description: "Description mouhwe gou weoguh weoug wneouwehg oweun woeung oweugh woe ngouwenf owuend woe ouwengouw efnoweu dnouweng owuehg oweunf ouwednouwe owuenc owueng owuen ouwn ouwenoguwe ouwendouwe gouwen owueh uowecnoweun wouenc weoug hwouenwo uenf.", newsimagename: "West Regents Logo"))
    }
}
