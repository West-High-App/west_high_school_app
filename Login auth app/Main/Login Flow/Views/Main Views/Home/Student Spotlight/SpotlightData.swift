//
//  StudentSpotLightData.swift
//  West App
//
//  Created by Aiden Lee on 5/29/23.
//

import SwiftUI

struct studentachievement: Identifiable{
    let id = UUID()
    let achievementtitle:String
    let achievementdescription:LocalizedStringKey
    let articleauthor:String
    let publisheddate:String
    let images:[String]
    
}
struct studentachievementlist{
    static let allstudentachievementlist = [
        studentachievement(achievementtitle: "Madison West Rocket Club Finishes Second Place",
        achievementdescription: """
        The Madison West Rocket Club recently achieved an impressive second-place finish at the Rockets for Schools competition. The club's hard work and dedication paid off as they successfully launched their high-power rocket and presented their scientific payload, titled "Enhanced Normalized Vegetation Index." The achievement earned them a coveted bid to NASA's Student Launch program. Led by student members Gavin An, Oliver Gartler, Everett Gihring, Henry Leydon, Rowan Luedtke, Bjorn Rogall, Jack Rogge, and Mary Sandwick Schroeder, the team showcased their exceptional skills and knowledge in rocketry. This achievement highlights the club's commitment to scientific exploration and innovation.
        """,
        articleauthor: "John Lennon",
        publisheddate: "May 1, 2023",
        images: ["rocketclub1", "rocketclub2", "rocketclub3"]),
        studentachievement(achievementtitle: "West High School Choir Wins State Championship",
        achievementdescription: """
        The West High School Choir emerged as champions at the state choral competition held last week. Their exceptional vocal skills, harmonies, and passionate performances impressed the judges and secured them the top spot. Under the guidance of their talented choir director, the students dedicated countless hours to perfecting their repertoire and honing their musical abilities. This remarkable achievement not only showcases the choir's talent but also reflects the school's commitment to fostering excellence in the arts. The West High School Choir has once again proven their position as one of the finest vocal ensembles in the state.
        """,
        articleauthor: "Emily Johnson",
        publisheddate: "April 25, 2023",
        images: ["choir1", "choir2", "choir3"]),
        studentachievement(achievementtitle: "West High School Robotics Team Advances to World Championships",
        achievementdescription: """
        The West High School Robotics Team has secured their place in the World Championships after a series of outstanding performances in regional competitions. The team's innovative robot design, effective problem-solving skills, and excellent teamwork have set them apart from their competitors. Led by their dedicated mentors, the students have demonstrated their technical expertise and commitment to STEM education. The qualification for the World Championships is a testament to the Robotics Team's exceptional capabilities and positions them as strong contenders on the global stage.
        """,
        articleauthor: "Sarah Thompson",
        publisheddate: "March 15, 2023",
        images: ["rocketclub2", "rocketclub1", "rocketclub3"]),
        studentachievement(achievementtitle: "West High School Debate Team Wins State Championship",
        achievementdescription: """
        The West High School Debate Team emerged victorious at the State Debate Championship, showcasing their exceptional critical thinking, research, and public speaking skills. The team's dedication, extensive preparation, and effective argumentation propelled them to the top. With numerous wins and strong performances throughout the season, the Debate Team has demonstrated their prowess in the realm of competitive debate. This achievement highlights the students' intellectual capabilities and the guidance of their dedicated coaches.
        """,
        articleauthor: "Michael Davis",
        publisheddate: "February 28, 2023",
        images: ["debate1", "debate2", "debate3"]),
        studentachievement(achievementtitle: "West High School Athlete Sets New State Record",
        achievementdescription: """
        A West High School athlete has made history by setting a new state record in their respective sport. With extraordinary talent, determination, and countless hours of training, the athlete achieved a remarkable feat that will be remembered for years to come. Their accomplishment not only brings pride to the school but also inspires fellow athletes to push their boundaries and strive for greatness. The student's achievement is a testament to their dedication, discipline, and the support they received from their coaches and teammates.
        """,
        articleauthor: "Jessica Martinez",
        publisheddate: "January 20, 2023",
        images: ["athlete1", "athlete2", "athlete3"]),
        studentachievement(achievementtitle: "West High School Drama Club Receives Outstanding Theater Production Award",
        achievementdescription: """
        The West High School Drama Club has been honored with the prestigious Outstanding Theater Production Award for their recent performance. The club's talented actors, dedicated crew members, and visionary directors brought a captivating story to life on stage, captivating audiences and leaving a lasting impact. This recognition not only celebrates the club's artistic achievements but also acknowledges their commitment to excellence in the performing arts. The Drama Club continues to inspire and entertain the community with their exceptional productions.
        """,
        articleauthor: "Emma Wilson",
        publisheddate: "December 10, 2022",
        images: ["drama1", "drama2", "drama3"])
    ]
}
