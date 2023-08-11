//
//  NewsTopsData.swift
//  West App
//
//  Created by Aiden Lee on 5/20/23.
//

import SwiftUI

struct Newstab: Identifiable {
    let id = UUID()
    let title:String
    let publisheddate:String // format: Jun 15, 2023, Feb 28, 1998, etc.
    let description: LocalizedStringKey
    let newsimagename: String
}

struct Newslist{
    
    static let topfive = [
        Newstab(title: "5/19 Announcements",
                publisheddate: "Jun 19, 2023",
                description: """
                Good Morning West Regents. Today is Friday, May 19th, 2023 and here are the morning announcements!
                
                Himalayan Diversity Club meets Mondays and Fridays at lunch in room 2030! Please come if you’re interested in learning about the Himalayan region and immigration experience.

                If you’re interested in computer science, come down to the programming club in the computer lab, room 1120, every Friday at lunch! The club will be a space to work on individual projects, as well as collaborative student-led group projects. We hope to see you there

                Join West High School Native American Student Association and MMSD in our Ho Chunk Land Acknowledgement TODAY May 19th during 4th period.  The ceremony will be held outside on Ash.  Keynote speaker is Arvina Martin, Ho Chunk Nation and alumna, other alumni include Jorge Saiz, Ponca Nation, and Little Priest Singers will provide Flag Song and Honor Song.  All are welcome.

                SSF is hosting a bake sale **TODAY** at lunch at the Ash entrance. Come celebrate Fine Arts Week with a sweet treat and some lemonade! Cash, venmo and cashapp are all accepted.

                The Lion's Den will close for the year on Wednesday May 24.  Make sure to get all of your purchases in before this date!.

                Congratulations to Madison West Rocket Club on their second place finish at Rockets for Schools last weekend.  The successful launch of their high power rocket along with the presentation of their scientific payload, "Enhanced Normalized Vegetation Index" earned the club a bid to NASA's Student Launch.  Congratulations to Gavin An, Oliver Gartler, Everett Gihring, Henry Leydon, Rowan Luedtke, Bjorn Rogall, Jack Rogge and Mary Sandwick Schroeder.

                Today is the last day to vote for MMSD’s Student Representative to the Board of Education and Student Senate President! Candidates running for Student Board Representative include **Talia Richmond** from West High School and **Lavenia Vulpal** from Memorial High School. The Student Senate President candidate is **Megan Finando** from West High School. The election form is in your emails - cast your vote before the end of the day!
                """,
                newsimagename: "Regents Logo"),
        Newstab(title: "5/18 Announcements",
                publisheddate: "May 18, 2023",
                description: """
**Good Morning West Regents. Today is Thursday, May 18th, 2023 and here are the morning announcements!**

**Peer Partners** meets in 130 at lunch every Thursday!

We have limited seats remaining in our Summer First-Time Credit classes. Complete this [form](https://docs.google.com/forms/d/e/1FAIpQLSfR70tpBS-TnDQAoR-AcdfYVyUddCpCenMp1UCjaaszsfiz7Q/viewform) and students will be added to selected classes as available on a first-come, first-serve basis.  If a class reaches capacity, students can be added to a waitlist. Review the 2023 Summer High School Course Catalog  (English; Spanish) for additional information on each course.

**Join West High School Native American Student Association** and MMSD in our Ho Chunk Land Acknowledgement this Friday, May 19th during 4th period.  The ceremony will be held outside on Ash.  Keynote speaker is Arvina Martin, Ho Chunk Nation and alumna, other alumni include Jorge Saiz, Ponca Nation, and Little Priest Singers will provide Flag Song and Honor Song.  All are welcome.

**SSF is hosting a bake sale this Friday** at lunch on the Ash entrance. Come celebrate Fine Arts Week with a sweet treat and some lemonade! Cash, venmo and cashapp are all accepted.

**Hey West Seniors!** If you're considering a gap year or are unsure what to do after graduation, you can apply to AmeriCorps with Achievement Connections or other Madison area programs. AmeriCorps is a meaningful opportunity to serve your community, earn an education award to help pay for college, receive personalized professional development, and earn a stipend for living costs. See Ms.Shing Vang in room 1254 to learn more about Achievement Connections and AmeriCorps opportunities.

**The Lion's Den** will close for the year on Wednesday May 24.  Make sure to get all of your purchases in before this date!

**Congratulations to the team of Wyatt Elmore, Henry Johnson, Bradley Vincent and Vivek Von Heimberg** who won the state Finance and Investment Challenge Bowl hosted by Asset Builders on Wednesday! Students who are interested in learning more about finances and investing should come to investment club Fridays at lunch in room 1209!
""",
                newsimagename: "Regents Logo"),
        Newstab(title: "News Number three!",
                publisheddate: "Oct 29, 1923",
                description: "The third ever news created!",
                newsimagename: "Regents Logo"),
        Newstab(title: "News Number four!",
                publisheddate: "May 20, 2023",
                description: "The fourth ever news created!",
                newsimagename: "Regents Logo"),
        Newstab(title: "Tuesday Incident Follow-up",
                publisheddate: "May 4, 2023",
                description: """
                Madison West Students and Families, I am following up on the communication sent by Mr. Kigeya on Tuesday (Re: Safety precautions at West today). In order to deter any future incidents, I would like to communicate with you behavioral expectations and potential consequences should a similar incident occur.
                
                Tuesday’s incident was in part due to a historical senior class ritual, commonly known as “senior assassins.” This game consists of students giving names of other seniors who are then targeted in a water gun game. This ritual is an entirely student-driven activity that is not supported nor sponsored by the school.
                
                Any student observed to be in possession of a water gun on campus or at any school sponsored event, will have it confiscated. Furthermore, in accordance with our District’s Behavior Education Plan, students could receive up to a three day out-of-school suspension for being “in possession of a toy weapon where the toy weapon is used to threaten, intimidate, or harm another person or to cause a disruption.”
                
                **Please note that any student who receives an out-of-school suspension this week or next week will not be allowed to attend Prom.**
                
                The safety of our school community continues to be of utmost importance to me and our Administrative team. If you have any questions or concerns, please do not hesitate to reach out to me directly.
                
                Sincerely,
                
                Katie Medema
                
                Dean of Students
                
                Madison West High School
                
                kmedema@madison.k12.wi.us
                """,
                newsimagename: "Regents Logo"),
        Newstab(title: "Fine Arts Week",
                publisheddate: "May 15, 2023",
                description: """
                Hello Regents,
                
                There is much to celebrate this week, starting with the 52nd Annual Fine Arts Week.  The arts are one of many things that make West special, and I am looking forward to catching performances and seeing the many exhibits showcasing student work. On Monday during 4th hour we will rededicate the Path of Voices monument on the front of the school. On Thursday is the annual Pottery Olympics at lunch in the temporary location on Van Hise on the steps near the Regent office, and the art sale and pottery auction will take place on Friday in the cafenasium during lunch. Families are welcome to attend Fine Arts week events. All families should report to the Welcome Center prior to attending.
                
                Best,

                Principal Dan Kigeya
                """,
                newsimagename: "Regents Logo"),
        Newstab(title: "News Number seven!",
                publisheddate: "May 21, 2023",
                description: "I made this just now",
                newsimagename: "Regents Logo"),
        Newstab(title: "Bridge Week Schedule",
                publisheddate: "Jun 21, 2023",
                description: "Schedule for upcoming bridge week:",
                newsimagename: "Regents Logo")
    ]
}
