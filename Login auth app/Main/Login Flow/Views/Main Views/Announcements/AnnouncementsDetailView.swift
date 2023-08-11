import SwiftUI

struct AnnouncementsDetailView: View {
    var currentnews: Newstab
    var body: some View {
        ZStack {
            ScrollView{
                VStack{
                    Image(currentnews.newsimagename)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .cornerRadius(15)
                    //.padding(.leading,10)
                    Text(currentnews.title)
                    //.padding(.leading,10)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                        .font(.system(size: 40, weight: .semibold, design: .rounded))
                    HStack{
                        Text(currentnews.publisheddate)
                        //.padding(.leading,13)
                            .foregroundColor(Color.gray)
                            .font(.system(size: 26, weight: .semibold, design: .rounded))
                    }

                    Text(currentnews.description)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.black)
                        .font(.system(size: 24, weight: .regular, design: .rounded))
                        .padding(.horizontal, 25)
                        .padding(.vertical)
                        .background(Rectangle()
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .shadow(radius: 5, x: 3, y: 3)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.94)))
                        .padding(.vertical)

                }
                .padding(.top)
            }
        }
    }
}

struct AnnouncementsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementsDetailView(currentnews: Newslist.topfive.first!)
    }
}
