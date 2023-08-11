//
//  SportsNewsData.swift
//  West App
//
//  Created by August Andersen on 7/6/23.
//

import Foundation

struct sportNews: Identifiable, Codable {
    let newstitle: String
    let newsimage: [String]
    let newsdescription: String
    let newsdate: String
    let author: String
    var id = UUID()
    let sportid: Int

}

struct sportsNewslist{
    static let allsportsnewslist = [
        sportNews(
            newstitle: "JV Boys Basketball Places #2 at State",
            newsimage: ["basketball"],
            newsdescription: """
In a stunning display of skill and determination, the Madison West High School JV boys basketball team emerged as the runners-up at the highly anticipated state tournament held at the prestigious Oakridge Arena. Despite facing fierce competition from some of the state's most formidable teams, the Madison West Warriors showcased their undeniable talent, leaving their mark on the tournament and etching their names in the annals of the school's sports history.

The journey to the state tournament was nothing short of remarkable for the Madison West JV boys. Throughout the season, they displayed unwavering commitment, countless hours of practice, and an unyielding drive to succeed. Coached by the esteemed basketball veteran, Coach Johnson, the team underwent rigorous training sessions, refining their skills and developing a cohesive playing style that would prove to be a formidable force on the court.

As the state tournament unfolded, the Madison West Warriors made their intentions clear from the very first game. They showcased their prowess by overwhelming their opponents with a display of speed, precision, and tactical brilliance. Led by their exceptional point guard, Alex Thompson, who demonstrated unparalleled court vision and remarkable ball-handling skills, the team dismantled one opponent after another, leaving their fans in awe.

In the thrilling semifinal matchup against their arch-rivals, the Oakridge High School Eagles, the Madison West JV boys basketball team demonstrated their resilience and mental fortitude. The game was a seesaw battle from start to finish, with both teams refusing to back down. It was a clash of titans, as the roaring crowd witnessed an unforgettable display of sportsmanship and fierce competition. Although the game ended in a narrow defeat for Madison West, the team's performance showcased their ability to go toe-to-toe with the best and left a lasting impression on all those in attendance.

In the finals, Madison West faced the formidable Lincoln High School Tigers, who boasted an impressive record throughout the season. The tension in the arena was palpable as the crowd anticipated a showdown for the ages. The game was a testament to the Madison West Warriors' indomitable spirit and unwavering determination. They fought tooth and nail, trading baskets and making remarkable defensive stands. Despite their valiant efforts, the Tigers managed to secure a narrow victory, claiming the championship title by the slimmest of margins.

Despite falling short of the ultimate prize, the Madison West High School JV boys basketball team left the court with their heads held high, knowing they had given their all. Their extraordinary journey, marked by exceptional teamwork, individual brilliance, and an unyielding commitment to excellence, will forever be remembered by their devoted fans and the wider community.

Coach Johnson expressed immense pride in his team's achievements, stating, "These young athletes have shown remarkable growth and dedication throughout the season. Placing second at the state tournament is a testament to their hard work and the bright future that lies ahead for them. I couldn't be prouder of their accomplishments."

The Madison West High School JV boys basketball team's achievement serves as an inspiration for future athletes and underscores the school's commitment to fostering excellence in both sports and academics. As the Warriors bask in the glory of their second-place finish, their legacy will undoubtedly continue to inspire future generations, proving that with passion, determination, and a relentless pursuit of greatness, anything is possible.
""",
            newsdate: "Mar 9, 2023",
            author: "Zachary Dufrezne",
            sportid: 6),
        sportNews(
        newstitle: "Varsity Football Team Wins Regional Championship",
        newsimage: ["football"],
        newsdescription: "The Lincoln High School varsity football team emerged victorious in the regional championship, securing their spot in the state finals.",
        newsdate: "Nov 15, 2022",
        author: "Emily Thompson",
        sportid: 1),

        sportNews(
        newstitle: "Girls Varsity Soccer Team Clinches Conference Title",
        newsimage: ["soccer"],
        newsdescription: "The Oakridge High School girls' varsity soccer team dominated the conference and secured the championship title with an unbeaten record.",
        newsdate: "May 4, 2023",
        author: "Jennifer Ramirez",
        sportid: 2),

        sportNews(
        newstitle: "Swimming and Diving Team Shines at State Meet",
        newsimage: ["swimming"],
        newsdescription: "The Harborview High School swimming and diving team showcased their exceptional skills at the state meet, with several athletes claiming top positions and setting new records.",
        newsdate: "Feb 28, 2023",
        author: "Michael Sullivan",
        sportid: 3),

        sportNews(
        newstitle: "Cross Country Team Excels in Regional Championship",
        newsimage: ["cross country"],
        newsdescription: "The Sunset Valley High School cross country team exhibited outstanding performance at the regional championship, with both the boys' and girls' teams securing top positions.",
        newsdate: "Oct 22, 2022",
        author: "Sarah Anderson",
        sportid: 4),

        sportNews(
        newstitle: "Girls Varsity Volleyball Team Advances to State Semifinals",
        newsimage: ["volleyball"],
        newsdescription: "The Northridge High School girls' varsity volleyball team showcased their talent and determination, earning a spot in the state semifinals after a thrilling playoff match.",
        newsdate: "Nov 2, 2022",
        author: "Jessica Davis",
        sportid: 5),

        sportNews(
        newstitle: "Girls Varsity Softball Team Wins Divisional Championship",
        newsimage: ["softball"],
        newsdescription: "The Riverside High School girls' varsity softball team celebrated their divisional championship victory after a thrilling season filled with remarkable performances.",
        newsdate: "May 18, 2023",
        author: "Alexandra Johnson",
        sportid: 7),

        sportNews(
        newstitle: "Wrestling Team Dominates State Tournament",
        newsimage: ["wrestling"],
        newsdescription: "The Ridgemont High School wrestling team showcased their strength and skill at the state tournament, with several wrestlers claiming individual titles and the team earning the overall championship.",
        newsdate: "Feb 15, 2023",
        author: "Jason Roberts",
        sportid: 8),

        sportNews(
        newstitle: "Boys Varsity Baseball Team Clinches State Title",
        newsimage: ["baseball"],
        newsdescription: "The Jeffersonville High School boys' varsity baseball team emerged victorious in the state championship game, displaying remarkable teamwork and skill throughout the season.",
        newsdate: "Jun 5, 2023",
        author: "Daniel Martin",
        sportid: 9),

        sportNews(
        newstitle: "Girls Varsity Basketball Team Makes School History",
        newsimage: ["basketball2"],
        newsdescription: "The Lakeside High School girls' varsity basketball team made school history by clinching their first-ever state championship, leaving a lasting legacy for future generations.",
        newsdate: "Mar 18, 2023",
        author: "Stephanie Thompson",
        sportid: 10)
    ]
}

struct clubNews: Identifiable, Codable {
    let newstitle: String
    let newsimage: [String]
    let newsdescription: String
    let newsdate: String
    let author: String
    var id = UUID()
    let clubid: Int

}

struct clubsNewslist{
    static let allclubsnewslist = [
        clubNews(
        newstitle: "West High School Robotics Club Wins Regional Competition",
        newsimage: ["roboticsclub"],
        newsdescription: "The West High School Robotics Club celebrated a resounding victory at the highly competitive regional robotics competition. Their innovative robot design, precise programming, and strategic gameplay earned them the top spot, solidifying their reputation as one of the leading robotics teams in the state.",
        newsdate: "April 23, 2023",
        author: "Emily Thompson",
        clubid: 1),

        clubNews(
        newstitle: "West High School Debate Team Takes Home State Championship",
        newsimage: ["debateclub"],
        newsdescription: "The West High School Debate Team emerged triumphant at the state championship, showcasing their exceptional research skills, persuasive arguments, and impeccable public speaking abilities. Their dedication to critical thinking and effective communication earned them well-deserved recognition as the top debate team in the state.",
        newsdate: "March 12, 2023",
        author: "Jonathan Davis",
        clubid: 2),

        clubNews(
        newstitle: "West High School Science Olympiad Club Excels at National Level",
        newsimage: ["scienceclub"],
        newsdescription: "The West High School Science Olympiad Club showcased their scientific prowess at the national level, securing multiple top positions in various categories. Their extensive knowledge, rigorous preparation, and collaborative teamwork propelled them to success, highlighting their dedication to scientific exploration and discovery.",
        newsdate: "May 5, 2023",
        author: "Michelle Rodriguez",
        clubid: 3),

        clubNews(
        newstitle: "West High School Chess Club Dominates Regional Tournament",
        newsimage: ["chess"],
        newsdescription: "The West High School Chess Club demonstrated their mastery of strategy and critical thinking at the regional chess tournament, clinching numerous victories and emerging as the dominant force in the competition. Their passion for the game and dedication to honing their skills have solidified their position as a formidable chess club.",
        newsdate: "February 18, 2023",
        author: "Michael Sullivan",
        clubid: 4),

        clubNews(
        newstitle: "West High School Drama Club Receives Standing Ovation for Stellar Performance",
        newsimage: ["debateclub"],
        newsdescription: "The West High School Drama Club captivated audiences with their remarkable performance of the critically acclaimed play, leaving the crowd in awe and earning a well-deserved standing ovation. The club's exceptional acting skills, meticulous stage design, and seamless coordination made for an unforgettable theatrical experience.",
        newsdate: "November 29, 2022",
        author: "Sarah Anderson",
        clubid: 5),

        clubNews(
        newstitle: "West High School Photography Club Showcases Talent at State Exhibition",
        newsimage: ["photographyclub"],
        newsdescription: "The West High School Photography Club's artistic vision and technical expertise were on full display at the state photography exhibition. Their captivating compositions, mastery of light and shadow, and unique perspectives garnered praise from judges and fellow photographers alike, establishing the club as a creative force to be reckoned with.",
        newsdate: "June 9, 2023",
        author: "Alexandra Johnson",
        clubid: 6),

        clubNews(
        newstitle: "West High School Model United Nations Team Excels at International Conference",
        newsimage: ["mwdeca"],
        newsdescription: "The West High School Model United Nations (MUN) Team showcased their diplomacy and negotiation skills at an international conference, earning commendations for their in-depth research, persuasive speeches, and diplomatic prowess. Their ability to tackle complex global issues and propose effective solutions cemented their reputation as an exceptional MUN team.",
        newsdate: "March 27, 2023",
        author: "Jason Roberts",
        clubid: 7),

        clubNews(
        newstitle: "West High School Environmental Club Wins Statewide Conservation Award",
        newsimage: ["environmentalclub"],
        newsdescription: "The West High School Environmental Club's commitment to sustainability and environmental conservation was recognized with a prestigious statewide award. Their innovative initiatives, such as community clean-up campaigns, recycling drives, and awareness campaigns, have made a positive impact on the local ecosystem and inspired others to take action.",
        newsdate: "April 7, 2023",
        author: "Daniel Martin",
        clubid: 8),

        clubNews(
        newstitle: "West High School Music Club Achieves Perfect Scores at State Solo Competition",
        newsimage: ["piano"],
        newsdescription: "The West High School Music Club members showcased their exceptional musical talent and dedication at the state solo competition, earning perfect scores and accolades in various instrumental and vocal categories. Their commitment to musical excellence and hours of practice paid off, solidifying their status as exceptional musicians.",
        newsdate: "May 21, 2023",
        author: "Stephanie Thompson",
        clubid: 9),

        clubNews(
        newstitle: "West High School Coding Club Develops Award-Winning Mobile App",
        newsimage: ["codingclub"],
        newsdescription: "The West High School Coding Club's innovative mobile app received recognition at a national competition, where it was awarded first place for its user-friendly interface, seamless functionality, and creative design. The club's collaborative coding efforts and problem-solving skills were instrumental in the development of this groundbreaking application.",
        newsdate: "June 15, 2023",
        author: "David Wilson",
        clubid: 10)
    ]
}
