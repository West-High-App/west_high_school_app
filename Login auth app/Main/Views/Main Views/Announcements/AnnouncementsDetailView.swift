import SwiftUI

struct AnnouncementsDetailView: View {
    var currentnews: Newstab
    var body: some View {
            ScrollView {
                HStack {
                    Text(currentnews.title)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.5)
                        .lineLimit(2)
                        .padding(.leading)
                    Spacer()
                }
                HStack {
                    Text(currentnews.publisheddate)
                        .foregroundColor(Color.gray)
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .padding(.leading)
                    Spacer()
                }
                
                LinkTextView(text: currentnews.description)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .padding(.horizontal, 25)
                    .padding(.vertical, 10)
                    .background(Rectangle()
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .shadow(radius: 5, x: 3, y: 3)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                    .padding(.bottom)
            }
    }
}

struct HomeAnnouncementsDetailView: View {
    var currentnews: Newstab
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text(currentnews.title)
                        .foregroundColor(Color.black)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .lineLimit(2)
                        .padding(.leading)
                    Spacer()
                }
                HStack {
                    Text(currentnews.publisheddate)
                        .foregroundColor(Color.gray)
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .padding(.leading)
                    Spacer()
                }
                
                LinkTextView(text: currentnews.description)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.black)
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .padding(.horizontal, 25)
                    .padding(.vertical, 10)
                    .background(Rectangle()
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .shadow(radius: 5, x: 3, y: 3)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                    .padding(.bottom)
            }
        }
    }
}

struct AnnouncementsDetailView_Previews: PreviewProvider {
    var newsDataManager = Newslist()
    static var previews: some View {
        HomeAnnouncementsDetailView(currentnews: Newstab(documentID: "testID", title: "This is my title yessir it pretty long", publisheddate: "Jan 5, 2023", description: "Description mouhwe gou weoguh weoug wneouwehg oweun woeung oweugh woe ngouwenf owuend woe ouwengouw efnoweu dnouweng owuehg oweunf ouwednouwe owuenc owueng owuen ouwn ouwenoguwe ouwendouwe gouwen owueh uowecnoweun wouenc weoug hwouenwo uenf."))
    }
}
